import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:udemy_course/cubit/states.dart';

import '../screens/archive_screen.dart';
import '../screens/done_screen.dart';
import '../screens/new_task_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialSate());

  static AppCubit get(context) => BlocProvider.of(context);
  var current_index = 0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  List<Widget> screens = const [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchiveTaskScreen(),
  ];
  List<String> title = ['New Tasks', 'Done Tasks', 'Archive Tasks'];

  void changeIndex(int index) {
    current_index = index;
    emit(AppChangeButtonNavBarSate());
  }
  

  Database? database;

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      database
          .execute('CREATE TABLE tasks ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT,'
              'title TEXT,'
              'date TEXT,'
              'time TEXT,'
              'status TEXT'
              ')')
          .then((value) {
        print('Table created');
      }).catchError((error) {
        print('Error when creating table ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDB(database);
      print('DB opened');
    }).then((value) {
      database = value;
      emit(AppCreateDBState());
    });
  }

  insertIntoDatabase(
      {required String title,
      required String time,
      required String date}) async {
    await database?.transaction((txn) => txn
            .rawInsert(
                'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")')
            .then((value) {
          print('$value inserted successfully');
          emit(AppInsertIntoDBState());
          getDataFromDB(database);
        }).catchError((error) {
          print('Failed to insert row');
        }));
  }

  void getDataFromDB(database) async {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    emit(AppGetDataLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetFromDBState());
    });
  }

  void updateData({required String status, required int id}) async {
    database?.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDataFromDB(database);
      emit(AppUpdateDataState());
    });
  }
  
  void deleteData({required int id}){
    database?.rawDelete('DELETE FROM tasks WHERE id =?',[id]).then((value) {
      getDataFromDB(database);
      emit(AppDeleteDataState());
    });
  }

  bool isPressed = false;
  IconData fpIcon = Icons.edit;

  void changeButtonSheetState({required bool isShow, required IconData icon}) {
    isPressed = isShow;
    fpIcon = icon;
    emit(AppChangeButtonSheetState());
  }
}
