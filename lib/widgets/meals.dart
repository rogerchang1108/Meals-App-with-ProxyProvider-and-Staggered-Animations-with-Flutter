import 'package:flutter/material.dart';
import 'package:flutter_app/models/meal.dart';
import 'package:flutter_app/widgets/meal_item.dart';

class Meals extends StatelessWidget {
  const Meals({
    super.key,
    required this.meals,
    required this.onSelectMeal,
  });

  final List<Meal> meals;
  final void Function(BuildContext context, Meal meal) onSelectMeal;

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return Center(
        child: Text(
          'No meals to show here.',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }

    return ListView.builder(
      itemCount: meals.length,
      itemBuilder: (ctx, index) => Padding(
        padding:
            EdgeInsets.fromLTRB(16, 16, 16, index == meals.length - 1 ? 16 : 0),
        child: MealItem(
          meal: meals[index],
          onSelectMeal: onSelectMeal,
        ),
      ),
    );
  }
}
