import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stocktaking/components/custom_text_field.dart';
import 'package:stocktaking/components/item_in_document_component.dart';

import '../database/database_helper.dart';

class NewDocumentScreen extends StatefulWidget {
  NewDocumentScreen({super.key});

  @override
  State<NewDocumentScreen> createState() => _NewDocumentScreenState();
}

class _NewDocumentScreenState extends State<NewDocumentScreen> {
  TextEditingController barcodeController = TextEditingController();

  TextEditingController quantityController = TextEditingController();

  List<Item> documentItems = []; // Maintain a list of items

  void addItem(
    String barcode,
    int quantity,
    String name,
  ) {
    bool foundMatch = false;

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
  }

  void showSnackBar(BuildContext context, message, backGroundColor) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backGroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  DatabaseHelper dbHelper = DatabaseHelper();
  Map itemData = {};
  int initialValue = 0;

  void getItemByBarcode(String barcode) async {
    Database? db = await dbHelper.database;

    List<Map<String, dynamic>> result = await db!.query(
      'items',
      columns: ['item_name', 'item_price', 'item_quantity', 'item_barcode'],
      where: 'item_barcode = ?',
      whereArgs: [barcode],
      limit: 1,
    );

    if (result.isNotEmpty) {
      itemData = result.first;
      print('${itemData['item_barcode']}');
      // if(itemData['item_barcode']==documentBarcodesItems[0]){
      //   documentItems[documentItems.indexWhere((element) => element == documentBarcodesItems[0])] = food;
      //
      // }

      // documentItemsMap[documentItemsMap.indexWhere((element) {
      //   return element['documentItemBarcode'] == itemData['item_barcode'];
      // })] =
      //     itemData;
      addItem(
        itemData['item_barcode'],
        int.parse(quantityController.text),
        itemData['item_name'],
      );
      // documentItemsMap.add({
      //   "documentItemName": itemData['item_name'],
      //   "documentItemQuantity": itemData['item_quantity'],
      //   "documentItemBarcode": itemData['item_barcode'],
      // });
      // documentItems.add(ItemInDocument(
      //     itemName: itemData['item_name'],
      //     itemQuantity: itemData['item_quantity']));
      barcodeController.text = '';
      quantityController.text = '1';
      print('result.first${documentItems}');
      // print('result.first${documentItems}');
      print('result.first${itemData['item_barcode']}');
    } else {
      itemData = {};
      showSnackBar(
          context, 'Sorry! there is no item with this barcode.', Colors.red);

      print('null');
    }
    setState(() {});
  }

  insertToRecordsTable() async {
    int lastDocumentNumber = await dbHelper.getLastDocumentNumber();
    DateTime currentDateTime = await dbHelper.getCurrentDateTime();

    Map<String, dynamic> newStockRecord = {
      DatabaseHelper.recordDocNo: lastDocumentNumber,
      DatabaseHelper.recordTime: currentDateTime.toString(),
      DatabaseHelper.recordItemId: 'item123',
      DatabaseHelper.recordItemQuantity: documentItems.length,
    };
    print('newStockRecord: $newStockRecord');
    int insertedStockRecordId =
        await dbHelper.insertStockRecord(newStockRecord);
    print('Stock record inserted. Record ID: $insertedStockRecordId');
  }

  Future<int> updateItemQuantity(List<Item> itemsInDocument) async {
    Database? db = await dbHelper.database;
    int rowsAffected=0;
    itemsInDocument.forEach((element) async {
       rowsAffected = await db!.update(
        'items',
        {'item_quantity': element.quantity},
        where: 'item_barcode = ?',
        whereArgs: [element.barcode],
      );
    });

    print('rowsAffected$rowsAffected');
    return rowsAffected;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Document No. 1',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Column(
                  children: [
                    const Text(
                      'Barcode',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 260,
                      child: CustomTextField(
                        labelTxt: '',
                        hintTxt: '',
                        textController: barcodeController,
                        validator: (String? str) {},
                        onFieldSubmitted: (String? str) {},
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Qty.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 100,
                      child: CustomTextField(
                        labelTxt: '',
                        hintTxt: '',
                        textController: quantityController,
                        validator: (String? str) {},
                        onFieldSubmitted: (String? str) {},
                      ),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  print('barcodeController.text${barcodeController.text}');
                  getItemByBarcode(barcodeController.text);
                },
                child: const Text('Add')),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: ((context, index) {
                  // return myMap[index] as Widget;
                  return ItemInDocument(
                      itemName: documentItems[index].name,
                      itemQuantity: documentItems[index].quantity);
                }),
                itemCount: documentItems.length,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: documentItems.isNotEmpty
            ? Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      // print(
                      //     'quantityController.text${quantityController.text}');
                      insertToRecordsTable();
                      updateItemQuantity(
                              documentItems)
                          .then((value) {
                        showSnackBar(context, 'Document Saved Successfully.',
                            Colors.green);
                        Get.back();
                      });
                    },
                    child: const Text('Save')),
              )
            : Container(),
      ),
    );
  }
}

class Item {
  final String barcode;
  String name;
  int quantity;

  Item(this.barcode, this.quantity, this.name);
}
