import 'package:flutter/material.dart';
import 'package:flutter_app/services/navigation.dart';
import 'package:flutter_app/state/favorite_meals_notifier.dart';
import 'package:flutter_app/widgets/meals.dart';
import 'package:provider/provider.dart';

class HomeFavoriteTab extends StatelessWidget {
  const HomeFavoriteTab({super.key});

  void _selectMeal(BuildContext context, meal) {
    final nav = Provider.of<NavigationService>(context, listen: false);
    nav.goMealDetailsOnFavorites(mealId: meal.id);
  }

  @override
  Widget build(BuildContext context) {
    final meals = Provider.of<FavoriteMealsNotifier>(context).favoriteMeals;

    return Meals(
      meals: meals,
      onSelectMeal: _selectMeal,
    );
  }
}
