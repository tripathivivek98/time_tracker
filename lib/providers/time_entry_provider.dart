import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  List<TimeEntry> _entries = [];
  List<TimeEntry> get entries => _entries;

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _entries = (jsonDecode(prefs.getString('entries') ?? '[]') as List)
        .map((e) => TimeEntry.fromJson(e))
        .toList();
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('entries', jsonEncode(_entries.map((e) => e.toJson()).toList()));
  }

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    _saveData();
    notifyListeners();
  }

  void removeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _saveData();
    notifyListeners();
  }
}
