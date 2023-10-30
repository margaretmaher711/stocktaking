import 'package:flutter/material.dart';
import 'package:stocktaking/components/custom_text_field.dart';

class CheckInventoryScreen extends StatelessWidget {
  CheckInventoryScreen({super.key});

  TextEditingController barcodeController = TextEditingController();

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
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Name',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text('data')
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text('data')
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantity',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text('data')
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
