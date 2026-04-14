import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app/models/product_store.dart';
import 'package:my_app/network/api_client.dart';
import 'package:my_app/screens/main_screen/screens/market_screen/widgets/balance_item.dart';
import 'package:my_app/screens/main_screen/screens/market_screen/widgets/cart_list.dart';
import 'package:my_app/screens/main_screen/screens/market_screen/widgets/my_purchases.dart';
import 'package:my_app/screens/main_screen/screens/market_screen/widgets/products_list.dart';
import 'package:my_app/services/db/cart_product_db.dart';
import 'package:my_app/services/user_storage.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  static int topcoins = 0;
  static int topgems = 0;
  static final ValueNotifier<List<ProductStore>> _productStore = ValueNotifier([]);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final dbCartProduct = CartProductDatabase();
  String selectedValuePopMenu = "shop";


  Future<void> initUserData() async {
    final coins = await UserStorage.getTopCoins() ?? 0;
    final gems = await UserStorage.getTopGems() ?? 0;

    setState(() {
      topcoins = coins;
      topgems = gems;
    });
  }

  void loadProductStore() async {
    try {
      _isLoading.value = true;
      final response = await ApiClient.get("market/customer/product/list?page=1&type=0");
      if (response.statusCode == 200) {
        _productStore.value = jsonDecode(response.body)["products_list"]
          .map<ProductStore>((el) => ProductStore.fromJson(el)).toList();
      }
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    initUserData();
    loadProductStore();
  }

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                "Магазин".toUpperCase(),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
    
                Row(
                  spacing: 15,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!isMobile) ...[
                      _headerButton("Магазин", "shop"),
                      _headerButton("Корзина", "cart"),
                      _headerButton("Мои покупки", "orders"),
                    ],
                    if (isMobile) ...[
                      balanceItem(topcoins.toString(), "assets/top-coin.png"),
                      balanceItem(topgems.toString(), "assets/top-gem.png"),
                    ]
                  ],
                ),
              ],
            ),
    
            const SizedBox(height: 20),
    
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ValueListenableBuilder(
                  valueListenable: _isLoading,
                  builder: (_, isLoadingValue, _) {
                    if(isLoadingValue && _productStore.value.isEmpty) {
                      final newProductStore = ValueNotifier(List.generate(
                        10,
                        (int index) => ProductStore(
                          id: index, 
                          description: '----------', 
                          vendorCode: '----------', 
                          status: 0, 
                          dynamicPriceStatus: 0, 
                          title: '-----------------', 
                          quantity: 10, 
                          fileName: '', 
                          url: ''
                        ) 
                      ));
                      return Skeletonizer(
                        enabled: true,
                        child: Column(
                          crossAxisAlignment: .end,
                          children: [
                            if (isMobile)
                            PopupMenuButton<String>(
                              initialValue: selectedValuePopMenu,
                              onSelected: (value) => setState(() => selectedValuePopMenu = value),
                              icon: const Icon(Icons.menu),
                              color: Colors.white,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: "shop",
                                  child: Text("Магазин"),
                                ),
                                const PopupMenuItem(
                                  value: "cart",
                                  child: Text("Корзина"),
                                ),
                                const PopupMenuItem(
                                  value: "orders",
                                  child: Text("Мои покупки"),
                                ),
                              ],
                            ),

                            if (selectedValuePopMenu == "shop")
                              buildProductList(newProductStore)
                            else if (selectedValuePopMenu == "cart")
                              buildCartList(newProductStore.value)
                            else
                              buildMyPurchases()
                          ],
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: .end,
                      children: [
                        if (isMobile)
                        PopupMenuButton<String>(
                          initialValue: selectedValuePopMenu,
                          onSelected: (value) => setState(() => selectedValuePopMenu = value),
                          icon: const Icon(Icons.menu),
                          color: Colors.white,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: "shop",
                              child: Text("Магазин"),
                            ),
                            const PopupMenuItem(
                              value: "cart",
                              child: Text("Корзина"),
                            ),
                            const PopupMenuItem(
                              value: "orders",
                              child: Text("Мои покупки"),
                            ),
                          ],
                        ),
                        if (selectedValuePopMenu == "shop")
                          buildProductList(_productStore)
                        else if (selectedValuePopMenu == "cart")
                          buildCartList(_productStore.value)
                        else
                          buildMyPurchases()
                      ],
                    );
                  }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerButton(String text, String value) {
    return TextButton(
      style: TextButton.styleFrom(
        elevation: 0,
        overlayColor: Colors.grey,
      ),
      onPressed: () => setState(() => selectedValuePopMenu = value),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black
        ),
      ),
    );
  }
}