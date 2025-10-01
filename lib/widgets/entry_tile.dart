import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../models/time_entry.dart';
import '../providers/project_task_provider.dart';

class EntryTile extends StatelessWidget {
  final TimeEntry entry;

  const EntryTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final projectTaskProvider = Provider.of<ProjectTaskProvider>(context, listen: false);

    final projectName = projectTaskProvider.projects
        .firstWhere(
          (p) => p.id == entry.projectId,
      orElse: () => Project(id: "", name: "Unknown Project"),
    )
        .name;

    final taskName = projectTaskProvider.tasks
        .firstWhere(
          (t) => t.id == entry.taskId,
      orElse: () => Task(id: "", name: "Unknown Task"),
    )
        .name;

    String formattedDate = "";
    try {
      final dateTime = DateTime.parse(entry.date.toString());
      formattedDate = DateFormat("MMM dd, yyyy hh:mm a").format(dateTime);
    } catch (e) {
      formattedDate = entry.date.toString(); // fallback if parsing fails
    }

    return ListTile(
      leading: const Icon(Icons.timer, color: Colors.blue),
      title: Text("$projectName → $taskName"),
      subtitle: Text(
        "${entry.totalTime} hrs | ${formattedDate}\n${entry.notes ?? ''}",
      ),
      isThreeLine: true,
    );
  }
}
