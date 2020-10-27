import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'task.dart';

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [
    Task(name: 'Buy milk', message: 'Buy milk', price: 'Buy milk'),
    Task(name: 'Buy eggs', message: 'Buy eggs', price: 'Buy eggs'),
    Task(name: 'Buy bread', message: 'Buy bread', price: 'Buy bread'),
  ];

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

  void addTask(
      String newTaskTitle, String newTaskMessage, String newTaskPrice) {
    _tasks.add(
      Task(name: newTaskTitle, message: newTaskMessage, price: newTaskPrice),
    );
    notifyListeners();
  }

  void deleteTask(Task task, message, price) {
    _tasks.remove(task);
    notifyListeners();
  }

  int shoppingCartCount = 1;

  void incrementCounter() {
    shoppingCartCount++;
    notifyListeners();
  }

  void decrementCounter() {
    shoppingCartCount--;
    notifyListeners();
  }
}
