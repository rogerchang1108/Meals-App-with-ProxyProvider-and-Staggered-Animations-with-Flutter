import 'package:flutter/material.dart';
import 'package:flutter_app/models/meal.dart';
import 'package:flutter_app/state/favorite_meals_notifier.dart';
import 'package:provider/provider.dart';

class MealDetailsPage extends StatefulWidget {
  const MealDetailsPage({
    super.key,
    required this.mealId,
  });

  final String mealId;

  @override
  State<MealDetailsPage> createState() => _MealDetailsPageState();
}

class _MealDetailsPageState extends State<MealDetailsPage> {
  double _titleOpacity = 0.0;

  void _updateTitleOpacity(double scrollOffset) {
    final opacity = scrollOffset / 240.0;
    setState(() {
      _titleOpacity = opacity.clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final meal = Provider.of<List<Meal>>(context, listen: false)
        .firstWhere((meal) => meal.id == widget.mealId);
    final favoriteMealsNotifier = Provider.of<FavoriteMealsNotifier>(context);
    final isFavorite = favoriteMealsNotifier.favoriteMeals.contains(meal);

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollUpdateNotification) {
            _updateTitleOpacity(notification.metrics.pixels);
          }
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Opacity(
                opacity: _titleOpacity,
                child: Text(meal.title),
              ),
              expandedHeight: 240.0,
              pinned: true,
              elevation: 0, // Remove shadow
              stretch: true,
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      meal.imageUrl,
                      fit: BoxFit.cover,
                    ),
                    // Gradient overlay
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.black54,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    favoriteMealsNotifier.toggleMealFavoriteStatus(meal);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isFavorite
                            ? 'Meal removed from favorites.'
                            : 'Meal added to favorites.'),
                      ),
                    );
                  },
                  // icon: Icon(isFavorite ? Icons.star : Icons.star_border),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    // This transitionBuilder applies to both the entering and exiting child widgets. We determine if the child is entering or exiting to apply the rotation in a way that both widgets appear to rotate in the same direction. Additionally, FadeTransition ensures that the entering widget fades in while the exiting widget fades out.
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      // Determine if the child is entering or exiting
                      final isEntering = child.key == ValueKey(isFavorite);
                      return FadeTransition(
                          // Entering child fades in; existing child fades out
                          opacity: animation,
                          child: RotationTransition(
                            turns: Tween<double>(
                              begin: 0.0,
                              end:
                                  0.4, // multiplier of 0.2 to fit pentagram star icon
                            ).animate(isEntering
                                ? animation
                                // Apply a rotation animation. The direction is adjusted for entering and exiting widgets to ensure they rotate in the same manner.
                                : ReverseAnimation(animation)),
                            child: child,
                          ));
                    },
                    child: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      key: ValueKey(isFavorite),
                    ),
                  ),
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                // fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Ingredients',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        for (final ingredient in meal.ingredients)
                          Text(
                            ingredient,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                          ),
                        const SizedBox(height: 24),
                        Text(
                          'Steps',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        for (final step in meal.steps)
                          Text(
                            step,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
