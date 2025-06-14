import 'dart:io';

import 'package:aurelius/core/utils.dart';
import 'package:aurelius/features/auth/controller/auth_controller.dart';
import 'package:aurelius/features/home/controller/home_controller.dart';
import 'package:aurelius/features/home/screens/add_task_screen.dart';
import 'package:aurelius/features/home/widgets/custom_radio_button.dart';
import 'package:aurelius/models/task.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen(this.task, {super.key});
  final TaskModel task;

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  DateTime? selectedDate;
  TimeOfDay? time;
  String dateToText = '';
  String timeToText = '';
  int selectedIndex = 0;
  String? title;
  String? description;
  final _formKey = GlobalKey<FormState>();
  bool _isUpdating = false;
  bool _isDeleting = false;
  var category;

  void setIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _update() async {
    if (_formKey.currentState!.validate() &&
        selectedIndex != 0 &&
        time != null &&
        selectedDate != null) {
      _formKey.currentState!.save();

      category = switch (selectedIndex) {
        1 => Category.wisdom,
        2 => Category.discipline,
        3 => Category.courage,
        _ => null
      };

      final String uid = ref.read(currentUserProvider)!.uid;

      TaskModel updatedTask = TaskModel(
          uuid: widget.task.uuid,
          title: title!,
          description: description!,
          category: category!,
          dueDate: selectedDate!,
          dueTime: time!);

      try {
        setState(() {
          _isUpdating = true;
        });
        bool status = await ref
            .read(homeControllerProvider.notifier)
            .updateTask(context, widget.task.uuid, uid, updatedTask);

        if (status == true) {
          Navigator.of(context).pop();
          showSnackbar(context, 'Task was updated');
        } else {
          setState(() {
            _isUpdating = false;
          });
          showSnackbar(context, 'Unable to update task');
        }
      } catch (error) {
        showSnackbar(context, error.toString());
      }
    } else {
      showSnackbar(context, 'Please enter all valid values');
    }
  }

  void _delete() async {
    try {
      final String uid = ref.read(currentUserProvider)!.uid;
      setState(() {
        _isDeleting = true;
      });
      bool status = await ref
          .read(homeControllerProvider.notifier)
          .deleteTask(context, widget.task.uuid, uid);

      if (status == true) {
        Navigator.of(context).pop();
        showSnackbar(context, 'Task was deleted');
      } else {
        setState(() {
          _isUpdating = false;
        });
        showSnackbar(context, 'Unable to update task');
      }
    } catch (error) {
      showSnackbar(context, error.toString());
    }
  }

  @override
  void initState() {
    selectedDate = widget.task.dueDate;
    time = widget.task.dueTime;
    category = widget.task.category;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text(
          'Update Task',
          style: TextStyle(fontFamily: 'Cinzel', fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: widget.task.title,
                    onTapOutside: (PointerDownEvent event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    validator: (val) {
                      if (val == null ||
                          val.trim().isEmpty ||
                          val.length < 5 ||
                          val.length > 20) {
                        return 'Invalid task title.';
                      }

                      return null;
                    },
                    onSaved: (val) {
                      title = val;
                    },
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Color(0xFFa68a64),
                      )),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFF9F6F1),
                        ),
                      ),
                      prefixIcon: Icon(Icons.percent),
                      hintText: 'I want to...',
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: widget.task.description,
                    onTapOutside: (PointerDownEvent event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    validator: (val) {
                      if (val == null ||
                          val.trim().isEmpty ||
                          val.length > 30) {
                        return 'Invalid description';
                      }

                      return null;
                    },
                    onSaved: (val) {
                      description = val;
                    },
                    maxLines: 2,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Color(0xFFa68a64),
                      )),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFF9F6F1),
                        ),
                      ),
                      prefixIcon: Icon(Icons.description),
                      hintText: 'Description',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (Platform.isIOS) ...[
                    SizedBox(
                      width: 350,
                      child: CupertinoCalendar(
                          minimumDateTime: DateTime(2025, 1, 1),
                          maximumDateTime: DateTime(2099, 12, 31),
                          currentDateTime: widget.task.dueDate,
                          onDateSelected: (val) {
                            selectedDate = val;
                          }),
                    ),
                    CupertinoTimePickerButton(
                      initialTime: widget.task.dueTime,
                      onTimeChanged: (val) {
                        time = val;
                      },
                    ),
                  ],
                  if (Platform.isAndroid) ...[
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton.icon(
                          style: const ButtonStyle(
                            iconColor: WidgetStatePropertyAll(
                              Color(0xFFF9F6F1),
                            ),
                          ),
                          onPressed: () async {
                            selectedDate = await showDatePicker(
                                initialDate: widget.task.dueDate,
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2099));
                            if (selectedDate != null) {
                              setState(() {
                                dateToText = DateFormat('MMMM d , yyyy')
                                    .format(selectedDate!);
                              });
                            }
                          },
                          icon: const Icon(Icons.calendar_month),
                          label: Text(
                            dateToText == '' ? 'Pick a date' : dateToText,
                            style: const TextStyle(
                              fontFamily: 'Cinzel',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFFF9F6F1),
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton.icon(
                          style: const ButtonStyle(
                              iconColor: WidgetStatePropertyAll(
                            Color(0xFFF9F6F1),
                          )),
                          onPressed: () async {
                            time = await showTimePicker(
                                context: context,
                                initialEntryMode: TimePickerEntryMode.dial,
                                initialTime: widget.task.dueTime);
                            if (time != null) {
                              setState(() {
                                time = TimeOfDay(
                                    hour: time!.hour, minute: time!.minute);
                                timeToText = time.toString().substring(10, 15);
                                ref.read(taskStateProvider).add(true);
                              });
                            }
                          },
                          icon: const Icon(Icons.access_time),
                          label: Text(
                            time == null ? 'Pick a time' : timeToText,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontFamily: 'Cinzel',
                              color: Color(0xFFF9F6F1),
                            ),
                          )),
                    ),
                  ],
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Category',
                    style: TextStyle(
                        color: Color(0xFFF9F6F1),
                        fontFamily: 'Cinzel',
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    children: [
                      CustomRadioButton('Wisdom', selectedIndex, 1, setIndex),
                      CustomRadioButton(
                          'Discipline', selectedIndex, 2, setIndex),
                      CustomRadioButton('Courage', selectedIndex, 3, setIndex),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 400,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Color(0xFFa68a64))),
                      onPressed: () {
                        _update();
                      },
                      child: _isUpdating
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Update',
                              style: TextStyle(
                                color: Color(0xFFF9F6F1),
                                fontFamily: 'Cinzel',
                                fontSize: 20,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 400,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.red[200])),
                      onPressed: () {
                        _delete();
                      },
                      child: _isDeleting
                          ? const CircularProgressIndicator()
                          : Text(
                              'Delete',
                              style: TextStyle(
                                color: Color(0xFFF9F6F1),
                                fontFamily: 'Cinzel',
                                fontSize: 20,
                              ),
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
