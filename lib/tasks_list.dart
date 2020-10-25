import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'task_data.dart';
import 'task_tile.dart';

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return taskData.taskCount == null
            ? Container()
            : ListView.builder(
                itemBuilder: (context, index) {
                  final task = taskData.tasks[index];
                  final message = taskData.messages[index];
                  return TaskTile(
                    taskTitle: task.name,
                    taskMessage: message.message,
                    longPressCallback: () {
                      taskData.deleteTask(task, message);
                    },
                  );
                },
                itemCount: taskData.taskCount,
              );
      },
    );
  }
}
