import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stocktaking/components/main_menu_item.dart';
import 'package:stocktaking/view/check_inventory_screen.dart';
import 'package:stocktaking/view/new_document_screen.dart';

import 'database/database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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

    // try {
    //   int insertedItemId = await dbHelper.insertItem(newItem);
    //   print('Item inserted. Item ID: $insertedItemId');
    // } catch (e) {
    //   if (e is DatabaseException) {
    //     if (e.isUniqueConstraintError()) {
    //       print('Item insertion failed: Duplicate barcode $e');
    //     } else {
    //       print('Item insertion failed: ${e.result}');
    //     }
    //   } else {
    //     print('Item insertion failed: $e');
    //   }
    // }

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
