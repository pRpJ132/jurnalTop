import 'package:flutter/material.dart';
import 'package:my_app/models/product_store.dart';
import 'package:my_app/services/db/cart_product_db.dart';
import 'package:my_app/services/logger.dart';

class Cart extends ChangeNotifier {
  List<ProductStore> productStore = [];
  bool isLoad = false;

  Cart() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      isLoad = true;
      productStore = await CartProductDatabase().getProductsStore();
      notifyListeners();
    } catch (e) {
      logger.e('Load products error: $e');
    } finally {
      isLoad = false;
    }
  }

  Future<void> addProduct(ProductStore ps) async {
    final index = productStore.indexWhere((el) => el.id == ps.id);
    if (index != -1) {
      productStore[index].quantity++;
    } else {
      final newProduct = ps.copyWith(quantity: 1);
      productStore.add(newProduct);
    }
    await CartProductDatabase().saveProducts(productStore);
    notifyListeners();
  }

  Future<void> deleteProduct(int id) async {
    productStore.removeWhere((el) => el.id == id);
    await CartProductDatabase().saveProducts(productStore);
    notifyListeners();
  }

  void setProduct(List<ProductStore> ps) {
    productStore = ps;
    notifyListeners();
  }
}