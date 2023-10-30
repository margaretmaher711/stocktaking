import 'package:flutter/material.dart';

class ItemInDocument extends StatelessWidget {
  String itemName;
  int itemQuantity;
   ItemInDocument({super.key,required this.itemName,required this.itemQuantity});

  @override
  Widget build(BuildContext context) {
    return  Card(
      child: SizedBox(height: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(itemName),
              Text('$itemQuantity'),
            ],
          ),
        ),
      ),
    );
  }
}
