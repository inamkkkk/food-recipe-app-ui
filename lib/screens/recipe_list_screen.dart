import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_recipe_app/models/recipe.dart';
import 'package:food_recipe_app/screens/recipe_detail_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({Key? key}) : super(key: key);

  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    List<Recipe> recipes = recipeProvider.recipes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(recipe: recipe),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      recipe.description,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRecipeDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddRecipeDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController ingredientsController = TextEditingController();
    TextEditingController instructionsController = TextEditingController();

    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text('Add New Recipe'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: "Recipe Name"),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: "Description"),
              ),
              TextField(
                controller: ingredientsController,
                decoration: const InputDecoration(hintText: "Ingredients (comma separated)"),
              ),
              TextField(
                controller: instructionsController,
                decoration: const InputDecoration(hintText: "Instructions"),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Add'),
            onPressed: () {
              String name = nameController.text;
              String description = descriptionController.text;
              String ingredientsString = ingredientsController.text;
              String instructions = instructionsController.text;

              List<String> ingredients = ingredientsString.split(',');

              Recipe newRecipe = Recipe(
                id: DateTime.now().millisecondsSinceEpoch,
                name: name,
                description: description,
                ingredients: ingredients,
                instructions: instructions,
              );

              Provider.of<RecipeProvider>(context, listen: false).addRecipe(newRecipe);

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }
}
