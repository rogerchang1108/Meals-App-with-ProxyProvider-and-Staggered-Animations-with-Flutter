import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/filters_page.dart';
import 'package:flutter_app/widgets/home_page.dart';
import 'package:flutter_app/widgets/meal_details_page.dart';
import 'package:flutter_app/widgets/meals_page.dart';
import 'package:go_router/go_router.dart';

final routerConfig = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/categories',
      pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: HomePage(selectedTab: HomeTab.categories)),
      routes: <RouteBase>[
        GoRoute(
          path: 'filters',
          builder: (context, state) => const FiltersPage(),
        ),
        GoRoute(
          path: ':categoryId/meals',
          builder: (context, state) =>
              MealsPage(categoryId: state.pathParameters['categoryId']!),
          routes: <RouteBase>[
            GoRoute(
              path: ':mealId',
              builder: (context, state) =>
                  MealDetailsPage(mealId: state.pathParameters['mealId']!),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/favorites',
      pageBuilder: (context, state) => const NoTransitionPage<void>(
          child: HomePage(selectedTab: HomeTab.favorites)),
      routes: <RouteBase>[
        GoRoute(
          path: 'filters',
          builder: (context, state) => const FiltersPage(),
        ),
        GoRoute(
          path: ':mealId',
          builder: (context, state) =>
              MealDetailsPage(mealId: state.pathParameters['mealId']!),
        ),
      ],
    ),
  ],
  initialLocation: '/categories',
  debugLogDiagnostics: true,
  redirect: (context, state) {
    final currentPath = state.uri.path;
    if (currentPath == '/') {
      return '/categories';
    }
    // No redirection needed for other routes
    return null;
  },
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri.path}'),
    ),
  ),
);

class NavigationService {
  late final GoRouter _router;

  NavigationService() {
    _router = routerConfig;
  }

  String _currentPath(BuildContext context) {
    return GoRouterState.of(context).uri.path;
  }

  void goHome({required HomeTab tab}) {
    _router.go('/${tab.name}');
  }

  // To work  with the web browser history, do not use Navigator.push() or pop() directly
  void pushFiltersOnHome({required BuildContext context}) {
    var path = _currentPath(context);
    switch (path) {
      case '/categories':
        _router.go('/categories/filters');
        return;
      case '/favorites':
        _router.go('/favorites/filters');
        return;
    }
    throw Exception('Cannot push filters on the path: $path');
  }

  void goMealsOnCategory({required String categoryId}) {
    _router.go('/categories/$categoryId/meals');
  }

  void goMealDetailsOnCategory(
      {required String categoryId, required String mealId}) {
    _router.go('/categories/$categoryId/meals/$mealId');
  }

  void goMealDetailsOnFavorites({required String mealId}) {
    _router.go('/favorites/$mealId');
  }
}
