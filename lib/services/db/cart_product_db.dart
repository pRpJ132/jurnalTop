import 'package:my_app/models/product_store.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CartProductDatabase {
  static final CartProductDatabase _instance = CartProductDatabase._internal();
  factory CartProductDatabase() => _instance;
  CartProductDatabase._internal();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cart-prod-0-0-5-test.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {

        await db.execute('''
          CREATE TABLE product_store (
            id INTEGER,
            description TEXT,
            vendor_code TEXT,
            status INTEGER,
            dynamic_price_status INTEGER,
            title TEXT,
            quantity INTEGER,
            file_name TEXT,
            url TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE prices_product (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            product_id INTEGER,
            point_type_id INTEGER,
            points_sum INTEGER,
            FOREIGN KEY(product_id) REFERENCES product_store(id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  Future<void> saveProducts(List<ProductStore> ps) async {
    final db = await database;

    db.delete('product_store');
    db.delete('prices_product');

    for (ProductStore product in ps) {
      await db.insert('product_store', {
        'id': product.id,
        'description': product.description,
        'vendor_code': product.vendorCode,
        'status': product.status,
        'dynamic_price_status': product.dynamicPriceStatus,
        'title': product.title,
        'quantity': product.quantity,
        'file_name': product.fileName,
        'url': product.url
      });

      if (product.prices != null) {
        for (PricesProduct price in product.prices!) {
          await db.insert('prices_product', {
            'product_id': product.id,
            'point_type_id': price.pointTypeId,
            'points_sum': price.pointsSum,
          });
        }
      }
    }
  }

  Future<List<ProductStore>> getProductsStore() async {
    final db = await database;

    final productRows = await db.query('product_store');

    List<ProductStore> products = [];

    for (var productRow in productRows) {
      final productId = productRow['id'];

      final priceRows = await db.query(
        'prices_product',
        where: 'product_id = ?',
        whereArgs: [productId],
      );

      List<PricesProduct> prices = priceRows.map((price) {
        return PricesProduct(
          pointTypeId: price['point_type_id'] as int,
          pointsSum: price['points_sum'] as int,
        );
      }).toList();

      final productStoreAdd = ProductStore.fromJson(productRow);
      productStoreAdd.prices = prices;

      products.add(productStoreAdd);
    }

    return products;
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete('prices_product');
    await db.delete('product_store');
  }
}