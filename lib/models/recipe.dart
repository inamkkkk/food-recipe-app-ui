class Recipe {
  int id;
  String name;
  String description;
  List<String> ingredients;
  String instructions;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.instructions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ingredients': ingredients.join(','), // Store ingredients as comma separated string
      'instructions': instructions,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      ingredients: map['ingredients'].split(','), // Split comma separated string back to list
      instructions: map['instructions'],
    );
  }
}