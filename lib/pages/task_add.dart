import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/taskResponse.dart';
import 'package:todo/models/userResponse.dart';
import 'package:todo/utils/utility.dart';
import 'package:todo/view_models/authenticationViewModel.dart';
import 'package:todo/view_models/taskViewModel.dart';

class TaskAddBottomSheetContent extends StatefulWidget {
  final TaskResponse? task;
  final bool? isEditing;
  const TaskAddBottomSheetContent({super.key, this.task, this.isEditing = false});

  @override
  State<TaskAddBottomSheetContent> createState() =>
      _TaskAddBottomSheetContentState();
}

class _TaskAddBottomSheetContentState extends State<TaskAddBottomSheetContent> {
  DateTime? _selectedDateTime;
  List<UserResponse> _selectedUsers = [];
  final GlobalKey<DropdownSearchState<UserResponse>> _dropdownKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    if (widget.isEditing!=null && widget.task != null) {
      final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
      taskViewModel.titleController.text = widget.task!.title;
      taskViewModel.descriptionController.text = widget.task!.description;
      taskViewModel.setSelectedDateTime(widget.task!.eventDateTime);
      _selectedUsers =
          context
              .read<AuthenticationViewModel>()
              .allUsers
              .where((user) => widget.task!.sharedWithUserIds.contains(user.id))
              .toList();
      final userIds = _selectedUsers.map((e) => e.id).toList();
      taskViewModel.updateSelectedSharedWithUsers(userIds);
    }
  }

  Future<void> _fetchUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUid = prefs.getString(Utility.uid);

    if (currentUid != null) {
      final authViewModel = Provider.of<AuthenticationViewModel>(
        context,
        listen: false,
      );
      await authViewModel.getAllUsersExceptCurrent(currentUid);
    }
  }

  Future<void> _createTask() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(Utility.uid);
    final userName = prefs.getString(Utility.userName);

    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);

    if (uid != null &&
        taskViewModel.titleController.text.trim().isNotEmpty &&
        taskViewModel.descriptionController.text.trim().isNotEmpty &&
        taskViewModel.selectedDateTime != null) {
      if (widget.isEditing !=null && widget.task != null) {
        await taskViewModel.updateTask(taskId: widget.task!.id);
      } else {
        await taskViewModel.createTask(
          ownerId: uid,
          createdBy: userName.toString(),
        );
        taskViewModel.filterTasks();
      }

      await taskViewModel.fetchTasks(uid);

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields and select a date & time"),
        ),
      );
    }
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: taskViewModel.selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDateTime != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          taskViewModel.selectedDateTime ?? DateTime.now(),
        ),
      );

      if (pickedTime != null) {
        final combinedDateTime = DateTime(
          pickedDateTime.year,
          pickedDateTime.month,
          pickedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        taskViewModel.setSelectedDateTime(combinedDateTime);
      } else {
        taskViewModel.setSelectedDateTime(pickedDateTime); // Only date selected
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationViewModel authenticationViewModel =
        context.watch<AuthenticationViewModel>();
    TaskViewModel taskViewModel = context.watch<TaskViewModel>();

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child:
          authenticationViewModel.isFetchingUsers
              ? Container(
                height: 330,
                child: Center(
                  child: CircularProgressIndicator(color: Utility.primaryColor),
                ),
              )
              : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Task',
                    style: TextStyle(
                      color: Color(0xFF2B3A67),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: taskViewModel.titleController,
                    decoration: const InputDecoration(
                      labelText: "Task Title",
                      hintText: "Enter task title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Utility.multiSelectCommonDropDown(
                    context: context,
                    key: _dropdownKey,
                    userList: authenticationViewModel.allUsers,
                    selectedItems: _selectedUsers,
                    hintText: 'Select Users',
                    errorText: 'Please select at least one user',
                    fillColor: Colors.grey[200]!,
                    onChanged: (List<UserResponse> selectedUsers) async {
                      print(
                        '$selectedUsers selected opeiton3......$selectedUsers',
                      );
                      final List<String> userIds =
                          selectedUsers.map((item) => item.id).toList();
                      // final List<String> userIds = selectedUsers.map((item) => item.toString()).toList();
                      taskViewModel.updateSelectedSharedWithUsers(userIds);
                      setState(() {
                        _selectedUsers = selectedUsers;
                        print('Selected Users: $_selectedUsers');
                      });
                    },
                    // onChanged: _onUsersChanged,
                    isEnable: true,
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () => _pickDateTime(context), // Ca
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Event Date & Time",
                          hintText: "Pick date and time",
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                          text:
                              taskViewModel.selectedDateTime == null
                                  ? ''
                                  : "${taskViewModel.selectedDateTime!.year}-${taskViewModel.selectedDateTime!.month.toString().padLeft(2, '0')}-${taskViewModel.selectedDateTime!.day.toString().padLeft(2, '0')} "
                                      "${taskViewModel.selectedDateTime!.hour.toString().padLeft(2, '0')}:${taskViewModel.selectedDateTime!.minute.toString().padLeft(2, '0')}",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: taskViewModel.descriptionController,
                    maxLines: 3,

                    decoration: const InputDecoration(
                      labelText: "Task Description",
                      hintText: "Enter task description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: _createTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Utility.primaryColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child:
                        taskViewModel.isLoading
                            ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                constraints: BoxConstraints(
                                  minHeight: 20,
                                  minWidth: 20,
                                ),
                              ),
                            )
                            : Text(
                          widget.isEditing!=null? "Update" : "Create Task",
                              style: TextStyle(color: Colors.white),
                            ),
                  ),
                ],
              ),
    );
  }
}

void showTaskAddBottomSheet(BuildContext context, {TaskResponse? task,bool? isEdit}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) => TaskAddBottomSheetContent(task: task,isEditing: isEdit),
  );
}
