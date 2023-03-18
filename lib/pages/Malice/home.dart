import 'package:flutter/material.dart';
import 'package:scv_app/components/malice/home/mealInfoBox.dart';
import 'package:scv_app/components/malice/home/todayForMeal.dart';
import 'package:scv_app/extension/withSpaceBetween.dart';

class MaliceHomePage extends StatefulWidget {
  @override
  _MaliceHomePageState createState() => _MaliceHomePageState();
}

class _MaliceHomePageState extends State<MaliceHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          TodayForMeal(),
          MealInfoBox("PIN:", "69420"),
          MealInfoBox(
              "Malica za jutri:", "Perutničke z medom, dušen riž, solata",
              textAlignForValue: TextAlign.center),
          MealInfoBox("Stanje na računu:", "69,42€"),
          MealInfoBox("Naroči za naslednje dni:", "",
              icon: Icon(Icons.arrow_forward_ios)),
          MealInfoBox("Ostale informacije:", "",
              icon: Icon(Icons.arrow_forward_ios)),
        ].withSpaceBetween(spacing: 15),
      ),
    );
  }
}
