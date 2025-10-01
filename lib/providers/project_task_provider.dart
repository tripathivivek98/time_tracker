import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/project.dart';
import '../models/task.dart';

class ProjectTaskProvider with ChangeNotifier {
  List<Project> _projects = [];
  List<Task> _tasks = [];

  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _projects = (jsonDecode(prefs.getString('projects') ?? '[]') as List)
        .map((e) => Project.fromJson(e))
        .toList();
    _tasks = (jsonDecode(prefs.getString('tasks') ?? '[]') as List)
        .map((e) => Task.fromJson(e))
        .toList();
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('projects', jsonEncode(_projects.map((e) => e.toJson()).toList()));
    prefs.setString('tasks', jsonEncode(_tasks.map((e) => e.toJson()).toList()));
  }

  void addProject(Project project) {
    _projects.add(project);
    _saveData();
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    _saveData();
    notifyListeners();
  }

  void removeProject(String id) {
    _projects.removeWhere((p) => p.id == id);
    _saveData();
    notifyListeners();
  }

  void removeTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _saveData();
    notifyListeners();
  }
}
