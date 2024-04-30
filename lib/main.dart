import 'package:flutter/material.dart';
import 'package:flutter_app/data/dummy_data.dart';
import 'package:flutter_app/models/meal.dart';
import 'package:flutter_app/services/navigation.dart';
import 'package:flutter_app/state/favorite_meals_notifier.dart';
import 'package:flutter_app/state/filters_notifier.dart';
import 'package:flutter_app/state/filtered_meals_notifier.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 131, 57, 0),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Provide NavigationService
        Provider<NavigationService>(create: (_) => NavigationService()),
        // Provide global state
        Provider<List<Meal>>(create: (_) => dummyMeals),
        ChangeNotifierProvider<FavoriteMealsNotifier>(
            create: (_) => FavoriteMealsNotifier()),
        ChangeNotifierProvider<FiltersNotifier>(
            create: (_) => FiltersNotifier()),
        ChangeNotifierProxyProvider2<List<Meal>, FiltersNotifier,FilteredMealsNotifier>(
            create: (_) => FilteredMealsNotifier(),
            update: (_, allMeals, filtersNotifier, previousNotifier) => 
                previousNotifier!
                  ..updateFilteredMeals(allMeals, filtersNotifier.filters),
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: theme,
      routerConfig: routerConfig,
      // Allow the Navigator built by the MaterialApp to restore the navigation stack when app restarts
      restorationScopeId: 'app',
    );
  }
}
