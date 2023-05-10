import 'package:flutter/material.dart';

class Workout {
  final int id;
  final String title;
  final String descriptions;

  Workout({ required this.id, required this.descriptions, required this.title });
}

class WorkoutList with ChangeNotifier {
  List<Workout> _items = [];

  void storeWorkout(Workout workout) {
    _items.add(workout);
    notifyListeners();
  }

  List<Workout> get workoutList {
    return _items;
  }
}