import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../providers/time_entry_provider.dart';
import '../providers/project_task_provider.dart';
import 'add_time_entry_screen.dart';
import 'project_task_management_screen.dart';
import '../widgets/entry_tile.dart';

enum EntryViewMode { all, grouped }

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  EntryViewMode _viewMode = EntryViewMode.all;

  @override
  Widget build(BuildContext context) {
    final pages = [
      Consumer2<TimeEntryProvider, ProjectTaskProvider>(
        builder: (context, entryProvider, projectProvider, child) {
          if (_viewMode == EntryViewMode.all) {
            // 🔹 Normal List with swipe-to-delete
            return ListView.builder(
              itemCount: entryProvider.entries.length,
              itemBuilder: (context, index) {
                final entry = entryProvider.entries[index];
                return Dismissible(
                  key: ValueKey(entry.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    entryProvider.removeEntry(entry.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Entry deleted")),
                    );
                  },
                  child: EntryTile(entry: entry),
                );
              },
            );
          } else {
            // 🔹 Grouped by Project
            final entries = entryProvider.entries;
            final Map<String, List> groupedEntries = {};

            for (var entry in entries) {
              groupedEntries.putIfAbsent(entry.projectId, () => []).add(entry);
            }

            if (groupedEntries.isEmpty) {
              return const Center(child: Text("No entries yet."));
            }

            return ListView(
              padding: const EdgeInsets.all(8),
              children: groupedEntries.entries.map((group) {
                final project = projectProvider.projects.firstWhere(
                      (p) => p.id == group.key,
                  orElse: () => Project(id: "", name: "Unknown Project"),
                );

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    title: Text(
                      project.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    children: group.value
                        .map<Widget>((entry) => Dismissible(
                      key: ValueKey(entry.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                        child: const Icon(Icons.delete,
                            color: Colors.white),
                      ),
                      onDismissed: (_) {
                        entryProvider.removeEntry(entry.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Entry deleted")),
                        );
                      },
                      child: EntryTile(entry: entry),
                    ))
                        .toList(),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
       ProjectTaskManagementScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Tracker"),
        actions: [
          if (_selectedIndex == 0) // Only show filter in Entries tab
            PopupMenuButton<EntryViewMode>(
              icon: const Icon(Icons.filter_list),
              onSelected: (mode) {
                setState(() {
                  _viewMode = mode;
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: EntryViewMode.all,
                  child: Text("All Entries"),
                ),
                const PopupMenuItem(
                  value: EntryViewMode.grouped,
                  child: Text("Grouped by Project"),
                ),
              ],
            ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Entries"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Manage"),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTimeEntryScreen()),
          );
        },
      )
          : null,
    );
  }
}
