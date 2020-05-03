library cmd;

import 'dart:io' as io;

import 'package:cw_sdk_dart/cw_sdk_dart.dart' as sdk show RestApiV1Client;

main() {
  var apiClient = new sdk.RestApiV1Client();
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

    io.exit(0);
  }, onError: (e) => print(e));
}
