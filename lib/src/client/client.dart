library client;

import 'dart:convert' as convert show jsonDecode;

import 'package:http/http.dart' as http;

import '../common/common.dart' as common show Asset, Pair;

const defaultApiDomain = "api.cryptowat.ch";

const unexpectedResponseFormat = "Unexpected format for response";

var httpClient = http.Client();

class RestApiV1Client {
  final String _apiDomain;
  final String _apiKey;

  RestApiV1Client([this._apiDomain = defaultApiDomain, this._apiKey = ""]);

  Future<http.Response> _doApiRequest(String path) {
    var endpoint = Uri.https(this._apiDomain, path);
    return httpClient.get(endpoint.toString());
  }

  /// Returns a Future that resolves to a list of assets from the cryptowatch REST API.
  Future<List<common.Asset>> fetchAssets() {
    var ret = Future(() {
      var respFuture = this._doApiRequest("assets");
      return respFuture.then((resp) {
        var unpacked = convert.jsonDecode(resp.body);
        if (unpacked is! Map) {
          throw unexpectedResponseFormat;
        }

        var unparsedAssetList = unpacked["result"];
        if (unparsedAssetList is! List) {
          throw unexpectedResponseFormat;
        }

        var assetList = new List<common.Asset>();

        for (var unparsedAsset in unparsedAssetList) {
          assetList.add(_parseAsset(unparsedAsset));
        }

        return assetList;
      });
    });

    return ret;
  }

  /// Returns a Future that resolves to a list of pairs from the cryptowatch REST API.
  Future<List<common.Pair>> fetchPairs() {
    var ret = Future(() {
      var respFuture = this._doApiRequest("pairs");
      return respFuture.then((resp) {
        var unpacked = convert.jsonDecode(resp.body);
        if (unpacked is! Map) {
          throw unexpectedResponseFormat;
        }

        var unparsedPairList = unpacked["result"];
        if (unparsedPairList is! List) {
          throw unexpectedResponseFormat;
        }

        var pairList = new List<common.Pair>();

        for (var unparsedPair in unparsedPairList) {
          pairList.add(_parsePair(unparsedPair));
        }

        return pairList;
      });
    });

    return ret;
  }
}

_parseAsset(Map<String, dynamic> props) {
  var id = props["id"];
  var name = props["name"];
  var symbol = props["symbol"];
  var fiat = props["fiat"];

  return new common.Asset(id, name, symbol, fiat);
}

_parsePair(Map<String, dynamic> props) {
  var id = props["id"];
  var symbol = props["symbol"];
  var base = _parseAsset(props["base"]);
  var quote = _parseAsset(props["quote"]);
  var futuresContractPeriod = props["futuresContractPeriod"];

  return new common.Pair(
    id,
    symbol,
    base,
    quote,
    futuresContractPeriod,
  );
}
