
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../util/condition_builder_widget.dart';
import '../util/task_item.dart';
class ArchiveTaskScreen extends StatelessWidget {
  const ArchiveTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      builder: (context , state){
        var tasks = AppCubit.get(context).archivedTasks;
        return  conditionBuilderWidget(tasks:tasks);
      },
      listener: (context ,state){},
    );

  }
}
