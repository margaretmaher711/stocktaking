import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static const String itemsTable = 'items';
  static const String recordsTable = 'stock_records';

  static const String itemId = 'item_id';
  static const String itemName = 'item_name';
  static const String itemBarcode = 'item_barcode';
  static const String itemPrice = 'item_price';
  static const String itemQuantity = 'item_quantity';

  static const String recordDocNo = 'record_doc_no';
  static const String recordTime = 'record_time';
  static const String recordItemId = 'record_item_id';

  static const String recordItemQuantity = 'record_item_quantity';

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'stocktaking.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(Database db, int version) async {


    await db.execute('''
      CREATE TABLE $itemsTable (
        $itemId TEXT NOT NULL PRIMARY KEY, 
        $itemName TEXT NOT NULL,
        $itemBarcode TEXT UNIQUE NOT NULL,
        $itemPrice REAL NOT NULL,
        $itemQuantity INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $recordsTable (
        $recordDocNo INTEGER NOT NULL, 
        $recordTime TEXT NOT NULL,
        $recordItemId TEXT NOT NULL,
        $recordItemQuantity INTEGER NOT NULL,
        PRIMARY KEY ($recordDocNo, $recordTime, $recordItemId),
        FOREIGN KEY ($recordItemId) REFERENCES items ($itemId)
      )
    ''');

    print("onCreate =====================================");
  }
  Future<List<Map<String, dynamic>>> getItems() async {
    Database? db = await database;
    return await db!.query(itemsTable);
  }

  Future<int> insertItem(Map<String, dynamic> item) async {
    Database? db = await database;
    return await db!.insert(itemsTable, item);
  }


  Future<int> getLastDocumentNumber() async {
    Database ?db = await database;
    List<Map<String, dynamic>> result =
    await db!.rawQuery('SELECT MAX($recordDocNo) FROM $recordsTable');
    int lastDocumentNumber = result[0]['MAX($recordDocNo)'] ?? 0;
    return lastDocumentNumber + 1;
  }

  Future<DateTime> getCurrentDateTime() async {
    return DateTime.now();
  }

  Future<int> insertStockRecord(Map<String, dynamic> stockRecord) async {
    Database? db = await database;
    return await db!.insert(recordsTable, stockRecord);
  }






}
