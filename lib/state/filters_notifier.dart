import 'package:flutter/material.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersNotifier extends ChangeNotifier {
  Map<Filter, bool> _filters = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegetarian: false,
    Filter.vegan: false,
  };

  Map<Filter, bool> get filters => _filters;

  void setFilters(Map<Filter, bool> chosenFilters) {
    _filters = chosenFilters;
    notifyListeners();
  }

  void setFilter(Filter filter, bool isActive) {
    _filters[filter] = isActive;
    notifyListeners();
  }
}
