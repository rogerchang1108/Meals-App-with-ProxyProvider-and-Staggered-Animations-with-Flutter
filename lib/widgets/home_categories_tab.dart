import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_app/data/dummy_data.dart';
import 'package:flutter_app/models/category.dart';
import 'package:flutter_app/services/navigation.dart';
import 'package:flutter_app/widgets/category_grid_item.dart';

class HomeCategoriesTab extends StatelessWidget {
  const HomeCategoriesTab({super.key});

  void _selectCategory(BuildContext context, Category category) {
    final nav = Provider.of<NavigationService>(context, listen: false);
    nav.goMealsOnCategory(categoryId: category.id);
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      children: [
        // availableCategories.map((category) => CategoryGridItem(category: category)).toList()
        for (final category in dummyCategories.values)
          CategoryGridItem(
            category: category,
            onSelectCategory: () {
              _selectCategory(context, category);
            },
          )
      ],
    );
  }
}
