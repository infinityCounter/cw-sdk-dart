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

  Future<String> _doApiRequest(String path, [Map<String, String> params]) {
    var endpoint = Uri.https(this._apiDomain, path, params);

    if (this._apiKey is String && this._apiKey != "") {
      return http.read(endpoint, headers: {_apiKeyHeader: this._apiKey});
    }

    return http.read(endpoint);
  }

  /// Returns a Future that resolves to an iterable collection of all assets.
  Future<Iterable<common.Asset>> fetchAssets() {
    var ret = Future(() {
      var respFuture = this._doApiRequest("assets");
      return respFuture.then((respBody) {
        var unpacked = convert.jsonDecode(respBody);
        if (unpacked is! Map) {
          throw unexpectedResponseFormat;
        }

        var unparsedAssetList = unpacked["result"];
        if (unparsedAssetList is! Iterable) {
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

  /// Returns a Future that resolves to the asset with symbol [sym].
  Future<common.Asset> fetchAsset(String sym) {
    var ret = Future(() {
      var respFuture = this._doApiRequest("assets/${Uri.encodeComponent(sym)}");
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

  /// Returns a Future that resolves to an iterable collection of all asset pairs.
  Future<Iterable<common.Pair>> fetchPairs() {
    var ret = Future(() {
      var respFuture = this._doApiRequest("pairs");
      return respFuture.then((respBody) {
        var unpacked = convert.jsonDecode(respBody);
        if (unpacked is! Map) {
          throw unexpectedResponseFormat;
        }

        var unparsedPairList = unpacked["result"];
        if (unparsedPairList is! Iterable) {
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

  /// Returns a Future that resolves to the pair with symbol [sym].
  Future<common.Pair> fetchPair(String sym) {
    var ret = Future(() {
      var respFuture = this._doApiRequest("pairs/${Uri.encodeComponent(sym)}");
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

  /// Returns a Future that resolves to an iterable collection of all exchanges.
  Future<List<common.Exchange>> fetchExchanges() {
    var ret = Future(() {
      var respFuture = this._doApiRequest("exchanges");
      return respFuture.then((respBody) {
        var unpacked = convert.jsonDecode(respBody);
        if (unpacked is! Map) {
          throw unexpectedResponseFormat;
        }

        var unparsedExchangeList = unpacked["result"];
        if (unparsedExchangeList is! Iterable) {
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

  /// Returns a Future that resolves to the exchange with symbol [sym].
  Future<common.Exchange> fetchExchange(String sym) {
    var ret = Future(() {
      var respFuture =
          this._doApiRequest("exchanges/${Uri.encodeComponent(sym)}");
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

  /// Returns a Future that resolves to an iterable collection of all markets.
  ///
  /// If the [exchangeSym] argument is set, only markets for that exchange will be included
  /// in the response.
  Future<List<common.Market>> fetchMarkets([String exchangeSym]) {
    var ret = Future(() {
      var path = "markets";
      if (exchangeSym != null) {
        path += "/${Uri.encodeComponent(exchangeSym)}";
      }

      var respFuture = this._doApiRequest(path);
      return respFuture.then((respBody) {
        var unpacked = convert.jsonDecode(respBody);
        if (unpacked is! Map) {
          throw unexpectedResponseFormat;
        }

        var unparsedMarketList = unpacked["result"];
        if (unparsedMarketList is! Iterable) {
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

  /// Returns a Future that resolves to the market
  /// with exchange [exchangeSym] and pair [pairSym].
  Future<common.Market> fetchMarket(String exchangeSym, String pairSym) {
    var ret = Future(() {
      exchangeSym = Uri.encodeComponent(exchangeSym);
      pairSym = Uri.encodeComponent(pairSym);

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

  /// Returns a Future that resolves to the current order book snapshot
  /// for the market with exchange [exchangeSym] and pair [pairSym].
  Future<common.OrderBookSnapshot> fetchOrderBookSnapshot(
      String exchangeSym, String pairSym) {
    var ret = Future(() {
      exchangeSym = Uri.encodeComponent(exchangeSym);
      pairSym = Uri.encodeComponent(pairSym);

      var path = "markets/${exchangeSym}/${pairSym}/orderbook";
      var respFuture = this._doApiRequest(path);

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

  /// Returns a Future that resolves to a map of candles fetched for the
  /// market with exchange [exchangeSym] and pair [pairSym].
  ///
  /// The map is keyed by the interval period, e.g. "60", "300", "900".
  /// There are additional parameters that can be specified to only get a subset of
  /// candles: periods, before and after. Please see the Cryptowatch REST API
  /// documentation for their usage.
  Future<Map<String, Iterable<common.Candle>>> fetchCandles(
    String exchangeSym,
    String pairSym, {
    Iterable<String> periods,
    int before,
    int after,
  }) {
    var ret = Future(() {
      var params = new Map<String, String>();

      if (periods != null && periods.length > 0) {
        params["periods"] = periods.join(",");
      }

      if (before != null) {
        params["before"] = before.toString();
      }

      if (after != null) {
        params["after"] = after.toString();
      }

      exchangeSym = Uri.encodeComponent(exchangeSym);
      pairSym = Uri.encodeComponent(pairSym);

      var path = "markets/${exchangeSym}/${pairSym}/ohlc";
      var respFuture = this._doApiRequest(path, params);

      return respFuture.then((respBody) {
        var unpacked = convert.jsonDecode(respBody);
        if (unpacked is! Map) {
          throw unexpectedResponseFormat;
        }

        Map<String, dynamic> unparsedCandles = unpacked["result"];
        if (unparsedCandles is! Map) {
          throw unexpectedResponseFormat;
        }

        var periodCandles = new Map<String, Iterable<common.Candle>>();

        unparsedCandles.entries.forEach((entry) {
          periodCandles[entry.key] = _parseCandles(entry.value);
        });

        return periodCandles;
      });
    });

    return ret;
  }

  /// Returns a Future that resolves to the current summary for the market
  /// with exchange [exchangeSym] and pair [pairSym].
  Future<common.Summary> fetchSummary(String exchangeSym, String pairSym) {
    var ret = Future(() {
      exchangeSym = Uri.encodeComponent(exchangeSym);
      pairSym = Uri.encodeComponent(pairSym);

      var path = "markets/${exchangeSym}/${pairSym}/summary";
      var respFuture = this._doApiRequest(path);

      return respFuture.then((respBody) {
        var unpacked = convert.jsonDecode(respBody);
        if (unpacked is! Map) {
          throw unexpectedResponseFormat;
        }

        var unparsedSummary = unpacked["result"];
        if (unparsedSummary is! Map) {
          throw unexpectedResponseFormat;
        }

        return _parseSummary(unparsedSummary);
      });
    });

    return ret;
  }

  /// Returns a Future that resolves to the current price for the market
  /// with exchange [exchangeSym] and pair [pairSym].
  Future<num> fetchMarketPrice(String exchangeSym, String pairSym) {
    var ret = Future(() {
      exchangeSym = Uri.encodeComponent(exchangeSym);
      pairSym = Uri.encodeComponent(pairSym);

      var path = "markets/${exchangeSym}/${pairSym}/price";
      var respFuture = this._doApiRequest(path);

      return respFuture.then((respBody) {
        var unpacked = convert.jsonDecode(respBody);
        if (unpacked is! Map) {
          throw unexpectedResponseFormat;
        }

        var unparsedPrice = unpacked["result"];
        if (unparsedPrice is! Map) {
          throw unexpectedResponseFormat;
        }

        var price = unparsedPrice["price"];
        if (price == null || price is! num) {
          throw unexpectedResponseFormat;
        }

        num priceAsNum = price;
        return priceAsNum;
      });
    });

    return ret;
  }

  /// Returns a Future that resolves to an iterable collection of
  /// recent trades for the market with exchange [exchangeSym] and pair [pairSym].
  ///
  /// There are additional parameters that can be specified to query a
  /// specific set of trades: since, and limit. Please see the Cryptowatch REST API
  /// documentation for their usage.
  Future<Iterable<common.PublicTrade>> fetchTrades(
    String exchangeSym,
    String pairSym, {
    int since,
    int limit,
  }) {
    var ret = Future(() {
      var params = new Map<String, String>();

      if (since != null) {
        params["since"] = since.toString();
      }

      if (limit != null) {
        params["limit"] = limit.toString();
      }

      exchangeSym = Uri.encodeComponent(exchangeSym);
      pairSym = Uri.encodeComponent(pairSym);

      var path = "markets/${exchangeSym}/${pairSym}/trades";
      var respFuture = this._doApiRequest(path, params);

      return respFuture.then((respBody) {
        var unpacked = convert.jsonDecode(respBody);
        if (unpacked is! Map) {
          throw unexpectedResponseFormat;
        }

        var unparsedTrades = unpacked["result"];
        if (unparsedTrades is! Iterable) {
          throw unexpectedResponseFormat;
        }

        return _parsePublicTrades(unparsedTrades);
      });
    });

    return ret;
  }
}
