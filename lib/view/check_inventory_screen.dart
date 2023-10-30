import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stocktaking/components/custom_text_field.dart';

import '../database/database_helper.dart';

class CheckInventoryScreen extends StatefulWidget {
  CheckInventoryScreen({super.key});

  @override
  State<CheckInventoryScreen> createState() => _CheckInventoryScreenState();
}

class _CheckInventoryScreenState extends State<CheckInventoryScreen> {
  TextEditingController barcodeController = TextEditingController();

  Map itemData = {};
  final snackBar = SnackBar(
    content: Text('Sorry! there is no item with this barcode.'),
    backgroundColor: Colors.red,
  );

  void getItemByBarcode(String barcode) async {
    DatabaseHelper dbHelper = DatabaseHelper();

    Database? db = await dbHelper.database;

    List<Map<String, dynamic>> result = await db!.query(
      'items',
      columns: ['item_name', 'item_price', 'item_quantity'],
      where: 'item_barcode = ?',
      whereArgs: [barcode],
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Barcode',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                child: CustomTextField(
                  labelTxt: '',
                  hintTxt: '',
                  textController: barcodeController,
                  validator: (String? str) {},
                  onFieldSubmitted: (String? str) {
                    getItemByBarcode(barcodeController.text);
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              itemData.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text('${itemData['item_name']}')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Price',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text('${itemData['item_price']}')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Quantity',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text('${itemData['item_quantity']}')
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
