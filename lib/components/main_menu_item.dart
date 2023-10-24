import 'package:flutter/material.dart';

class MainMenuItem extends StatelessWidget {
  Color color;
  String title;
   MainMenuItem({super.key,required this.title,required this.color});

  @override
  Widget build(BuildContext context) {
    return   Row(
      children: [
        Container(
          width: 100,
          height: 100,
          color: color,
        ),
        const SizedBox(
          width: 10,
        ),
         Text(
          title,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
