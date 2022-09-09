import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class BookingProvider with ChangeNotifier{
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value){
    _isLoading= value;
    notifyListeners();
  }

  Future<bool>save() async {
    final url = Uri.http('192.168.100.4:8000', '/api/services');
    Map<String, String >data={
      'dated_at':'',
      'stylist':'',
      'service_id':'',
    };
        final response = await http.post(url, headers: {
      'X-Requested-With': 'XMLHttpRequest',
    });
        print(response.statusCode);
          print(response.body);


    return response.statusCode==200;

  }
}