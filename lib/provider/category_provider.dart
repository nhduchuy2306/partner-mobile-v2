import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  final List<int> _selectedCategoryIds = [];

  List<int> get selectedCategoryIds => _selectedCategoryIds;

  void addCategoryId(int categoryId) {
    _selectedCategoryIds.add(categoryId);
    notifyListeners();
  }

  bool isSelectedCategoryId(int categoryId) {
    for (var item in _selectedCategoryIds) {
      if (item == categoryId) {
        return true;
      }
    }
    return false;
  }

  void removeCategoryId(int categoryId) {
    for (var item in _selectedCategoryIds) {
      if (item == categoryId) {
        _selectedCategoryIds.remove(item);
        notifyListeners();
        return;
      }
    }
  }

  void toggleCategoryId(int categoryId) {
    if (isSelectedCategoryId(categoryId)) {
      removeCategoryId(categoryId);
    } else {
      addCategoryId(categoryId);
    }
  }

  void clear() {
    _selectedCategoryIds.clear();
    notifyListeners();
  }
}
