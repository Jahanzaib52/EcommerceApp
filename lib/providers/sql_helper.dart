import 'package:pakbazzar/providers/product_class.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static Database? _database;
  static Future<Database> get database async {
    if (_database != null) return _database!;
    return await initializeDB();
  }

  static Future<Database> initializeDB() async {
    final path = join(await getDatabasesPath(), "shopping.db");
    return await openDatabase(path, version: 1, onCreate: onCreate);
  }

  static Future onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
      CREATE TABLE cart_products(
        productId TEXT PRIMARY KEY,
        name TEXT,
        price DOUBLE,
        purchaseQty INTEGER,
        instockQty INTEGER,
        imagesUrl TEXT,
        suppId TEXT
      )
    ''');
    batch.execute('''
      CREATE TABLE wish_products(
        productId TEXT PRIMARY KEY,
        name TEXT,
        price DOUBLE,
        purchaseQty INTEGER,
        instockQty INTEGER,
        imagesUrl TEXT,
        suppId TEXT
      )
    ''');
    batch.commit();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////
  //Create
  static Future createProductInCart(Product product) async {
    final db = await database;
    await db.insert("cart_products", product.toMap());
  }

  //Read
  static Future<List<Map<String,dynamic>>> readProductInCart() async {
    final db = await database;
    return db.query("cart_products");
  }

  //Update
  static Future updateQty(Product product, String status) async {
    final db = await database;
    await db.update(
      "cart_products",
      {
        "purchaseQty": status == "increment"
            ? product.purcahseQty + 1
            : product.purcahseQty - 1
      },
      where: "productId=?",
      whereArgs: [product.productId],
    );
  }

  //Delete
  static Future deleteProductInCart(Product product) async {
    final db = await database;
    await db.delete(
      "cart_products",
      where: "productId=?",
      whereArgs: [product.productId],
    );
  }

  //Clear Cart
  static Future clearCart() async {
    final db = await database;
    await db.delete("cart_products");
  }

   //////////////////////////////////////////////////////////////////////////////////////////////
  //Create
  static Future createProductInWhishlist(Product product) async {
    final db = await database;
    await db.insert("wish_products", product.toMap());
  }

  //Read
  static Future<List<Map<String,dynamic>>> readProductInWhishlist() async {
    final db = await database;
    return db.query("wish_products");
  }

  //Delete
  static Future deleteProductInWhishlist(Product product) async {
    final db = await database;
    await db.delete(
      "wish_products",
      where: "productId=?",
      whereArgs: [product.productId],
    );
  }
  //Delete this
  static Future deleteThisProductInWhishlist(String productId) async {
    final db = await database;
    await db.delete(
      "wish_products",
      where: "productId=?",
      whereArgs: [productId],
    );
  }

  //Clear
  static Future clearWhishlist() async {
    final db = await database;
    await db.delete("wish_products");
  }
}
