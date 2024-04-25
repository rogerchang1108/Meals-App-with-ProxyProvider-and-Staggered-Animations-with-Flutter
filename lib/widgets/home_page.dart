import 'package:flutter/material.dart';
import 'package:flutter_app/services/navigation.dart';
import 'package:flutter_app/state/filters_notifier.dart';
import 'package:flutter_app/widgets/home_categories_tab.dart';
import 'package:flutter_app/widgets/home_drawer.dart';
import 'package:flutter_app/widgets/home_favorites_tab.dart';
import 'package:provider/provider.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

enum HomeTab {
  categories,
  favorites,
}

class HomePage extends StatelessWidget {
  final HomeTab selectedTab;

  const HomePage({super.key, required this.selectedTab});

  void _tapBottomNavigationBarItem(BuildContext context, index) {
    final nav = Provider.of<NavigationService>(context, listen: false);
    nav.goHome(tab: index == 0 ? HomeTab.categories : HomeTab.favorites);
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tabs = [
      {
        'page': const HomeCategoriesTab(),
        'title': 'Categories',
      },
      {
        'page': const HomeFavoriteTab(),
        'title': 'Your Favorites',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(tabs[selectedTab.index]['title']),
      ),
      drawer: const HomeDrawer(),
      body: tabs[selectedTab.index]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => _tapBottomNavigationBarItem(context, index),
        currentIndex: selectedTab.index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
