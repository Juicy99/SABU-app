import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'task_data.dart';
import 'task_tile.dart';

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final task = taskData.tasks[index];
            final message = taskData.messages[index];
            final price = taskData.tasks[index];
            return TaskTile(
              taskTitle: task.name,
              taskMessage: task.message,
              taskPrice: task.price.toString(),
              longPressCallback: () {
                taskData.deleteTask(task, message, price);
              },
            );
          },
          itemCount: taskData.taskCount,
        );
      },
    );
  }
}
