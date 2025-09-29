import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_recipe_app/screens/recipe_list_screen.dart';
import 'package:food_recipe_app/models/recipe.dart';
import 'package:food_recipe_app/services/database_helper.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => RecipeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RecipeListScreen(),
    );
  }
}

class RecipeProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];
  DatabaseHelper _dbHelper = DatabaseHelper();

  List<Recipe> get recipes => _recipes;

  RecipeProvider() {
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    _recipes = await _dbHelper.getRecipes();
    notifyListeners();
  }

  Future<void> addRecipe(Recipe recipe) async {
    await _dbHelper.insertRecipe(recipe);
    await loadRecipes();
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await _dbHelper.updateRecipe(recipe);
    await loadRecipes();
  }

  Future<void> deleteRecipe(int id) async {
    await _dbHelper.deleteRecipe(id);
    await loadRecipes();
  }
}