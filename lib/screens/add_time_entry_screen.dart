import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';
import '../providers/project_task_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? projectId;
  String? taskId;
  double totalTime = 0.0;
  DateTime date = DateTime.now();
  String notes = '';

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectTaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Time Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: projectId,
                onChanged: (v) => setState(() => projectId = v),
                items: projectProvider.projects
                    .map((p) => DropdownMenuItem(value: p.id, child: Text(p.name)))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Project'),
                validator: (v) => v == null ? "Select a project" : null,
              ),
              DropdownButtonFormField<String>(
                value: taskId,
                onChanged: (v) => setState(() => taskId = v),
                items: projectProvider.tasks
                    .map((t) => DropdownMenuItem(value: t.id, child: Text(t.name)))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Task'),
                validator: (v) => v == null ? "Select a task" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Total Time (hours)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter total time';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
                onSaved: (v) => totalTime = double.parse(v!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Notes'),
                onSaved: (v) => notes = v ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Provider.of<TimeEntryProvider>(context, listen: false).addTimeEntry(
                      TimeEntry(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        projectId: projectId!,
                        taskId: taskId!,
                        totalTime: totalTime,
                        date: date,
                        notes: notes,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
