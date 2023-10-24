import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static const String itemsTable = 'items';
  static const String stockRecordsTable = 'stock_records';

  static const String columnItemId = 'item_id';
  static const String columnItemName = 'item_name';
  static const String columnItemBarcode = 'item_barcode';
  static const String columnItemPrice = 'item_price';
  static const String columnItemQuantity = 'item_quantity';

  static const String columnRecordDocNo = 'record_doc_no';
  static const String columnRecordTime = 'record_time';
  static const String columnRecordItemId = 'record_item_id';
  static const String columnRecordItemQuantity = 'record_item_quantity';

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
            $columnItemId TEXT PRIMARY KEY,
            $columnItemName TEXT NOT NULL,
            $columnItemBarcode TEXT UNIQUE,
            $columnItemPrice REAL,
            $columnItemQuantity INTEGER NOT NULL
          )
        ''');

    await db.execute('''
          CREATE TABLE $stockRecordsTable (
            $columnRecordDocNo INTEGER AUTOINCREMENT,
            $columnRecordTime TEXT,
            $columnRecordItemId TEXT,
            $columnRecordItemQuantity INTEGER,
            FOREIGN KEY ($columnRecordItemId)
              REFERENCES $itemsTable ($columnItemId)
          )
        ''');
    print('onCreate===================');
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
    await db!.rawQuery('SELECT MAX($columnRecordDocNo) FROM $stockRecordsTable');
    int lastDocumentNumber = result[0]['MAX($columnRecordDocNo)'] ?? 0;
    return lastDocumentNumber + 1;
  }

  Future<DateTime> getCurrentDateTime() async {
    return DateTime.now();
  }

  Future<int> insertStockRecord(Map<String, dynamic> stockRecord) async {
    Database? db = await database;
    return await db!.insert(stockRecordsTable, stockRecord);
  }






}
