import 'package:aurelius/features/auth/controller/auth_controller.dart';
import 'package:aurelius/features/home/controller/home_controller.dart';
import 'package:aurelius/features/home/screens/add_task_screen.dart';
import 'package:aurelius/features/home/screens/task_detail_screen.dart';
import 'package:aurelius/features/home/widgets/date_selector.dart';
import 'package:aurelius/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  void setDate(date) {
    setState(() {
      selectedDate = date;
    });
  }

  void addToDo() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: MediaQuery.of(ctx).size.height * .70,
              child: const AddTaskScreen(),
            ),
          );
        });
  }

  void viewTask(task) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                  height: MediaQuery.of(ctx).size.height * .70,
                  child: TaskDetailScreen(task)));
        });
  }

  @override
  Widget build(BuildContext context) {
    List<TaskModel> userTasks = ref.watch(currentUserProvider)?.tasks ?? [];
    List<TaskModel> tasks = userTasks
        .where((task) =>
            task.dueDate.year == selectedDate.year &&
            task.dueDate.day == selectedDate.day &&
            task.dueDate.month == selectedDate.month)
        .toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF9F6F1),
        onPressed: () {
          addToDo();
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: Column(children: [
        DateSelector(selectedDate, setDate),
        SizedBox(
          height: MediaQuery.of(context).size.height * .01,
        ),
        (tasks.isNotEmpty)
            ? Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                        height: MediaQuery.of(context).size.height * .001),
                    itemCount: tasks.length,
                    itemBuilder: (ctx, index) {
                      String userUid = ref.read(currentUserProvider)!.uid;
                      bool isCompleted = tasks[index].isCompleted;
                      String icon = switch (tasks[index].category) {
                        Category.courage => 'assets/images/lion.png',
                        Category.discipline => 'assets/images/helmet.png',
                        Category.wisdom => 'assets/images/owl.png'
                      };
                      return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              await ref
                                  .read(homeControllerProvider.notifier)
                                  .completeTask(
                                      context, tasks[index].uuid, userUid);
                            } else {
                              await ref
                                  .read(homeControllerProvider.notifier)
                                  .removeCompleted(
                                      context, tasks[index].uuid, userUid);
                            }
                          },
                          child: GestureDetector(
                            onTap: () {
                              viewTask(tasks[index]);
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20),
                              margin: const EdgeInsets.all(5),
                              height: 60,
                              decoration: BoxDecoration(
                                  color: const Color(0xffe3e0cd),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      tasks[index].title,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Cinzel',
                                          decoration: isCompleted
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                          decorationThickness: 3,
                                          decorationColor: Colors.black,
                                          fontSize: 15),
                                    ),
                                    Image.asset(
                                      icon,
                                      height: 30,
                                    ),
                                  ]),
                            ),
                          ));
                    }),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height * .4,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No Tasks',
                        style: TextStyle(
                            color: Color(0xFFF9F6F1),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cinzel',
                            fontSize: 20)),
                  ],
                ),
              )
      ]),
    );
  }
}
