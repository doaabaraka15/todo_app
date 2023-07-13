
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../util/condition_builder_widget.dart';
import '../util/task_item.dart';
class DoneTaskScreen extends StatelessWidget {
  const DoneTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      builder: (context , state){
        var tasks = AppCubit.get(context).doneTasks;
        return  conditionBuilderWidget(tasks: tasks);
      },
      listener: (context ,state){},
    );
  }
}
