import 'package:flutter/material.dart';
import 'package:udemy_course/cubit/cubit.dart';

Widget buildTaskItem(Map model,context) => Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id']);
  },
  child:   Padding(
  
        padding: const EdgeInsets.all(20.0),
  
        child: Row(
  
          children: [
  
             CircleAvatar(
  
              radius: 35,
  
              child: Text(
  
                model['time'],
  
                style: const TextStyle(fontSize: 15),
  
              ),
  
            ),
  
            const SizedBox(
  
              width: 20,
  
            ),
  
            Expanded(
  
              child: Column(
  
                mainAxisSize: MainAxisSize.min,
  
                crossAxisAlignment: CrossAxisAlignment.start,
  
                children:  [
  
                  Text(
  
                    model['title'],
  
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  
                  ),
  
                  Text(
  
                    model['date'],
  
                    style: const TextStyle(color: Colors.grey),
  
                  ),
  
                ],
  
              ),
  
            ),
  
            IconButton(onPressed: (){
  
              AppCubit.get(context).updateData(status: 'done', id: model['id']);
  
            }, icon: Icon(Icons.check_box , color: Colors.blue,)),
  
            IconButton(onPressed: (){
  
              AppCubit.get(context).updateData(status: 'archive', id: model['id']);
  
            }, icon: Icon(Icons.archive,color: Colors.black26,)),
  
  
  
          ],
  
        ),
  
      ),
);
