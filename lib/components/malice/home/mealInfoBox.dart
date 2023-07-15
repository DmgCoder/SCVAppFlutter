import 'package:flutter/material.dart';
import 'package:scv_app/components/malice/mealsBoxDecoration.dart';

Widget MealInfoBox(BuildContext context, String info, String value,
    {TextAlign textAlignForValue = TextAlign.right,
    void Function()? onTap,
    Icon? icon}) {
  return GestureDetector(
    child: Container(
      decoration: mealsBoxDecoration(context),
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(info),
          Spacer(),
          icon != null
              ? icon
              : Expanded(
                  child: Text(
                  value,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: textAlignForValue,
                )),
        ],
      ),
    ),
    onTap: onTap,
  );
}
