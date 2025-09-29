import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:food_recipe_app/models/recipe.dart';
import 'dart:io' as io;

class DatabaseHelper {
  static const _databaseName = 'recipe_database.db';
  static const _databaseVersion = 1;

  static const table = 'recipes';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        ingredients TEXT NOT NULL,
        instructions TEXT NOT NULL
      )
      ''');
  }

  Future<int> insertRecipe(Recipe recipe) async {
    Database db = await instance.database;
    return await db.insert(table, recipe.toMap());
  }

  Future<List<Recipe>> getRecipes() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);

    return List.generate(maps.length, (i) {
      return Recipe.fromMap(maps[i]);
    });
  }

  Future<int> updateRecipe(Recipe recipe) async {
    Database db = await instance.database;
    return await db.update(
      table,
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<int> deleteRecipe(int id) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}