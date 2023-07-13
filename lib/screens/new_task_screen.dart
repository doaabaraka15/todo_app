import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_course/cubit/cubit.dart';
import 'package:udemy_course/cubit/states.dart';
import '../util/condition_builder_widget.dart';
import '../util/task_item.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      builder: (context , state){
        var tasks = AppCubit.get(context).newTasks;
        return  conditionBuilderWidget(tasks: tasks);
      },
      listener: (context ,state){},
    );
  }
}

