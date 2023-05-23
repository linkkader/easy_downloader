// Created by linkkader on 21/10/2022
//https://stackoverflow.com/a/62879750/12751927

import 'dart:async';
import 'dart:collection';

///queue manager
class TaskRunner<T> {
  final Queue<T> _input = Queue();
  late final int maxConcurrentTasks;
  late Future Function(T, TaskRunner<T>) _execution;
  int runningTasks = 0;
  Completer? _completer;

  ///init queue manager
  TaskRunner(Future Function(T item, TaskRunner<T> runner) execution,
      {this.maxConcurrentTasks = 1, bool startQueue = true}) {
    _execution = execution;
    if (startQueue == true) {
      _startExecution();
    }
  }

  ///add task in queue
  void add(T value) {
    _input.add(value);
    _startExecution();
  }

  ///add multiple tasks to queue
  void addAll(Iterable<T> iterable) {
    for (var element in iterable) {
      add(element);
    }
  }

  ///start queue
  Future<void> _startExecution() async {
    if (runningTasks == maxConcurrentTasks || _input.isEmpty) {
      if (runningTasks == 0) {
        if (_completer != null && _completer?.isCompleted == false) {
          _completer?.complete();
        }
        // _completer = null;
      }
      return;
    }
    _completer = Completer();
    if (_input.isNotEmpty && runningTasks < maxConcurrentTasks) {
      runningTasks++;
      try {
        await _execution(_input.removeFirst(), this);
      } catch (_) {
        // App.log.e('TaskRunner error : $_');
      }
      runningTasks--;
      _startExecution();
    }
  }

  ///check if queue is running
  bool get isRunning => runningTasks > 0;

  ///get queue length
  int get length => _input.length;

  ///check if queue is empty
  bool get isEmpty => _input.isEmpty;

  ///check if queue is not empty
  bool get isNotEmpty => _input.isNotEmpty;

  ///check if queue is last
  bool get isLast => isEmpty && runningTasks == 1;

  ///wait for queue to finish
  Future<void> whenDone() {
    if (_completer == null && _input.isEmpty) {
      return Future.value();
    }
    assert(_completer != null, 'TaskRunner is not running');
    return _completer!.future;
  }

  ///clear queue
  void clear() {
    _input.clear();
  }
}
