import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:steak2house/src/controllers/product_controller.dart';
import 'package:steak2house/src/models/product_model.dart';
import 'package:steak2house/src/screens/product_detail/product_detail_screen.dart';
import 'package:steak2house/src/services/products_service.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';
import 'package:steak2house/src/utils/utils.dart';

import 'empty_results.dart';

class SearchProducts extends SearchDelegate {
  @override
  final String searchFieldLabel;

  final _productCtrl = Get.find<ProductController>();
  final _utils = Utils.instance;

  SearchProducts() : this.searchFieldLabel = 'Buscar...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => this.query = '',
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      // onPressed: () => Get.off(() => MainScreen()),
      onPressed: () => this.close(context, null),
      icon: Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == '') {
      final productsHistory = _productCtrl.searchList;

      return Material(
        child: ListView.separated(
          physics: BouncingScrollPhysics(),
          itemCount: productsHistory.length,
          separatorBuilder: (_, i) => Divider(),
          itemBuilder: (_, idx) {
            final product = productsHistory[idx];
            return ListTile(
              leading: Icon(Icons.history),
              title: Text(product.name!),
              subtitle: Text(product.description!),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
              onTap: () {
                // close(context, null);
                _productCtrl.currentProduct.value = product;
                _productCtrl.productQty.value = 1;
                _productCtrl.fromSearch.value = true;
                _productCtrl.querySearch.value = this.query;
                Get.offNamedUntil(
                  ProductDetailScreen.routeName,
                  (_) => false,
                );
              },
            );
          },
        ),
      );
    }
    return buildSearchResults();
  }

  Widget buildSearchResults() {
    if (query == '') {
      return Container();
    }

    ProductService.instance.getSearchByQuery(this.query.trim());

    return StreamBuilder(
      stream: ProductService.instance.searchStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/loading.json',
                  width: _utils.getWidthPercent(.3),
                  height: _utils.getWidthPercent(.3),
                ),
                Text(
                  'Buscando...',
                  style: TextStyle(fontSize: 17),
                )
              ],
            ),
          );
        }

        final List<Product> products = snapshot.data;

        if (products.length == 0) {
          return EmptyResults(
            text: 'No se encontraron resultados para "$query"',
            svgSrc: 'assets/img/emptySearch.svg',
          );
        }

        return Material(
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemCount: products.length,
            separatorBuilder: (_, i) => Divider(),
            itemBuilder: (_, idx) {
              final product = products[idx];
              return ListTile(
                leading: Icon(Icons.search),
                title: Text(product.name!),
                subtitle: Text(product.description!),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
                onTap: () {
                  // close(context, null);
                  _productCtrl.currentProduct.value = product;
                  _productCtrl.productQty.value = 1;
                  _productCtrl.fromSearch.value = true;
                  _productCtrl.querySearch.value = this.query;

                  final exist = _productCtrl.searchList
                      .where((item) => item.id == product.id);

                  if (exist.isBlank == true) {
                    _productCtrl.searchList.add(product);
                  }

                  SharedPrefs.instance.setKey(
                    'searchList',
                    json.encode(_productCtrl.searchList),
                  );

                  Get.offNamedUntil(
                    ProductDetailScreen.routeName,
                    (_) => false,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
