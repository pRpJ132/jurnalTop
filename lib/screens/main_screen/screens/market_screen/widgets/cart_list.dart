import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/cart.dart';
import 'package:my_app/models/product_store.dart';
import 'package:my_app/screens/main_screen/screens/market_screen/widgets/balance_item.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget buildCartList(
  final List<ProductStore> productStore,
) {
  return Consumer<Cart>(
    builder: (_, cartValue, _) {
      if (cartValue.isLoad) {
        return Skeletonizer(
          enabled: cartValue.isLoad,
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 2;
              if (constraints.maxWidth > 900) {
                crossAxisCount = 4;
              } else if (constraints.maxWidth > 600) {
                crossAxisCount = 3;
              }
              return GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                itemCount: productStore.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final product = productStore[index];
                  return _buildContainerProduct(product, cartValue);
                },
              );
            },
          ),
        );
      }
      
      return LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 2;
          
          if (constraints.maxWidth > 900) {
            crossAxisCount = 4;
          } else if (constraints.maxWidth > 600) {
            crossAxisCount = 3;
          }
          
          return GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            itemCount: cartValue.productStore.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final product = cartValue.productStore[index];
              
              return _buildContainerProduct(product, cartValue);
            },
          );
        },
      );
    }
  );
}

Widget _buildContainerProduct(
  ProductStore product,
  Cart cartValue
) {
  int lengthProductCart = 0;
  if (cartValue.productStore.isNotEmpty && cartValue.productStore.any((el) => el.id == product.id)) {
    lengthProductCart = cartValue.productStore.firstWhere(
      (el) => el.id == product.id
    ).quantity;
  }
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Stack(
      children: [
        Column(
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
              "Количество: ${product.quantity}",
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
            if (product.quantity - lengthProductCart > 0)
            Row(
              mainAxisAlignment: .center,
              children: [
                IconButton(
                  onPressed: () {}, 
                  icon: Icon(
                    CupertinoIcons.minus_circle,
                    size: 22,
                  )
                ),
                IconButton(
                  onPressed: () {}, 
                  icon: Icon(
                    CupertinoIcons.add_circled,
                    size: 22,
                  )
                ),
              ],
            )
          ],
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              await cartValue.deleteProduct(product.id);
            }, 
            icon: Icon(
              CupertinoIcons.delete,
              color: Colors.red,
              size: 20
            )
          ),
        ),
      ],
    ),
  );
}