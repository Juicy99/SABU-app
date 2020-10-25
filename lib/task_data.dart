import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'task.dart';

class TaskData extends ChangeNotifier {
  List<Task> _tasks,
      _messages = [
        Task(name: 'Buy milk', message: 'Buy milk'),
        Task(name: 'Buy eggs', message: 'Buy eggs'),
        Task(name: 'Buy bread', message: 'Buy eggs'),
      ];

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  UnmodifiableListView<Task> get messages {
    return UnmodifiableListView(_messages);
  }

  int get taskCount {
    return _tasks.length;
  }

  void addTask(String newTaskTitle) {
    final task = Task(name: newTaskTitle);
    _tasks.add(task);
    notifyListeners();
  }

  void addMessage(String newTaskMessage) {
    final message = Task(message: newTaskMessage);
    _messages.add(message);
    notifyListeners();
  }

  void deleteTask(Task task, message) {
    _tasks.remove(task);
    _messages.add(message);
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
