part of req;

const unexpectedAssetResponseFormat = "Unexpected format for assets response";

Future<List<common.Asset>> fetchAssets() {
  var ret = Future(() {
    var respFuture = client.get(assetsEndpoint);
    return respFuture.then((resp) {
      var unpacked = convert.jsonDecode(resp.body);
      if (unpacked is! Map) {
        throw unexpectedAssetResponseFormat;
      }

      var rawAssetList = unpacked["result"];
      if (rawAssetList is! List) {
        throw unexpectedAssetResponseFormat;
      }

      var assetList = new List<common.Asset>();

      for (var rawAsset in rawAssetList) {
        var id = rawAsset["id"];
        var name = rawAsset["name"];
        var symbol = rawAsset["symbol"];
        var fiat = rawAsset["fiat"];

        assetList.add(new common.Asset(id, name, symbol, fiat));
      }

      return assetList;
    });
  });

  return ret;
}
