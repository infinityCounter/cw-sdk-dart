library cmd;

import 'dart:io' as io;

import 'package:cw_sdk_dart/cw_sdk_dart.dart' as sdk show RestApiClient;

main() {
  var apiClient = new sdk.RestApiClient();
  var futures = new List<Future>();

  futures.add(apiClient.fetchAssets());
  futures.add(apiClient.fetchPairs());
  futures.add(apiClient.fetchExchanges());
  futures.add(apiClient.fetchMarkets());
  futures.add(apiClient.fetchAsset("btc"));

  Future.wait(futures).then((List<dynamic> results) {
    var assets = results[0];
    var pairs = results[1];
    var exchanges = results[2];
    var markets = results[3];
    var btc = results[4];

    for (var a in assets) {
      print(a);
    }

    for (var p in pairs) {
      print(p);
    }

    for (var e in exchanges) {
      print(e);
    }

    for (var m in markets) {
      print(m);
    }

    print(btc);
    io.exit(0);
  }, onError: (e) {
    print(e);
    io.exit(1);
  });
}
