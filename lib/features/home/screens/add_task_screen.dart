import 'dart:io';
import 'package:aurelius/features/home/widgets/custom_radio_button.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime? selectedDate;
  TimeOfDay? time;
  String dateToText = '';
  String timeToText = '';
  int selectedIndex = 0;

  void setIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text(
            'Add New Task',
            style: TextStyle(fontFamily: 'Cinzel', fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: ListView(children: [
            Form(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 800,
                  child: Column(
                    children: [
                      TextFormField(
                        onTapOutside: (PointerDownEvent event) {
                          FocusManager.instance.primaryFocus?.unfocus();
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
                        onTapOutside: (PointerDownEvent event) {
                          FocusManager.instance.primaryFocus?.unfocus();
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
                            currentDateTime: DateTime.now(),
                          ),
                        ),
                        const CupertinoTimePickerButton(),
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
                                    initialTime: TimeOfDay.now());
                                if (time != null) {
                                  setState(() {
                                    time = TimeOfDay(
                                        hour: time!.hour, minute: time!.minute);
                                    timeToText =
                                        time.toString().substring(10, 15);
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
                          CustomRadioButton(
                              'Wisdom', selectedIndex, 1, setIndex),
                          CustomRadioButton(
                              'Discpline', selectedIndex, 2, setIndex),
                          CustomRadioButton(
                              'Courage', selectedIndex, 3, setIndex),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: 400,
                        child: ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                            Color(0xFFa68a64),
                          )),
                          onPressed: () {},
                          child: const Text(
                            'Submit',
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
          ]),
        ));
  }
}
