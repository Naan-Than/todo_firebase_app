import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/userResponse.dart';
import 'package:todo/pages/task_add.dart';
import 'package:todo/pages/task_details_page.dart';
import 'package:todo/utils/utility.dart';
import 'package:todo/view_models/authenticationViewModel.dart';
import 'package:todo/view_models/taskViewModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  // int _selectedViewIndex = 1;
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString(Utility.uid);
      if (uid != null) {
        Provider.of<TaskViewModel>(
          context,
          listen: false,
        ).fetchTasks(uid).then((_) {
          context.read<TaskViewModel>().filterTasks();
        });
        final authViewModel = Provider.of<AuthenticationViewModel>(
          context,
          listen: false,
        );
        await authViewModel.getAllUsersExceptCurrent(uid);
        await authViewModel.getAllUsersIncludingCurrent();
      } else {
        print('UID not found in SharedPreferences');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    AuthenticationViewModel authenticationViewModel =
        context.watch<AuthenticationViewModel>();
    final tasks = context.watch<TaskViewModel>().tasks;
    var filteredTasks = context.watch<TaskViewModel>().filteredTasks;
    int selectedViewIndex = context.read<TaskViewModel>().selectedViewIndex;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'ToDo List',
          style: TextStyle(
            color: Color(0xFF2B3A67),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              authenticationViewModel.logout(context);
            },
            icon: Icon(Icons.exit_to_app, size: 22, color: Colors.grey),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(2, 12, 2, 5),
        color: Color(0xFFF0F8FF),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Utility.customBuildViewOption(
                    index: 1,
                    selectedIndex: selectedViewIndex,
                    onTap: (i) {
                      context.read<TaskViewModel>().setSelectedViewIndex(i);
                      context.read<TaskViewModel>().filterTasks();
                    },
                    icon: Icons.list_alt,
                    label: 'All',
                  ),
                  Utility.customBuildViewOption(
                    index: 2,
                    selectedIndex: selectedViewIndex,
                    onTap: (i) {
                      context.read<TaskViewModel>().setSelectedViewIndex(i);
                      context.read<TaskViewModel>().filterTasks();
                    },
                    icon: Icons.check_circle,
                    label: 'Completed',
                  ),
                  Utility.customBuildViewOption(
                    index: 3,
                    selectedIndex: selectedViewIndex,
                    onTap: (i) {
                      context.read<TaskViewModel>().setSelectedViewIndex(i);
                      context.read<TaskViewModel>().filterTasks();
                    },
                    icon: Icons.pending_actions,
                    label: 'Open',
                  ),
                  Utility.customBuildViewOption(
                    index: 4,
                    selectedIndex: selectedViewIndex,
                    onTap: (i) {
                      context.read<TaskViewModel>().setSelectedViewIndex(i);
                      context.read<TaskViewModel>().filterTasks();
                    },
                    icon: Icons.bar_chart,
                    label: 'Owned',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: Color(0xFF4D79FF),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Records',
                    style: TextStyle(
                      color: Color(0xFF2B3A67),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
            const SizedBox(height: 15),
            authenticationViewModel.isFetchingUsers
                ? Container(
                  height: screenHeight / 2,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Utility.primaryColor,
                    ),
                  ),
                )
                : tasks.isEmpty
                ? Container(
                  height: screenHeight / 2,
                  child: const Center(
                    child: Text(
                      "No Records Found",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {

                      final task = filteredTasks[index];
                      print('Task ID: ${task.id}, Shared With: ${task.sharedWithUserIds}');
                      print('All User IDs: ${authenticationViewModel.allWithUsers.map((user) => user.id).toList()}');
                      return Utility.customBuildTaskCard(
                        title: task.title,
                        description: task.description,
                        isCompleted: task.isCompleted,
                        daysLeft: task.eventDateTime,
                        // assignees: ['s','e'],
                        assignees: task.sharedWithUserIds.isNotEmpty
                            ? task.sharedWithUserIds.map((userId) {
                          final user = authenticationViewModel.allWithUsers
                              .firstWhere(
                                (u) => u.id == userId,
                            orElse: () => UserResponse(id: '', displayName: '', email: '', createdAt: Timestamp.now()),
                          );
                          return user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : '';
                        }).toList()
                            : [],

                        color: Colors.blue[100]!,
                        onPress: () {
                          showTaskDetailDialog(context, task);
                        },
                        // daysLeft: null, // You can customize this color if needed
                      );
                    },
                  ),
                ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Utility.primaryColor,
        onPressed: () {
          showTaskAddBottomSheet(context);
          // Navigator.pushNamed(context, "/task-add");
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
