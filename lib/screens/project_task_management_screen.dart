import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../providers/project_task_provider.dart';

class ProjectTaskManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProjectTaskProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Manage Projects & Tasks"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Projects"),
              Tab(text: "Tasks"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(provider.projects.map((e) => e.name).toList(), context, true),
            _buildList(provider.tasks.map((e) => e.name).toList(), context, false),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<String> items, BuildContext context, bool isProject) {

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) => ListTile(title: Text(items[i])),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: Text("Add ${isProject ? "Project" : "Task"}"),
            onPressed: () {
              _showDialog(context, isProject);
            },
          ),
        )
      ],
    );
  }

  void _showDialog(BuildContext context, bool isProject) {
    final controller = TextEditingController();
    var uuid = Uuid();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("New ${isProject ? "Project" : "Task"}"),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: "Name")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                if (isProject) {
                  Provider.of<ProjectTaskProvider>(context, listen: false).addProject(
                    Project(id: uuid.v4(), name: controller.text),
                  );
                } else {
                  Provider.of<ProjectTaskProvider>(context, listen: false).addTask(
                    Task(id: uuid.v4(), name: controller.text),
                  );
                }
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }
}
