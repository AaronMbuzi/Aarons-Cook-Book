import 'package:flutter/material.dart';
import '../services/meal_service.dart';
import '../models/meal.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  
  const MealDetailScreen({super.key, required this.mealId});
  
  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  late Future<Meal> _mealFuture;
  final MealService _mealService = MealService();
  
  @override
  void initState() {
    super.initState();
    _mealFuture = _mealService.getMealById(widget.mealId);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Meal>(
        future: _mealFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          if (!snapshot.hasData) {
            return const Center(child: Text('No recipe found'));
          }
          
          final meal = snapshot.data!;
          
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Meal Image
                Image.network(
                  meal.thumbnail,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Meal Name
                      Text(
                        meal.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Category and Area
                      Row(
                        children: [
                          _buildInfoChip(Icons.category, meal.category),
                          const SizedBox(width: 8),
                          _buildInfoChip(Icons.location_on, meal.area),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Ingredients
                      const Text(
                        'Ingredients',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      ...List.generate(meal.ingredients.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${meal.ingredients[index]}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Text(
                                meal.measures[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      
                      const SizedBox(height: 24),
                      
                      // Instructions
                      const Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Text(
                        meal.instructions,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(text),
      backgroundColor: Colors.blue[50],
    );
  }
}