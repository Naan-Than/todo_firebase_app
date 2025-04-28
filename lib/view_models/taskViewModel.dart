import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/taskResponse.dart';
import 'package:todo/utils/utility.dart';

class TaskViewModel extends ChangeNotifier {
  List<TaskResponse> _tasks = [];
  List<TaskResponse> filteredTasks = [];
  List<String> _selectedSharedWithUserIds = [];
  DateTime? _selectedDateTime;
  int _selectedViewIndex  = 1;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isTaskLoad = false;
  bool get isTaskLoad => _isTaskLoad;
  int get selectedViewIndex => _selectedViewIndex;
  // Text Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<TaskResponse> get tasks => _tasks;
  List<String> get selectedSharedWithUserIds => _selectedSharedWithUserIds;
  DateTime? get selectedDateTime => _selectedDateTime;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setTaskLoading(bool value) {
    _isTaskLoad = value;
    notifyListeners();
  }

  void setSelectedDateTime(DateTime? dateTime) {
    _selectedDateTime = dateTime;
    notifyListeners();
  }

  void updateSelectedSharedWithUsers(List<String> userIds) {
    _selectedSharedWithUserIds = userIds;
    notifyListeners();
  }

  void setFilteredTasks(List<TaskResponse> tasks) {
    filteredTasks = tasks;
    notifyListeners();
  }
  void setSelectedViewIndex(int index) {
    _selectedViewIndex = index;
    notifyListeners();
  }

  // Future<void> fetchTasks(String ownerId) async {
  //   try {
  //     setTaskLoading(true);
  //     final taskCollection = FirebaseFirestore.instance.collection('tasks');
  //     final querySnapshot =
  //         await taskCollection.where('ownerId', isEqualTo: ownerId).get();
  //     print('Fetched querySnapshoteee: ${querySnapshot.docs.first.id}');
  //     // print('Fetched querySnapshot: ${querySnapshot.docs.map((doc) => doc.data()).toList()}');
  //     _tasks =
  //         querySnapshot.docs
  //             .map((doc) => TaskResponse.fromFirestore(doc))
  //             .toList();
  //     print('Fetched querySnapshot: ${_tasks}');
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error fetching tasks: $e");
  //   } finally {
  //     setTaskLoading(false);
  //   }
  // }

  Future<void> fetchTasks(String ownerId) async {
    try {
      setTaskLoading(true);
      final taskCollection = FirebaseFirestore.instance.collection('tasks');

      // Fetch tasks created by the current user
      final createdByUserQuery =
      await taskCollection.where('ownerId', isEqualTo: ownerId).get();
      final createdByUserTasks = createdByUserQuery.docs
          .map((doc) => TaskResponse.fromFirestore(doc))
          .toList();

      final sharedWithUserQuery = await taskCollection
          .where('sharedWithUserIds', arrayContains: ownerId)
          .get();
      final sharedWithUserTasks = sharedWithUserQuery.docs
          .map((doc) => TaskResponse.fromFirestore(doc))
          .toList();

      _tasks = [...createdByUserTasks, ...sharedWithUserTasks].toSet().toList();

      print('Fetched tasks: ${_tasks}');
      print('Fetched tasks _tasks: ${_tasks.length}');
      notifyListeners();
    } catch (e) {
      print("Error fetching tasks: $e");
    } finally {
      setTaskLoading(false);
    }
  }


  Future<void> createTask({
    required String ownerId,
    required String createdBy,
  }) async {
    try {
      setLoading(true);
      final taskCollection = FirebaseFirestore.instance.collection('tasks');
      final docRef = await taskCollection.add({});

      final newTask = TaskResponse(
        id: docRef.id,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        ownerId: ownerId,
        sharedWithUserIds: [..._selectedSharedWithUserIds, ownerId],
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        eventDateTime: _selectedDateTime!,
        createdBy: createdBy,
      );
      print('newTask...............$newTask');
      await taskCollection
        ..doc(docRef.id).set(newTask.toMap());
      _tasks.add(newTask.copyWith(id: docRef.id));
      notifyListeners();
      print("Task created successfully");
      clearControllers();
      _selectedSharedWithUserIds.clear();
      _selectedDateTime = null;
    } catch (e) {
      print("Error creating task: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateTaskCompletion(String taskId, bool isCompleted) async {
    try {
      final taskCollection = FirebaseFirestore.instance.collection('tasks');
      final taskDoc = taskCollection.doc(taskId);

      await taskDoc.update({
        'isCompleted': isCompleted,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        _tasks[taskIndex] = _tasks[taskIndex].copyWith(
          isCompleted: isCompleted,
        );
        notifyListeners();
      }

      print(" Task updated successfully");
    } catch (e) {
      print(" Error updating task: $e");
    }
  }

  // Update task (title, description, shared users)
  Future<void> updateTask({required String taskId}) async {
    try {
      setLoading(true);
      final taskCollection = FirebaseFirestore.instance.collection('tasks');
      final taskDoc = taskCollection.doc(taskId);

      final updatedTaskData = {
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'sharedWithUserIds': _selectedSharedWithUserIds,
        'eventDateTime': _selectedDateTime,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await taskDoc.update(updatedTaskData);

      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        _tasks[taskIndex] = _tasks[taskIndex].copyWith(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          sharedWithUserIds: List<String>.from(_selectedSharedWithUserIds),
          eventDateTime: _selectedDateTime,
        );
        notifyListeners();
      }

      print("Task updated successfully");
      clearControllers();
      _selectedSharedWithUserIds.clear();
      _selectedDateTime = null;
    } catch (e) {
      print("Error updating task: $e");
    } finally {
      setLoading(false);
    }
  }

  TaskResponse getTaskById(String taskId) {
    final task = _tasks.firstWhere(
      (task) => task.id == taskId,
      orElse: () => throw Exception('Task not found'),
    );
    return task;
  }

  // Clear controllers
  void clearControllers() {
    titleController.clear();
    descriptionController.clear();
  }

  void filterTasks() async{

    switch (_selectedViewIndex) {
      case 1: // All
        setFilteredTasks(_tasks);
        break;
      case 2: // Completed
        setFilteredTasks(
          _tasks.where((task) => task.isCompleted).toList(),
        );
        break;
      case 3: // Open
        setFilteredTasks(
          _tasks.where((task) => !task.isCompleted).toList(),
        );
        break;
      case 4:
        final prefs = await SharedPreferences.getInstance();
        final uid = prefs.getString(Utility.uid);
        setFilteredTasks(
          _tasks.where((task) {
            return task.ownerId == uid;
          }).toList(),
        );
      // case 4: // Today
      //   final today = DateTime.now();
      //   setFilteredTasks(
      //     _tasks.where((task) {
      //       final taskDate = task.eventDateTime;
      //       return taskDate.year == today.year &&
      //           taskDate.month == today.month &&
      //           taskDate.day == today.day;
      //     }).toList(),
      //   );
        break;
      default:
        setFilteredTasks(_tasks);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
