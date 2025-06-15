import 'package:aurelius/core/utils.dart';
import 'package:aurelius/features/auth/controller/auth_controller.dart';
import 'package:aurelius/features/reflection/controller/reflection_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddReflectionScreen extends ConsumerStatefulWidget {
  const AddReflectionScreen({super.key});

  @override
  ConsumerState<AddReflectionScreen> createState() =>
      _AddReflectionScreenState();
}

class _AddReflectionScreenState extends ConsumerState<AddReflectionScreen> {
  final _formKey = GlobalKey<FormState>();
  String reflectionTitle = '';
  String reflectionText = '';
  bool isAdding = false;

  void submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String uid = ref.read(currentUserProvider)!.uid;
      setState(() {
        isAdding = true;
      });
      bool status = await ref
          .read(ReflectionControllerProvier.notifier)
          .addReflection(context, reflectionTitle, reflectionText, uid);

      setState(() {
        isAdding = false;
      });

      if (status) {
        Navigator.of(context).pop();
        showSnackbar(context, 'Reflection was added sucessfully');
      } else {
        Navigator.of(context).pop();
        showSnackbar(context, 'Unable to add Reflection');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Add New Reflection',
          style: TextStyle(fontFamily: 'Cinzel', fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
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
                    if (val == null || val.trim().isEmpty || val.length > 200) {
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
                    submit();
                  },
                  child: isAdding
                      ? const CircularProgressIndicator()
                      : const Text(
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
    );
  }
}
