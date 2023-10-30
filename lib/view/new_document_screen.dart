import 'package:flutter/material.dart';
import 'package:stocktaking/components/custom_text_field.dart';
import 'package:stocktaking/components/item_in_document_component.dart';

class NewDocumentScreen extends StatelessWidget {
  NewDocumentScreen({super.key});

  TextEditingController barcodeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  List documentItems = [ItemInDocument(itemName: 'itemName', itemQuantity: 5)];

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
                      textController: barcodeController,
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
              onPressed: () {},
              child: const Text('Add')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: ((context, index) {
                // return myMap[index] as Widget;
                return documentItems[index];
              }),
              itemCount: documentItems.length,
            ),
          ),
          const SizedBox(
            height: 330,
          ),
          documentItems.isNotEmpty
              ? Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {},
                      child: const Text('Save')),
                )
              : Container(),
        ],
      ),
    ));
  }
}
