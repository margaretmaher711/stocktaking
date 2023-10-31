import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../database/database_helper.dart';
import '../model/item_of_document_model.dart';

class NewDocumentController extends GetxController {
  final dbHelper = DatabaseHelper();
  final documentItems = <Item>[];
  int lastDocumentNumber = 1;
  final barcodeController = TextEditingController();
  final quantityController = TextEditingController(text: "1");

  //get all item's details searching with barcode
  Future<void> getItemByBarcode(BuildContext context) async {
    final barcode = barcodeController.text;
    final db = await dbHelper.database;

    final result = await db!.query(
      'items',
      columns: ['item_name', 'item_price', 'item_quantity', 'item_barcode'],
      where: 'item_barcode = ?',
      whereArgs: [barcode],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final itemData = result.first;
      addItem(
        itemData['item_barcode'].toString(),
        int.parse(quantityController.text),
        itemData['item_name'].toString(),
      );

      barcodeController.text = '';
      quantityController.text = '1';
    } else {
      showSnackBar(
          context, 'Sorry! There is no item with this barcode.', Colors.red);
    }
  }

//add the item you searched for with barcode to a list
  void addItem(
    String barcode,
    int quantity,
    String name,
  ) {
    bool foundMatch = false;
    //to check if there is any duplicate
    for (var item in documentItems) {
      if (item.barcode == barcode) {
        item.quantity += quantity;
        foundMatch = true;
        break;
      }
    }

    if (!foundMatch) {
      documentItems.add(Item(barcode, quantity, name));
    }
    update();
  }

  //insert new document to database
  Future<int> insertToRecordsTable() async {
    lastDocumentNumber = await dbHelper.getLastDocumentNumber();
    final currentDateTime = await dbHelper.getCurrentDateTime();

    final newStockRecord = {
      DatabaseHelper.recordDocNo: lastDocumentNumber,
      DatabaseHelper.recordTime: currentDateTime.toString(),
      DatabaseHelper.recordItemId: 'item123',
      DatabaseHelper.recordItemQuantity: documentItems.length,
    };

    final insertedStockRecordId =
        await dbHelper.insertStockRecord(newStockRecord);
    lastDocumentNumber = insertedStockRecordId;

    update();
    return lastDocumentNumber;
  }

  //to inform the document's number.
  getLastDocumentNo() async {
    lastDocumentNumber = await dbHelper.getLastDocumentNumber();
    update();
  }

  //to change the quantity of an item in database within any saved documents
  Future<int> updateItemQuantity() async {
    final db = await dbHelper.database;
    int rowsAffected = 0;

    for (final element in documentItems) {
      rowsAffected = await db!.update(
        'items',
        {'item_quantity': element.quantity},
        where: 'item_barcode = ?',
        whereArgs: [element.barcode],
      );
    }
    update();
    return rowsAffected;
  }

//snackbar appears error or successful messages
  void showSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
