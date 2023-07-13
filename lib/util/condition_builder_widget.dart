import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:udemy_course/util/task_item.dart';

class conditionBuilderWidget extends StatelessWidget {
  const conditionBuilderWidget({
    Key? key,
    required this.tasks,
  }) : super(key: key);

  final List<Map> tasks;

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey.shade300,
              ),
          itemCount: tasks.length),
      condition: tasks.isNotEmpty,
      fallback: (context) => Center(
        child:const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.menu, size: 100, color: Colors.grey),
            Text(
              'No tasks yet! Add some tasks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
