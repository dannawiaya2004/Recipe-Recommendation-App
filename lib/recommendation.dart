import 'package:flutter/material.dart';

class RecommendationPage extends StatefulWidget {
  final List<String> userIngredients;
  final String selectedFlavor;
  final bool veganOnly; // Checkbox state passed from IngredientsPage

  const RecommendationPage({
    Key? key,
    required this.userIngredients,
    required this.selectedFlavor,
    required this.veganOnly,
  }) : super(key: key);

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  final List<Map<String, dynamic>> recipes = [
    {
      'name': 'Pasta with Tomato Sauce',
      'ingredients': ['pasta', 'tomato', 'garlic', 'olive oil'],
      'flavor': 'Salty',
      'vegan': true,
    },
    {
      'name': 'Chocolate Cake',
      'ingredients': ['flour', 'sugar', 'cocoa', 'eggs'],
      'flavor': 'Sweet',
      'vegan': false,
    },
    {
      'name': 'Omelette',
      'ingredients': ['eggs', 'milk', 'butter', 'salt'],
      'flavor': 'Salty',
      'vegan': false,
    },
    {
      'name': 'Fruit Salad',
      'ingredients': ['apple', 'banana', 'orange', 'honey'],
      'flavor': 'Sweet',
      'vegan': true,
    },
  ];

  Color backgroundColor = Colors.white;

  List<Map<String, dynamic>> getRecommendedRecipes() {
    List<Map<String, dynamic>> recommendations = [];

    for (var recipe in recipes) {
      if (recipe['flavor'] != widget.selectedFlavor) continue;

      if (widget.veganOnly && !recipe['vegan']) continue;

      List<String> recipeIngredients = recipe['ingredients'];
      List<String> missingIngredients = recipeIngredients
          .where((ingredient) => !widget.userIngredients.contains(ingredient))
          .toList();

      if (missingIngredients.length < recipeIngredients.length) {
        recommendations.add({
          'name': recipe['name'],
          'missing': missingIngredients,
        });
      }
    }

    return recommendations;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> recommendedRecipes = getRecommendedRecipes();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendation Page'),
        centerTitle: true,
      ),
      body: Container(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Recommended Recipes:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<Color>(
                value: backgroundColor,
                items: const [
                  DropdownMenuItem(
                    value: Colors.white,
                    child: Text('White Background'),
                  ),
                  DropdownMenuItem(
                    value: Colors.lightBlue,
                    child: Text('Blue Background'),
                  ),
                  DropdownMenuItem(
                    value: Colors.greenAccent,
                    child: Text('Green Background'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    backgroundColor = value!;
                  });
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: recommendedRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recommendedRecipes[index];
                    return Card(
                      child: ListTile(
                        title: Text(recipe['name']),
                        subtitle: Text(
                          recipe['missing'].isEmpty
                              ? 'You have all the ingredients!'
                              : 'Missing: ${recipe['missing'].join(', ')}',
                        ),
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.navigate_before, size: 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
