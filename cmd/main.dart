library cmd;

import 'dart:io' as io;

import 'package:cw_sdk_dart/cw_sdk_dart.dart' as sdk;

main() {
  var res = sdk.fetchAssets();
  res.then((assets) {
    for (var a in assets) {
      print(a);
    }

    io.exit(0);
  }, onError: (e) => print(e));
}
