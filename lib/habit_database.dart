import 'package:habittracker/time.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _myBox = Hive.box("Habit_Database");

class HabitDatabase{
  List habitlist=[];
  Map<DateTime,int> heatMapDataSet={};

  void DefaultData()
  {
    habitlist=[["讀書",false],["運動",false],];
    _myBox.put("START_DATE",todaysDateFormatted());
  }

  void loadData()
  {
    if (_myBox.get(todaysDateFormatted()) == null) {
      habitlist = _myBox.get("CURRENT_HABIT_LIST");
      for (int i = 0; i < habitlist.length; i++) {
        habitlist[i][1] = false;
      }
    }
    else
      {
        habitlist=_myBox.get(todaysDateFormatted());
      }

  }

  void updateData()
  {
    _myBox.put(todaysDateFormatted(),habitlist);
    _myBox.put("CURRENT_HABIT_LIST",habitlist);
    calculateHabitPercentages();
    loadHeatMap();
  }


  void calculateHabitPercentages() {
    int countCompleted = 0;
    for (int i = 0; i < habitlist.length; i++) {
      if (habitlist[i][1] == true) {
        countCompleted++;
      }
    }

    String percent = habitlist.isEmpty
        ? '0.0'
        : (countCompleted / habitlist.length).toStringAsFixed(1);
    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );


      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month;
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }

}