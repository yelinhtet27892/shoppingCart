import 'package:shopping/model/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseHelper {
  String databaseName = 'cart.db';
  String tableName = 'cart';
  String column_id = 'id';
  String productId = 'productId';
  String productName = 'productName';
  String initialPrice = 'initialPrice';
  String productPrice = 'productPrice';
  String quantity = 'quantity';
  String unitTag = 'unitTag';
  String image = 'Image';

  Future<Database> getDatabase() async {
    String dir = await getDatabasesPath();
    return openDatabase(path.join(dir, databaseName),
        onCreate: createDatabase, version: 1);
  }

  void createDatabase(Database db, int version) {
    String sql =
        'CREATE TABLE $tableName($column_id INTEGER PRIMARY KEY,$productId VARCHAR UNIQUE,$productName TEXT,$initialPrice INTEGER,$productPrice INTEGER,$quantity INTEGER,$unitTag TEXT,$image TEXT)';
    db.execute(sql);
  }

  Future<int> insertData(Cart cart) async {
    Database db = await getDatabase();
    return db.insert(tableName, cart.toMap(),conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<Cart>> getCartList() async {
    Database db = await getDatabase();
    List<Map<String, Object?>> res = await db.query(tableName);

    return res.map((e) => Cart.fromMap(e)).toList();
  }

  Future<int> deleteData(int id) async {
    Database db = await getDatabase();
    return db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateData(Cart cart) async {
    Database db = await getDatabase();
    return db
        .update(tableName, cart.toMap(), where: 'id=?', whereArgs: [cart.id]);
  }
}
