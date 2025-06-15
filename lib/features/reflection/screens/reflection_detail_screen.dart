import 'package:aurelius/core/utils.dart';
import 'package:aurelius/features/auth/controller/auth_controller.dart';
import 'package:aurelius/features/reflection/controller/reflection_controller.dart';
import 'package:aurelius/models/reflection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReflectionDetailScreen extends ConsumerStatefulWidget {
  const ReflectionDetailScreen(this.reflection, {super.key});

  final ReflectionModel reflection;

  @override
  ConsumerState<ReflectionDetailScreen> createState() =>
      _ReflectionDetailScreenState();
}

class _ReflectionDetailScreenState
    extends ConsumerState<ReflectionDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  String reflectionTitle = '';
  String reflectionText = '';
  bool isUpdating = false;
  bool isDeleting = false;

  void _update() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String uid = ref.read(currentUserProvider)!.uid;
      ReflectionModel updatedReflection = ReflectionModel(
          title: reflectionTitle,
          text: reflectionText,
          uuid: widget.reflection.uuid);
      setState(() {
        isUpdating = true;
      });
      bool status = await ref
          .read(ReflectionControllerProvier.notifier)
          .updateReflection(
              context, widget.reflection.uuid, uid, updatedReflection);

      setState(() {
        isUpdating = false;
      });

      if (status) {
        Navigator.of(context).pop();
        showSnackbar(context, 'Reflection was updated sucessfully');
      } else {
        Navigator.of(context).pop();
        showSnackbar(context, 'Unable to update Reflection');
      }
    }
  }

  void _delete() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String uid = ref.read(currentUserProvider)!.uid;

      setState(() {
        isDeleting = true;
      });
      bool status = await ref
          .read(ReflectionControllerProvier.notifier)
          .deleteReflection(context, widget.reflection.uuid, uid);

      setState(() {
        isUpdating = false;
      });

      if (status) {
        Navigator.of(context).pop();
        showSnackbar(context, 'Reflection was deleted sucessfully');
      } else {
        Navigator.of(context).pop();
        showSnackbar(context, 'Unable to deleted Reflection');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Update Reflection',
          style: TextStyle(fontFamily: 'Cinzel', fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    initialValue: widget.reflection.title,
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
                      prefixIcon: Icon(Icons.title),
                      hintText: 'Title',
                    ),
                    maxLength: 20,
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      if (val == null ||
                          val.trim().isEmpty ||
                          val.length < 5 ||
                          val.length > 20) {
                        return 'Invalid title ';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      reflectionTitle = val!;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    initialValue: widget.reflection.text,
                    onTapOutside: (PointerDownEvent event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    maxLines: 10,
                    maxLength: 200,
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
                      hintText: 'Reflection',
                    ),
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      if (val == null ||
                          val.trim().isEmpty ||
                          val.length > 200) {
                        return 'Invalid reflection';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      reflectionText = val!;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
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
                    child: isUpdating
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
                    child: isDeleting
                        ? const CircularProgressIndicator()
                        : const Text(
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
    );
  }
}
