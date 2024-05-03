import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_app/data/dummy_data.dart';
import 'package:flutter_app/models/category.dart';
import 'package:flutter_app/services/navigation.dart';
import 'package:flutter_app/widgets/category_grid_item.dart';

class HomeCategoriesTab extends StatefulWidget {
  const HomeCategoriesTab({super.key});

  @override
  State<HomeCategoriesTab> createState() => _HomeCategoriesTabState();
}

class _HomeCategoriesTabState extends State<HomeCategoriesTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final nav = Provider.of<NavigationService>(context, listen: false);
    nav.goMealsOnCategory(categoryId: category.id);
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween(
        begin: const Offset(0, 0.7),
        end: const Offset(0, 0),
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutCubic,
        ),
      ),
      child: GridView(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        children: [
          for (int i = 0; i < dummyCategories.values.length; i++)
            StaggeredAnimationItem(
              index: i,
              animationController: _animationController,
              child: CategoryGridItem(
                category: dummyCategories.values.elementAt(i),
                onSelectCategory: () {
                  _selectCategory(context, dummyCategories.values.elementAt(i));
                },
              ),
            ),
        ],
      ),
    );
  }
}

class StaggeredAnimationItem extends StatelessWidget {
  final int index;
  final AnimationController animationController;
  final Widget child;

  const StaggeredAnimationItem({
    super.key, 
    required this.index,
    required this.animationController,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    int rowIndex = index ~/ 2;
    int totalRow = (dummyCategories.values.length+1)~/2;
    // print(rowIndex);
    // print(totalRow);
    final double intervalStart = 0.5 / (totalRow-1) * rowIndex;
    // print(intervalStart);
    double intervalEnd = intervalStart + 0.5;
    if(intervalEnd > 1.0){
      intervalEnd = 1.0;
    }
    // print(intervalEnd);
    final Interval interval = Interval(intervalStart, intervalEnd, curve: Curves.easeOutCubic);

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, (totalRow - rowIndex).toDouble()),
        end: const Offset(0, 0),
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: interval,
        ),
      ),
      child: child,
    );
  }
}
