import 'package:flutter/material.dart';
import 'package:flutter_app/models/meal.dart';
import 'package:flutter_app/state/filters_notifier.dart';

class FilteredMealsNotifier with ChangeNotifier {
  List<Meal> _filteredMeals = [];

  FilteredMealsNotifier(List list);

  List<Meal> get filteredMeals => _filteredMeals;
  
  void update(List<Meal> allMeals, Map<Filter, bool> activeFilters){
    _filteredMeals = allMeals.where((meal) {
      if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (activeFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
    notifyListeners();
  }
}
