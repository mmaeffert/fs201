import 'package:flutter/material.dart';

class CheckBoxKit{

 static Widget checkbox1(bool isChecked, String text, ValueChanged onChanged){
  return Container(
     margin: const EdgeInsets.only(top: 20),
     child: Row(
       children: [
         Container(
           margin: const EdgeInsets.only(right: 5),
           alignment: Alignment.centerRight,
           child: Text(
               text,
             style: const TextStyle(fontSize: 16),
           ),
         ),
         Container(
           alignment: Alignment.centerRight,
           margin: const EdgeInsets.only(right: 20),
           child: Checkbox(
             value: isChecked,
             onChanged: onChanged,
           ),
         ),
       ],
     ),
   );

 }

}