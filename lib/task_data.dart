import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'task.dart';

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [
    Task(name: 'Buy milk', message: 'Buy milk', price: '10' as double),
    Task(name: 'Buy eggs', message: 'Buy eggs', price: '100' as double),
    Task(name: 'Buy bread', message: 'Buy bread', price: '1000' as double),
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
      String newTaskTitle, String newTaskMessage, double newTaskPrice) {
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

  double totalCartValue = 0;

  void calculateTotal() {
    totalCartValue = 0;
    _tasks.forEach((f) {
      totalCartValue = totalCartValue + f.price;
    });
  }
}
