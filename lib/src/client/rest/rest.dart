library rest;

import 'dart:convert' as convert show jsonDecode;

import 'package:http/http.dart' as http show Client, read;

import '../../common/common.dart' as common;

part 'helpers.dart';

// defaultApiDomain is the current (as of May 1, 2020) production domain for Cryptowatch's REST API.
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
        this._apiKey = apiKey {}

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

  /// Returns a Future that resolves to the asset on Cryptowatch REST API with the symbol [sym].
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

  /// Returns a Future that resolves to the pair on Cryptowatch REST API with the symbol [sym].
  Future<common.Pair> fetchPair(String sym) {
    var ret = Future(() {
      var respFuture = this._doApiRequest("pairs/${sym}");
      return respFuture.then((respBody) {
        var unpacked = convert.jsonDecode(respBody);
        if (unpacked is! Map) {
          throw unexpectedResponseFormat;
        }

        var unparsedPair = unpacked["result"];
        if (unparsedPair is! Map) {
          throw unexpectedResponseFormat;
        }

        return _parsePair(unparsedPair);
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

  /// Returns a Future that resolves to the exchange on Cryptowatch REST API with the symbol [sym].
  Future<common.Exchange> fetchExchange(String sym) {
    var ret = Future(() {
      var respFuture = this._doApiRequest("exchanges/${sym}");
      return respFuture.then((respBody) {
        var unpacked = convert.jsonDecode(respBody);
        if (unpacked is! Map) {
          throw unexpectedResponseFormat;
        }

        var unparsedExchange = unpacked["result"];
        if (unparsedExchange is! Map) {
          throw unexpectedResponseFormat;
        }

        return _parseExchange(unparsedExchange);
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

  /// Returns a Future that resolves to the market on Cryptowatch REST API for
  /// the exchange [exchangeSym] and pair [pairSym].
  Future<common.Market> fetchMarket(String exchangeSym, String pairSym) {
    var ret = Future(() {
      var respFuture = this._doApiRequest("markets/${exchangeSym}/${pairSym}");
      return respFuture.then((respBody) {
        var unpacked = convert.jsonDecode(respBody);
        if (unpacked is! Map) {
          throw unexpectedResponseFormat;
        }

        var unparsedMarket = unpacked["result"];
        if (unparsedMarket is! Map) {
          throw unexpectedResponseFormat;
        }

        return _parseMarket(unparsedMarket);
      });
    });

    return ret;
  }

  Future<common.OrderBookSnapshot> fetchOrderBookSnapshot(
      String exchangeSym, String pairSym) {
    var ret = Future(() {
      var respFuture =
          this._doApiRequest("markets/${exchangeSym}/${pairSym}/orderbook");
      return respFuture.then((respBody) {
        var unpacked = convert.jsonDecode(respBody);
        if (unpacked is! Map) {
          throw unexpectedResponseFormat;
        }

        var unparsedSnapshot = unpacked["result"];
        if (unparsedSnapshot is! Map) {
          throw unexpectedResponseFormat;
        }

        return _parseOrderBookSnapshot(unparsedSnapshot);
      });
    });

    return ret;
  }
}
