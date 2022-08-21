import 'package:flutter/material.dart';
import 'package:agenda_booking/models/service.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/category.dart';

class ServicesProvider with ChangeNotifier {
  List<Category> _categories = [];
  List<Category> get categories => _categories;

  bool _isLoading = false;

  ServicesProvider() {
    loadCategories();
    notifyListeners();
  }

  late  Category _category;
  Category get category => _category;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void selectCategory(Category category) {
    _category = category;
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
