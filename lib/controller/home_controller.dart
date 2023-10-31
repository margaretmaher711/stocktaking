import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';

class HomeController extends GetxController {
  void insertNewItem() async {
    DatabaseHelper dbHelper = DatabaseHelper();

    // Initialize the database
    await dbHelper.initDB();

    // Example usage of database operations
    List<Map<String, dynamic>> items = await dbHelper.getItems();

  //can change item's data manual from here
    Map<String, dynamic> newItem = {
      DatabaseHelper.itemId: 'item12',
      DatabaseHelper.itemName: 'Example Item2',
      DatabaseHelper.itemBarcode: '12345678',
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
    update();
  }
}
