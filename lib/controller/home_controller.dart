import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';

class HomeController extends GetxController{
  void insertNewItem() async {
    DatabaseHelper dbHelper = DatabaseHelper();

    // Initialize the database
    await dbHelper.initDB();

    // Example usage of database operations
    List<Map<String, dynamic>> items = await dbHelper.getItems();


    Map<String, dynamic> newItem = {
      DatabaseHelper.itemId: 'item123',
      DatabaseHelper.itemName: 'Example Item',
      DatabaseHelper.itemBarcode: '123456789',
      DatabaseHelper.itemPrice: 9.99,
      DatabaseHelper.itemQuantity: 10,
    };

    try {
      int insertedItemId = await dbHelper.insertItem(newItem);
      print('Item inserted. Item ID: $insertedItemId');
    } catch (e) {
      if (e is DatabaseException) {
        if (e.isUniqueConstraintError()) {
          print('Item insertion failed: Duplicate barcode $e');
        } else {
          print('Item insertion failed: ${e.result}');
        }
      } else {
        print('Item insertion failed: $e');
      }
    }

    // int lastDocumentNumber = await dbHelper.getLastDocumentNumber();
    // DateTime currentDateTime = await dbHelper.getCurrentDateTime();
    //
    // Map<String, dynamic> newStockRecord = {
    //   DatabaseHelper.recordDocNo: lastDocumentNumber,
    //   DatabaseHelper.recordTime: currentDateTime.toString(),
    //   DatabaseHelper.recordItemId: 'item123',
    //   DatabaseHelper.recordItemQuantity: 5,
    // };
    // print('newStockRecord: $newStockRecord');
    // int insertedStockRecordId =
    // await dbHelper.insertStockRecord(newStockRecord);
    // print('Stock record inserted. Record ID: $insertedStockRecordId');
    // var ktkt = await dbHelper.getLastDocumentNumber();
    // print('ktkt${ktkt}');
    update();
  }
}