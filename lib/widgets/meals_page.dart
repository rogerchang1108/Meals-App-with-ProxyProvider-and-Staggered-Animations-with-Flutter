import 'package:flutter/material.dart';
import 'package:flutter_app/data/dummy_data.dart';
import 'package:flutter_app/models/meal.dart';
import 'package:flutter_app/services/navigation.dart';
import 'package:flutter_app/state/filtered_meals_notifier.dart';
import 'package:flutter_app/widgets/meals.dart';
import 'package:provider/provider.dart';

class MealsPage extends StatelessWidget {
  const MealsPage({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  void _selectMeal(BuildContext context, Meal meal) {
    final nav = Provider.of<NavigationService>(context, listen: false);
    nav.goMealDetailsOnCategory(categoryId: categoryId, mealId: meal.id);
  }

  @override
  Widget build(BuildContext context) {
    final category = dummyCategories[categoryId]!; 
    final filteredMeals = Provider.of<FilteredMealsNotifier>(context).filteredMeals;
    final meals = filteredMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
      ),
      body: Meals(
        meals: meals,
        onSelectMeal: _selectMeal,
      ),
    );
  }
}
