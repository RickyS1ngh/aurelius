import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  DateSelector(this.selectedDate, this.setDate, {super.key});
  DateTime selectedDate;
  final void Function(DateTime date) setDate;

  @override
  State<DateSelector> createState() => _DateSelectorWidgetState();
}

class _DateSelectorWidgetState extends State<DateSelector> {
  List<DateTime> getWeekDates(int weekOffset) {
    final today = DateTime.now();
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    startOfWeek = startOfWeek.add(Duration(days: 7 * weekOffset));

    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  int weekOffset = 0;

  @override
  Widget build(BuildContext context) {
    final weekdays = getWeekDates(weekOffset);
    String month = DateFormat('MMMM').format(weekdays.first);
    String year = DateFormat('yyyy').format(weekdays.first);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ).copyWith(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      weekOffset -= 1;
                    });
                  },
                  icon: const Icon(Icons.arrow_back_outlined)),
              Text(
                month + ' ' + year,
                style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Cinzel',
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      weekOffset += 1;
                    });
                  },
                  icon: const Icon(Icons.arrow_forward_outlined))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 80,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: weekdays.length,
                itemBuilder: (context, index) {
                  final date = weekdays[index];
                  bool isSelected =
                      DateFormat('d').format(widget.selectedDate) ==
                              DateFormat('d').format(date) &&
                          widget.selectedDate.month == date.month &&
                          widget.selectedDate.year == date.year;
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.selectedDate = weekdays[index];
                          widget.setDate(weekdays[index]);
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: isSelected ? Color(0xFFa68a64) : null,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey, width: 2)),
                          margin: const EdgeInsets.only(right: 8),
                          width: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('d').format(date),
                                style: const TextStyle(
                                    fontFamily: 'Cinzel',
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                DateFormat('E').format(date),
                                style: const TextStyle(
                                    fontFamily: 'Cinzel',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )));
                }),
          ),
        )
      ],
    );
  }
}
