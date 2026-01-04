import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';

class MealService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';
  
  Future<List<Meal>> searchMeals(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/search.php?s=$query'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          List<Meal> meals = [];
          for (var mealData in data['meals']) {
            meals.add(Meal.fromJson(mealData));
          }
          return meals;
        }
      }
      return [];
    } catch (e) {
      print('Error fetching meals: $e');
      return [];
    }
  }
  
  Future<Meal> getMealById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          return Meal.fromJson(data['meals'][0]);
        }
      }
      throw Exception('Failed to load meal');
    } catch (e) {
      print('Error fetching meal details: $e');
      rethrow;
    }
  }
}