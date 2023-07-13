import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:udemy_course/cubit/cubit.dart';
import 'package:udemy_course/cubit/states.dart';
import 'package:udemy_course/screens/archive_screen.dart';
import 'package:udemy_course/screens/done_screen.dart';
import 'package:udemy_course/screens/new_task_screen.dart';
import 'package:intl/intl.dart';


class HomeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController controller = TextEditingController();
  TextEditingController timeController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();

  HomeScreen({super.key});

  Future<String> getName() async {
    return 'Ahmed Ali';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.title[cubit.current_index]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isPressed) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertIntoDatabase(
                        title: controller.text,
                        time: timeController.text,
                        date: dateController.text);
                  }

                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.title),
                                    border: OutlineInputBorder(),
                                    label: Text('Task title'),
                                  ),
                                  controller: controller,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Title must not be empty';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.watch_later_outlined),
                                    border: OutlineInputBorder(),
                                    label: Text('Time '),
                                  ),
                                  controller: timeController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Title must not be empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) => {
                                              timeController.text = value!
                                                  .format(context)
                                                  .toString()
                                            });
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                    keyboardType: TextInputType.datetime,
                                    decoration: const InputDecoration(
                                      prefixIcon:
                                          Icon(Icons.date_range_outlined),
                                      border: OutlineInputBorder(),
                                      label: Text('Date '),
                                    ),
                                    controller: dateController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Date must not be empty';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2024-10-30'))
                                          .then(
                                        (value) => {
                                          dateController.text =
                                              DateFormat.yMMMd().format(value!)
                                        },
                                      );
                                    })
                              ],
                            ),
                          ),
                        ),
                        elevation: 20,
                      )
                      .closed
                      .then((value) {
                    cubit.changeButtonSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeButtonSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fpIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              elevation: 50,
              showSelectedLabels: true,
              currentIndex: AppCubit.get(context).current_index,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.task_outlined), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.done_outline), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archive')
              ],
            ),
            body: ConditionalBuilder(
              builder: (context) => cubit.screens[cubit.current_index],
              condition: state is! AppGetDataLoadingState,
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
          );
        },
        listener: (context, state) {
          if (state is AppInsertIntoDBState) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
