import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/taskResponse.dart';
import 'package:todo/models/userResponse.dart';
import 'package:todo/pages/task_add.dart';
import 'package:todo/view_models/authenticationViewModel.dart';
import 'package:todo/view_models/taskViewModel.dart';

class TaskDetailDialog extends StatefulWidget {
  final TaskResponse task;

  const TaskDetailDialog({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskDetailDialog> createState() => _TaskDetailDialogState();
}

class _TaskDetailDialogState extends State<TaskDetailDialog> {
  late bool isCompleted;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.task.isCompleted;
  }

  void toggleCompletionStatus() {
    Provider.of<TaskViewModel>(
      context,
      listen: false,
    ).updateTaskCompletion(widget.task.id, !isCompleted);
    setState(() {
      isCompleted = !isCompleted;
    });
    // Here you can also update Firestore if needed
  }

  void onEditPressed() {
    Navigator.of(context).pop();
    showTaskAddBottomSheet(context, task: widget.task,isEdit: true);

  }
  List<String> getSharedUserNames(List<String> userIds) {
    final allUsers = context.watch<AuthenticationViewModel>().allWithUsers;

    return userIds.map((id) {
      final user = allUsers.firstWhere(
        (user) => user.id == id,
        orElse:
            () => UserResponse(
              id: '',
              displayName: 'Unknown',
              email: '',
              createdAt: Timestamp.now(),
            ),
      );
      return user.displayName;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Task Details'),
          Container(
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green.shade100 : Colors.blue.shade100,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Text(
                isCompleted ? "Completed" : "Open",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color:
                      isCompleted
                          ? Colors.green.shade700
                          : Colors.blue.shade700,
                ),
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Title', task.title),
            _buildDetailRow('Created By', task.createdBy),
            _buildDetailRow(
              'Event Date & Time',
              _formatDate(task.eventDateTime),
            ),
            _buildDetailRow('Description', task.description),
            _buildDetailRow(
              'Shared With',
              getSharedUserNames(task.sharedWithUserIds).join(', '),
            ),
          ],
        ),
      ),
      actions: [
        if (!isCompleted)
          TextButton(onPressed: onEditPressed, child: const Text('Edit')),
        TextButton(
          onPressed: toggleCompletionStatus,
          child: Text(
            isCompleted ? 'Mark as Incomplete' : 'Mark as Complete',
            style: TextStyle(fontSize: isCompleted ? 13 : 14),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black,fontSize: 12),
          children: [
            TextSpan(
              text: '$title: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);
  }
}

void showTaskDetailDialog(BuildContext context, TaskResponse task) {
  showDialog(
    context: context,
    builder: (context) => TaskDetailDialog(task: task),
  );
}
