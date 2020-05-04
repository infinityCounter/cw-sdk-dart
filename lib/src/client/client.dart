library client;

import 'dart:convert' as convert show jsonDecode;

import 'package:http/http.dart' as http show Client, read;

import '../common/common.dart' as common;

const defaultApiDomain = "api.cryptowat.ch";

const unexpectedResponseFormat = "Unexpected format for response";

const _apiKeyHeader = "X-CW-API-Key";

var httpClient = http.Client();

/// RestApiClient provides an interface for interacting with the Cryptowatch REST API.
///
/// The methods implemented by this class all return a Future object instead of the actual
/// result. CW API docs available at: https://docs.cryptowat.ch/rest-api/
class RestApiClient {
  final String _apiDomain;
  final String _apiKey;

  RestApiClient({String apiDomain: defaultApiDomain, String apiKey: ""})
      : this._apiDomain = apiDomain,
        this._apiKey = apiKey;

  Future<String> _doApiRequest(String path) {
    var endpoint = Uri.https(this._apiDomain, path);

    if (this._apiKey is String && this._apiKey != "") {
      return http.read(endpoint, headers: {_apiKeyHeader: this._apiKey});
    }

    return http.read(endpoint);
  }

  /// Returns a Future that resolves to a list of assets from the cryptowatch REST API.
  Future<List<common.Asset>> fetchAssets() {
    var ret = Future(() {
      var respFuture = this._doApiRequest("assets");
      return respFuture.then((respBody) {
        var unpacked = convert.jsonDecode(respBody);
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

  Future<common.Asset> fetchAsset(String sym) {
    var ret = Future(() {
      var respFuture = this._doApiRequest("assets/${sym}");
      return respFuture.then((respBody) {
        var unpacked = convert.jsonDecode(respBody);
        if (unpacked is! Map) {
          throw unexpectedResponseFormat;
        }

        var unparsedAsset = unpacked["result"];
        if (unparsedAsset is! Map) {
          throw unexpectedResponseFormat;
        }

        return _parseAsset(unparsedAsset);
      });
    });

    return ret;
  }

  /// Returns a Future that resolves to a list of pairs from the cryptowatch REST API.
  Future<List<common.Pair>> fetchPairs() {
    var ret = Future(() {
      var respFuture = this._doApiRequest("pairs");
      return respFuture.then((respBody) {
        var unpacked = convert.jsonDecode(respBody);
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

  /// Returns a Future that resolves to a list of exchanges from the cryptowatch REST API.
  Future<List<common.Exchange>> fetchExchanges() {
    var ret = Future(() {
      var respFuture = this._doApiRequest("exchanges");
      return respFuture.then((respBody) {
        var unpacked = convert.jsonDecode(respBody);
        if (unpacked is! Map) {
          throw unexpectedResponseFormat;
        }

        var unparsedExchangeList = unpacked["result"];
        if (unparsedExchangeList is! List) {
          throw unexpectedResponseFormat;
        }

        var exchangeList = new List<common.Exchange>();

        for (var unparsedExchange in unparsedExchangeList) {
          exchangeList.add(_parseExchange(unparsedExchange));
        }

        return exchangeList;
      });
    });

    return ret;
  }

  /// Returns a Future that resolves to a list of markets from the cryptowatch REST API.
  Future<List<common.Market>> fetchMarkets() {
    var ret = Future(() {
      var respFuture = this._doApiRequest("markets");
      return respFuture.then((respBody) {
        var unpacked = convert.jsonDecode(respBody);
        if (unpacked is! Map) {
          throw unexpectedResponseFormat;
        }

        var unparsedMarketList = unpacked["result"];
        if (unparsedMarketList is! List) {
          throw unexpectedResponseFormat;
        }

        var marketList = new List<common.Market>();

        for (var unparsedMarket in unparsedMarketList) {
          marketList.add(_parseMarket(unparsedMarket));
        }

        return marketList;
      });
    });

    return ret;
  }
}

common.Asset _parseAsset(Map<String, dynamic> props) {
  var id = props["id"];
  var name = props["name"];
  var symbol = props["symbol"];
  var fiat = props["fiat"];

  return new common.Asset(id, name, symbol, fiat);
}

common.Pair _parsePair(Map<String, dynamic> props) {
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

common.Exchange _parseExchange(Map<String, dynamic> props) {
  var id = props["id"];
  var name = props["name"];
  var symbol = props["symbol"];
  var active = props["active"];

  return new common.Exchange(id, name, symbol, active);
}

common.Market _parseMarket(Map<String, dynamic> props) {
  var id = props["id"];
  var exchange = props["exchange"];
  var pair = props["pair"];
  var active = props["active"];

  return new common.Market(id, exchange, pair, active);
}
