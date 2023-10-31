import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';

class CheckInventoryController extends GetxController{
  TextEditingController barcodeController = TextEditingController();
  Map itemData = {};
  final snackBar = SnackBar(
    content: Text('Sorry! there is no item with this barcode.'),
    backgroundColor: Colors.red,
  );

  //we can search for any item to get its details
  void getItemByBarcode(context) async {
    DatabaseHelper dbHelper = DatabaseHelper();

    Database? db = await dbHelper.database;

    List<Map<String, dynamic>> result = await db!.query(
      'items',
      columns: ['item_name', 'item_price', 'item_quantity'],
      where: 'item_barcode = ?',
      whereArgs: [barcodeController.text],
      limit: 1,
    );

    if (result.isNotEmpty) {
      itemData = result.first;
      print('result.first${result.first['item_name']}');
    } else {
      itemData={};
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      print('null');
    }
    update();
  }
}