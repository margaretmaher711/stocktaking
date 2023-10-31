import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stocktaking/controller/home_controller.dart';

import '../components/main_menu_item.dart';
import 'check_inventory_screen.dart';
import 'new_document_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeController homeController=HomeController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Get.to(() => NewDocumentScreen());
                },
                child: MainMenuItem(
                    title: 'New Stocktaking Document', color: Colors.blue),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () {
                    Get.to(() => CheckInventoryScreen());
                  },
                  child:
                      MainMenuItem(title: 'Check Inventory', color: Colors.red)),
            ],
          ),
        ),
      ),
      floatingActionButton: (

           FloatingActionButton(
            onPressed: () {
              homeController.insertNewItem();
            },
            tooltip: 'insert an item',
            child: const Icon(Icons.insert_drive_file_rounded),
          )

      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
