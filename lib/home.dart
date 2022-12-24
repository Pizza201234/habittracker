import 'package:flutter/material.dart';
import 'package:habittracker/habittitle.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'habit_database.dart';
import 'month_summary.dart';
import 'my_fab.dart';
import 'my_alert_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  HabitDatabase db=HabitDatabase();
  final _myBox=Hive.box("Habit_Database");

  @override
  void initState(){
    if(_myBox.get("CURRENT_HABIT_LIST")==null)
      {
        db.DefaultData();
      }
    else
      {
        db.loadData();
      }

    db.updateData();

    super.initState();
  }

///checkbox
  void checkBoxTapped(bool? value,int index){
    setState(() {
      db.habitlist[index][1]=value;
    });
    db.updateData();
  }
  ///new habit
  final _newHabitNameController=TextEditingController();
  void createNewHabit(){
  showDialog(
      context: context,
      builder: (context){
    return MyAlertBox(
      controller: _newHabitNameController,
      onSave:saveNewHabit,
      onCancel:cancelDialogBox,
    );
  }
  );
  }


  ///save
  void saveNewHabit(){
    setState(() {
      db.habitlist.add([_newHabitNameController.text,false]);
    });
      _newHabitNameController.clear();
      Navigator.of(context).pop();

      db.updateData();
  }

  ///cancel
  void cancelDialogBox(){
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  /// open habit settings to edit
  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
        );
      },
    );
  }


  /// save existing habit with a new name
  void saveExistingHabit(int index) {
    setState(() {
      db.habitlist[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
    db.updateData();
  }

  /// delete habit
  void deleteHabit(int index) {
    setState(() {
      db.habitlist.removeAt(index);
    });
    db.updateData();
  }


  ///main

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        backgroundColor: Colors.grey[400],
        floatingActionButton: MyFloatingActionButton(
          onPressed:createNewHabit ,
        ),
        body:ListView(
          children:[
            MonthlySummary(datasets:db.heatMapDataSet,startDate:_myBox.get("START_DATE")),
            
            ListView.builder(
              shrinkWrap: true,
              physics:const NeverScrollableScrollPhysics(),
              itemCount:db.habitlist.length,
              itemBuilder: (context,index)
              {
                return HabitTitle(
                    habitName: db.habitlist[index][0],
                    habitCompleted: db.habitlist[index][1],
                    onChanged:(value)=>checkBoxTapped(value, index),
                    settingsTapped: (context) => openHabitSettings(index),
                    deleteTapped: (context) => deleteHabit(index),
                );
              },
            )
          ]
        )
    );

  }

}
//   @override
//   Widget build(BuildContext context)
//   {
//     return Scaffold(
//         backgroundColor: Colors.grey[400],
//         floatingActionButton: MyFloatingActionButton(
//           onPressed:createNewHabit ,
//         ),
//         body:ListView.builder(
//           itemCount:db.habitlist.length,
//           itemBuilder: (context,index)
//           {
//             return HabitTitle(
//
//               habitName:db.habitlist[index][0],
//               habitCompleted: db.habitlist[index][1],
//               onChanged: (value)=>checkBoxTapped(value,index),
//               settingsTapped:(context)=>openHabitSettings(index),
//               deleteTapped:(context)=>deleteHabit(index),
//
//             );
//           },
//         )
//     );
//
//   }
//
// }