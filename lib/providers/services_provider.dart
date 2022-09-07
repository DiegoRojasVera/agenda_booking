import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/service.dart';
import '../models/stylist.dart';

class ServicesProvider with ChangeNotifier {
  ServicesProvider() {
    loadCategories();
  }

  final Map<String, IconData> icons = {
    'scissors': FontAwesome.scissors,
    'knife': RpgAwesome.knife,
    'mask': FontAwesome5.mask,
    'pump_soap': FontAwesome5.pump_soap,
    'hand_sparkles': FontAwesome5.hand_sparkles,
    'face': Icons.face,
    'airline_seat_legroom_extra': Icons.airline_seat_legroom_extra,
    'person_booth': FontAwesome5.person_booth,
  };

  final List<String> months = [
    'Ene',
    'Feb',
    'Mar',
    'Abr',
    'May',
    'Jun',
    'Jul',
    'Ago',
    'Sep',
    'Oct',
    'Nov',
    'Dic',
  ];
  final List<String> weekdays = [
    'Lu',
    'Mar',
    'Mir',
    'Jue',
    'Vie',
    'Sab',
    'Dom'
  ];

  void clean() {
    _stylist = null;
    _date = new DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, DateTime.now().hour + 2, 0, 0);
    notifyListeners();
  }

  Service? _bookingService;

  Service? get bookingService => _bookingService;

  set loadingService(bool value) {
    _isLoadingService = value;
    notifyListeners();
  }

  Future<void> loadServiceForBooking(Service service) async {
    _isLoadingService = true;
    notifyListeners();

    final int year = _date.year;
    final int month = _date.month;
    final int day = _date.day;
    String monthS = month < 10 ? "0$month" : "$month";
    String dayS = day < 10 ? "0$day" : "$day";

    _bookingService =
        (await getServiceForBooking(service.id, "$year-$monthS-$dayS"))!;

    _isLoadingService = false;
    notifyListeners();
  }

  final DateTime _minDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour + 2,
    0,
    0,
  );
  DateTime _date = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour + 2,
    0,
    0,
  );

  DateTime get currentDate => _date;

  DateTime get minDate => _minDate;

  int get year => _date.year;

  int get month => _date.month;

  int get day => _date.day;

  int get CountMontDays {
    return DateTime(_date.year, _date.month + 1, 0).day;
  }

  void subMonth(args) {
    notifyListeners();
  }

  void changeMonth(bool add) {
    int year = _date.year;

    if (!add && _date.month == 1) {
      year--;
    } else if (add && _date.month == 12) {
      year--;
    }

    int month = add ? _date.month + 1 : _date.month - 1;

    if (month == 0) {
      month = 12;
    } else if (month == 13) {
      month = 1;
    }

    int day = 1;

    if (_minDate.year == year && _minDate.month == month) {
      day = _minDate.day;
    }

    int hour = _date.hour;

    if (_minDate.year == year &&
        _minDate.month == month &&
        _minDate.day == day &&
        _minDate.hour > hour) {
      hour = _minDate.hour;
    }

    DateTime newDate = new DateTime(
      year,
      month,
      day, // Al cambiar el mes, poner el dia 1
      hour,
      0,
      0,
    );

    if (_minDate.compareTo(newDate) <= 0) {
      _date = newDate;
      notifyListeners();
    }
  }

  Stylist? _stylist;

  Stylist? get stylist => _stylist;

  set stylist(Stylist? value) {
    //Si se canbia de estilista despues de haber elegido una fecha y hora
    int attempts = 0;
    int startHour = 10;
    bool isSelectedDateInvalid = false;


    do {
      isSelectedDateInvalid = hasStylistDateLocked(value!, _date);
      attempts++;
      print("aca");
//      _isLoadingService = true;

      if (isSelectedDateInvalid) {
        hour = _date.hour < 20 ? startHour++ : 10;

      }
    } while (isSelectedDateInvalid && attempts < 30);
    // Si despues de varios intentos no hat fehca para el estilista
    //
    if (isSelectedDateInvalid == false) {
      _stylist = value;
    }


    notifyListeners();
  }

  bool hasStylistDateLocked(Stylist stylist, DateTime date) {
    bool isDateInvalid = false;
    int lockedDates = stylist.lockedDates
        .where((locked) => locked.compareTo(_date) == 0)
        .length;

    isDateInvalid = lockedDates > 0;
    return isDateInvalid;
  }

  set day(int value) {
    //como colocar el dia en una feche
    DateTime newDate =
        DateTime(_date.year, _date.month, value, _date.hour, 0, 0);

    if (_minDate.compareTo(newDate) <= 0) {
      _date = newDate;
      notifyListeners();
    }
  }

  set hour(int value) {
    DateTime newDate =
        DateTime(_date.year, _date.month, _date.day, value, 0, 0);
    if (_minDate.compareTo(newDate) <= 0) {
      _date = newDate;
      notifyListeners();
    }
  }

  PageController _pageController = PageController(initialPage: 0);

  PageController get pageController => _pageController;

  late Category _category;

  Category get category => _category;

  List<Category> _categories = [];

  List<Category> get categories => _categories;

  bool _isLoadingService = false;

  bool get isLoadingService => _isLoadingService;

  TextEditingController get searchController => _searchController;

  late String _search;

  bool get isLoading => _isLoading;

  bool get isSearchVisible => _isSearchVisible;
  bool _isLoading = false;
  final TextEditingController _searchController =
      TextEditingController(text: '');
  bool _isSearchVisible = false;

  String get search => _search;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set search(String value) {
    _search = value;
    notifyListeners();
  }

  set isSearchVisible(bool value) {
    _isSearchVisible = value;

    if (value = false) {
      _searchController.dispose();
      _search = '';
    }
    notifyListeners();
  }

  void selectCategory(Category category) {
    int index = _categories.indexOf(category);
    _category = category;
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    notifyListeners();
  }

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    _categories = await getCategoriesWithServices();
    _category = (_categories.length > 0 ? _categories[0] : null)!;

    _isLoading = false;
    notifyListeners();
  }


  Future<List<Category>> getCategoriesWithServices() async {
    final url = Uri.http('192.168.100.4:8000', '/api/services');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return categoriesFromJson(response.body);
    }

    return [];
  }

  Future<Service?> getServiceForBooking(int id, String date) async {
    final url = Uri.http('192.168.100.4:8000', '/api/services/$id', {
      'date': date,
    });
    final response = await http.get(url, headers: {
      'X-Requested-With': 'XMLHttpRequest',
    });

    if (response.statusCode == 200) {
      return serviceFromJson(response.body);
    }

    return null;
  }
}
