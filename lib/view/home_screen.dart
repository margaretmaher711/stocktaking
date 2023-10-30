import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../components/main_menu_item.dart';
import '../database/database_helper.dart';
import 'check_inventory_screen.dart';
import 'new_document_screen.dart';

class HomeScreen extends StatefulWidget {


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void _incrementCounter() async {
    DatabaseHelper dbHelper = DatabaseHelper();

    // Initialize the database
    await dbHelper.initDB();

    // Example usage of database operations
    List<Map<String, dynamic>> items = await dbHelper.getItems();
    print('Items: $items');

    Map<String, dynamic> newItem = {
      DatabaseHelper.itemId: 'item12',
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

    int lastDocumentNumber = await dbHelper.getLastDocumentNumber();
    DateTime currentDateTime = await dbHelper.getCurrentDateTime();

    Map<String, dynamic> newStockRecord = {
      DatabaseHelper.recordDocNo: lastDocumentNumber,
      DatabaseHelper.recordTime: currentDateTime.toString(),
      DatabaseHelper.recordItemId: 'item123',
      DatabaseHelper.recordItemQuantity: 5,
    };
    print('newStockRecord: $newStockRecord');
    int insertedStockRecordId =
    await dbHelper.insertStockRecord(newStockRecord);
    print('Stock record inserted. Record ID: $insertedStockRecordId');
    var ktkt = await dbHelper.getLastDocumentNumber();
    print('ktkt${ktkt}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                Get.to(()=>NewDocumentScreen());
              },
              child: MainMenuItem(
                  title: 'New Stocktaking Document', color: Colors.blue),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () {Get.to(()=>CheckInventoryScreen());},
                child:
                MainMenuItem(title: 'Check Inventory', color: Colors.red)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}