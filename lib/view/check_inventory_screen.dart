import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stocktaking/components/custom_text_field.dart';
import 'package:stocktaking/controller/check_inventory_controller.dart';


class CheckInventoryScreen extends StatelessWidget {
  CheckInventoryScreen({super.key});

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
              GetBuilder<CheckInventoryController>(
                  init: CheckInventoryController(),
                  builder: (checkInventoryController) {
                    return Column(
                      children: [
                        SizedBox(
                          child: CustomTextField(
                            labelTxt: '',
                            hintTxt: '',
                            textController:
                                checkInventoryController.barcodeController,

                            onFieldSubmitted: (String? str) {
                              checkInventoryController
                                  .getItemByBarcode(context);
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        checkInventoryController.itemData.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 45.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                            '${checkInventoryController.itemData['item_name']}')
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Price',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                            '${checkInventoryController.itemData['item_price']}')
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Quantity',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                            '${checkInventoryController.itemData['item_quantity']}')
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
