import 'dart:convert';
import 'package:agenda_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookingProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  int? _stylistId;
  int? _serviceId;
  DateTime? _datedAt;

  void initData(int stylistId, int serviceId, DateTime datedAt) {
    _stylistId = stylistId;
    _serviceId = serviceId;
    _datedAt = datedAt;
  }

  Validation _name = Validation();
  String get name => _name.value!;
  String? get nameError => _name.error;

  set name(String value) {
    String? errorLength = Validation.hasValidLength(value, min: 5, max: 30);

    if (errorLength != null) {
      _name = Validation(error: errorLength);
    } else {
      _name = Validation(value: value);
    }

    notifyListeners();
  }

  Validation _phone = Validation();
  String? get phone => _phone.value;
  String? get phoneError => _phone.error;

  set phone(String? value) {
    String? errorLength = Validation.hasValidLength(value!, min: 7, max: 20);
    if (errorLength != null) {
      _phone = Validation(error: errorLength);
    } else {
      _phone = Validation(value: value);
    }

    notifyListeners();
  }

  bool get canSend {
    if (_name.isEmptyOrHasError) return false;
    if (_phone.isEmptyOrHasError) return false;
    if (_phone.isEmptyOrHasError) return false;
    if (_stylistId == null) return false;
    if (_serviceId == null) return false;
    if (_datedAt == null) return false;
    return true;
  }

  void clean() {
    _stylistId = null;
    _serviceId = null;
    _datedAt = null;
    _name = Validation();
    _phone = Validation();
    notifyListeners();
  }

  Future<bool> save() async {
    final url = Uri.http('192.168.100.4:8000', '/api/services');
    final Map<String, dynamic> data = {
      'client': {
        'name': _name.value,
        'phone': _phone.value,
      },
      'dated_at': '${formatTimestamp(_datedAt!)}',
      'stylist_id': '$_stylistId',
      'service_id': '$_serviceId',
    };
    final response = await http.post(
      url,
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(data),
    );
    print(data);
    print(response.statusCode);
    print(response.body);
    return response.statusCode == 200;
  }
}

class Validation {
  String? value;
  String? error;

  Validation({this.value, this.error});

  bool? get isEmpty {
    if (value == null) return true;
    return value?.isEmpty;
  }

  bool get hasError => error != null;

  bool get isEmptyOrHasError => isEmpty! || hasError;

  static String? hasValidLength(String value, {required int min, required int max}) {
    if (min != null && value != null && value.length < min) {
      return "La longitud de texto minima es $min";
    }
    if (max != null && value != null && value.length > max) {
      return "La longitud de texto máxima es $max";
    }
    return null;
  }
}

