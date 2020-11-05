import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'task.dart';

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [
    Task(name: 'Buy milk', message: 'Buy milk', price: '10'),
    Task(name: 'Buy eggs', message: 'Buy eggs', price: '100'),
    Task(name: 'Buy bread', message: 'Buy bread', price: '1000'),
  ];

  double totalCartValue = 0;

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  UnmodifiableListView<Task> get messages {
    return UnmodifiableListView(_tasks);
  }

  UnmodifiableListView<Task> get prices {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void deleteTask(Task task, message, price) {
    _tasks.remove(task);
    notifyListeners();
  }

  void incrementCounter(task) {
    tasks[tasks.indexOf(task)].qty += 1;
    notifyListeners();
  }

  void decrementCounter(task) {
    final i = tasks.indexWhere((e) => e.name == task.product);
    if (tasks[i].qty == 1) {
      _tasks.remove(task);
    } else {
      tasks[i].qty -= 1;
      notifyListeners();
    }
  }

  void addTask(
      String newTaskTitle, String newTaskMessage, String newTaskPrice) {
    _tasks.add(
      Task(name: newTaskTitle, message: newTaskMessage, price: newTaskPrice),
    );
    notifyListeners();
  }
}
