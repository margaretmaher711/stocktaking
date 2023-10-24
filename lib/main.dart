import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stocktaking/components/main_menu_item.dart';

import 'database/database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

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
      DatabaseHelper.columnItemId: 'item12',
      DatabaseHelper.columnItemName: 'Example Item',
      DatabaseHelper.columnItemBarcode: '1234567899',
      DatabaseHelper.columnItemPrice: 9.99,
      DatabaseHelper.columnItemQuantity: 10,
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
      // DatabaseHelper.columnRecordDocNo: lastDocumentNumber,
      DatabaseHelper.columnRecordTime: currentDateTime.toString(),
      DatabaseHelper.columnRecordItemId: 'item123',
      DatabaseHelper.columnRecordItemQuantity: 5,
    };

    int insertedStockRecordId =
        await dbHelper.insertStockRecord(newStockRecord);
    print('Stock record inserted. Record ID: $insertedStockRecordId');
    var ktkt = await dbHelper.getLastDocumentNumber();
    print('ktkt${ktkt}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {},
              child: MainMenuItem(
                  title: 'New Stocktaking Document', color: Colors.blue),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () {},
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
