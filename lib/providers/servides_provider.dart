import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:http/http.dart' as http;
import '../models/category.dart';

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

  PageController get pageController => _pageController;

  List<Category> get categories => _categories;

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  ServicesProvider() {
    loadCategories();
    notifyListeners();
  }

  late Category _category;

  Category get category => _category;

  set isLoading(bool value) {
    _isLoading = value;
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
}
