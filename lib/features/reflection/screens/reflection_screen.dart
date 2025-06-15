import 'package:aurelius/features/auth/controller/auth_controller.dart';
import 'package:aurelius/features/home/screens/task_detail_screen.dart';
import 'package:aurelius/features/home/widgets/date_selector.dart';
import 'package:aurelius/features/reflection/screens/add_reflection_screen.dart';
import 'package:aurelius/features/reflection/screens/reflection_detail_screen.dart';
import 'package:aurelius/models/reflection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReflectionScreen extends ConsumerStatefulWidget {
  const ReflectionScreen({super.key});

  @override
  ConsumerState<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends ConsumerState<ReflectionScreen> {
  var selectedDate = DateTime.now();

  void setDate(date) {
    setState(() {
      selectedDate = date;
    });
  }

  void addReflection() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
                height: MediaQuery.of(ctx).size.height * .7,
                child: const AddReflectionScreen()),
          );
        });
  }

  void viewReflection(reflection) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: ReflectionDetailScreen(reflection),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    List<ReflectionModel> reflections =
        ref.watch(currentUserProvider)?.reflections ?? [];

    DateTime dateOnly(DateTime date) =>
        DateTime(date.year, date.month, date.day); //returns date only

    final targetDate = dateOnly(selectedDate);

    List<ReflectionModel> userReflections = reflections
        .where((reflection) =>
            dateOnly(reflection.createdAt.toLocal()) == targetDate)
        .toList();

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addReflection();
          },
          backgroundColor: const Color(0xffe3e0cd),
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
        body: Column(
          children: [
            DateSelector(selectedDate, setDate),
            SizedBox(
              height: MediaQuery.of(context).size.height * .01,
            ),
            (userReflections.isNotEmpty)
                ? Expanded(
                    child: ListView.separated(
                      itemCount: userReflections.length,
                      itemBuilder: (ctx, index) {
                        double height;

                        if (userReflections[index].text.length <= 100) {
                          height = 100;
                        } else if (userReflections[index].text.length <= 150) {
                          height = 125;
                        } else {
                          height = 150;
                        }
                        return GestureDetector(
                          onTap: () {
                            viewReflection(userReflections[index]);
                          },
                          child: Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20),
                              height: height,
                              width: 350,
                              decoration: BoxDecoration(
                                  color: const Color(0xffe3e0cd),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: RichText(
                                      text: TextSpan(
                                        text: userReflections[index].title,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Cinzel',
                                            fontSize: 15,
                                            decoration:
                                                TextDecoration.underline,
                                            height: 2),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    userReflections[index].text,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Cinzel',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10);
                      },
                    ),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height * .4,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No Reflections',
                            style: TextStyle(
                                color: Color(0xFFF9F6F1),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cinzel',
                                fontSize: 20)),
                      ],
                    ),
                  )
          ],
        ));
  }
}
