library cmd;

import 'dart:io' as io;

import 'package:cw_sdk_dart/cw_sdk_dart.dart' as sdk show RestApiClient;

main() {
  var apiClient = new sdk.RestApiClient();
  var assetsFuture = apiClient.fetchAssets();
  assetsFuture.then((assets) {
    for (var a in assets) {
      print(a);
    }
  }, onError: (e) => print(e));

  var pairsFuture = apiClient.fetchPairs();
  pairsFuture.then((pairs) {
    for (var p in pairs) {
      print(p);
    }
  }, onError: (e) => print(e));

  var exchangesFuture = apiClient.fetchExchanges();
  exchangesFuture.then((exchanges) {
    for (var e in exchanges) {
      print(e);
    }
  }, onError: (e) => print(e));

  var marketsFuture = apiClient.fetchMarkets();
  marketsFuture.then((markets) {
    for (var m in markets) {
      print(m);
    }

    io.exit(0);
  }, onError: (e) => print(e));
}
