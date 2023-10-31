import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stocktaking/components/custom_text_field.dart';
import 'package:stocktaking/components/item_in_document_component.dart';
import 'package:stocktaking/controller/new_document_controller.dart';

import '../database/database_helper.dart';

class NewDocumentScreen extends StatelessWidget {
  // NewDocumentScreen({Key? key}) : super(key: key);


  final NewDocumentController tryController=NewDocumentController();

  @override
  Widget build(BuildContext context) {
    Get.put(NewDocumentController()).getLastDocumentNo();

    return Scaffold(
      body: SingleChildScrollView(
        child: GetBuilder<NewDocumentController>(
            init: NewDocumentController(),
            builder: (newDocumentController) {
              // print(newDocumentController.g);
              return Column(
                children: [
                  const SizedBox(height: 30),
                   Text(
                    'Document No. ${newDocumentController.lastDocumentNumber}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
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
                              textController: newDocumentController.barcodeController,
                               
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
                              textController: newDocumentController.quantityController,
                              onFieldSubmitted: (String? str) {},
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      newDocumentController.getItemByBarcode(context);
                    },
                    child: const Text('Add'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return ItemInDocument(
                          itemName:
                              newDocumentController.documentItems[index].name,
                          itemQuantity: newDocumentController
                              .documentItems[index].quantity,
                        );
                      },
                      itemCount: newDocumentController.documentItems.length,
                    ),
                  ),
                ],
              );
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GetBuilder<NewDocumentController>(init: NewDocumentController(),
        builder: (newDocumentController) {
          return Container(
            height: 50,
            margin: const EdgeInsets.all(10),
            child: newDocumentController.documentItems.isNotEmpty
                ? Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        newDocumentController.insertToRecordsTable();
                        newDocumentController.updateItemQuantity().then((value) {
                          newDocumentController.showSnackBar(
                            context,
                            'Document Saved Successfully.',
                            Colors.green,
                          );
                          Get.back();
                        });
                      },
                      child: const Text('Save'),
                    ),
                  )
                : Container(),
          );
        }
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
