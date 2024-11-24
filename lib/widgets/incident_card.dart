import 'package:flutter/material.dart';
import '../models/incident.dart';

class IncidentCard extends StatelessWidget {
  final Incident incident;
  final VoidCallback onDelete;
  final VoidCallback onToggleResolved;

  IncidentCard({
    required this.incident,
    required this.onDelete,
    required this.onToggleResolved,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: incident.isResolved ? Colors.green[100] : Colors.white,
      child: ListTile(
        title: Text(incident.title),
        subtitle: Text("${incident.description}\n${incident.date.toLocal()}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.check, color: Colors.green),
              onPressed: onToggleResolved,
              color: Colors.green,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
