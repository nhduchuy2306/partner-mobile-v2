import 'package:flutter/material.dart';

class BrandProvider extends ChangeNotifier {
  final List<int> _selectedBrandIds = [];

  List<int> get selectedBrandIds => _selectedBrandIds;

  void addBrandId(int brandId) {
    _selectedBrandIds.add(brandId);
    notifyListeners();
  }

  bool isSelectedBrandId(int brandId) {
    for (var item in _selectedBrandIds) {
      if (item == brandId) {
        return true;
      }
    }
    return false;
  }

  void removeBrandId(int brandId) {
    for (var item in _selectedBrandIds) {
      if (item == brandId) {
        _selectedBrandIds.remove(item);
        notifyListeners();
        return;
      }
    }
  }

  void clear() {
    _selectedBrandIds.clear();
    notifyListeners();
  }
}
