import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/service.dart';

class ServicesProvider with ChangeNotifier {
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

  final PageController _pageController = PageController(initialPage: 0);
  List<Category> _categories = [];

  TextEditingController get searchController => _searchController;

  List<Category> get categories => _categories;
  late String _search;

  bool get isLoading => _isLoading;

  bool get isSearchVisible => _isSearchVisible;
  bool _isLoading = false;
  final TextEditingController _searchController =
      TextEditingController(text: '');
  bool _isSearchVisible = false;

  String get search => _search;

  ServicesProvider() {
    loadCategories();
  }

  PageController get pageController => _pageController;
  late Category _category;

  Category get category => _category;

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
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    notifyListeners();
  }

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    _categories = await getCategoriesWithServices();
    _category = (_categories.isNotEmpty ? _categories[0] : null)!;

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
    final url = Uri.http('192.168.100.4:8000', '/api/services/$id?date=$date');
    final response = await http.get(url);
    if(response.statusCode==200){
    }
    return null;
  }


}
