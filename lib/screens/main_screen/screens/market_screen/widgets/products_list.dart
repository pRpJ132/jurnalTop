import 'package:flutter/material.dart';
import 'package:my_app/models/cart.dart';
import 'package:my_app/models/product_store.dart';
import 'package:my_app/screens/main_screen/screens/market_screen/widgets/balance_item.dart';
import 'package:provider/provider.dart';

Widget buildProductList(
  final ValueNotifier<List<ProductStore>> productStore,
) {
  return Expanded(
    child: Consumer<Cart>(
      builder: (_, cartValue, _) {
        if (!cartValue.isLoad) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ValueListenableBuilder(
          valueListenable: productStore,
          builder: (_, productStoreValue, _) {
            if (productStoreValue.isEmpty) {
              return Center(
                child: Text(
                  "Товары появятся здесь",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
        
            return Container(
              color: Colors.white,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 2;
        
                  if (constraints.maxWidth > 900) {
                    crossAxisCount = 4;
                  } else if (constraints.maxWidth > 600) {
                    crossAxisCount = 3;
                  }
        
                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: productStoreValue.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (context, index) {
                      final product = productStoreValue[index];
                      int lengthProductCart = 0;
                      if (cartValue.productStore.isNotEmpty && cartValue.productStore.any((el) => el.id == product.id)) {
                        lengthProductCart = cartValue.productStore.firstWhere(
                          (el) => el.id == product.id
                        ).quantity;
                      }

                      return GestureDetector(
                        onTap: () => _showProductDialog(context, product),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Image.network(
                                  product.url,
                                  fit: BoxFit.contain,
                                ),
                              ),
                        
                              const SizedBox(height: 8),
                        
                              Text(
                                product.title,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                        
                              const SizedBox(height: 5),
                        
                              Text(
                                "В наличии: ${product.quantity - lengthProductCart}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                        
                              const SizedBox(height: 8),
                        
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 10,
                                runSpacing: 5,
                                children: product.prices?.map((el) {
                                  return balanceItem(
                                    el.pointsSum.toString(),
                                    el.pointTypeId == 1
                                        ? "assets/top-coin.png"
                                        : "assets/top-gem.png",
                                  );
                                }).toList() ?? [],
                              ),
                        
                              SizedBox(height: 5),
                        
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: (product.quantity - lengthProductCart) > 0 
                                      ? const Color(0xFF188194) 
                                      : Colors.grey,
                                    overlayColor: (product.quantity - lengthProductCart) > 0 
                                      ? Colors.white
                                      : Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: (product.quantity - lengthProductCart) > 0 ? () async {
                                    await cartValue.addProduct(product);
                                  } : () {},
                                  child: const Text(
                                    "Добавить",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
        );
      }
    ),
  );
}

void _showProductDialog(
  BuildContext context,
  ProductStore product
) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Consumer<Cart>(
                builder: (_, cartValue, _) {
                  int lengthProductCart = 0;
                  if (cartValue.productStore.isNotEmpty && cartValue.productStore.any((el) => el.id == product.id)) {
                    lengthProductCart = cartValue.productStore.firstWhere(
                      (el) => el.id == product.id
                    ).quantity;
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.network(
                          product.url,
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                  
                      const SizedBox(height: 16),
                  
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  
                      const SizedBox(height: 8),
                  
                      Text(
                        product.description.isNotEmpty
                            ? product.description
                            : "Описание отсутствует",
                        style: const TextStyle(color: Colors.black),
                      ),
                  
                      const SizedBox(height: 12),
                  
                      Text(
                        "В наличии: ${product.quantity - lengthProductCart}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                  
                      const SizedBox(height: 12),
                  
                      Wrap(
                        spacing: 10,
                        runSpacing: 6,
                        children: product.prices?.map((price) {
                          return balanceItem(
                            price.pointsSum.toString(),
                            price.pointTypeId == 1
                                ? "assets/top-coin.png"
                                : "assets/top-gem.png",
                          );
                        }).toList() ?? [],
                      ),
                  
                      const SizedBox(height: 20),
                  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            style: ElevatedButton.styleFrom(
                              overlayColor: Colors.grey
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Закрыть",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: (product.quantity - lengthProductCart) > 0 
                                ? const Color(0xFF188194) 
                                : Colors.grey,
                              overlayColor: (product.quantity - lengthProductCart) > 0 
                                ? Colors.white
                                : Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: (product.quantity - lengthProductCart) > 0 ? () async {
                              await cartValue.addProduct(product);
                            } : () {},
                            child: const Text(
                              "Добавить", 
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              ),
            ),
          ),
        ),
      );
    },
  );
}