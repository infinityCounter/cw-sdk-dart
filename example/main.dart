library cmd;

// Just some simple examples on how the RestApiClient is expected to be used.

import 'dart:io' as io;

import 'package:cw_sdk_dart/cw_sdk_dart.dart' as sdk
    show RestApiClient, OrderBook;

main() {
  var apiClient = sdk.RestApiClient();
  var futures = List<Future>();

  futures.add(apiClient.fetchAssets());
  futures.add(apiClient.fetchPairs());
  futures.add(apiClient.fetchExchanges());
  futures.add(apiClient.fetchMarkets());
  futures.add(apiClient.fetchMarkets(exchange: "kraken"));
  futures.add(apiClient.fetchAsset("btc"));
  futures.add(apiClient.fetchPair("btcusd"));
  futures.add(apiClient.fetchPairVwap("btcusd"));
  futures.add(apiClient.fetchExchange("bitfinex"));
  futures.add(apiClient.fetchMarket("bitfinex", "btcusd"));
  futures.add(apiClient.fetchOrderBook("bitfinex", "btcusd"));
  futures.add(apiClient.fetchCandles(
    "bitfinex",
    "btcdomusdt-perpetual-futures",
    periods: ["60"],
    before: 1588850880,
    after: 1588810620,
  ));
  futures.add(apiClient.fetchSummary("bitfinex", "btcusd"));
  futures.add(apiClient.fetchMarketPrice("bitfinex", "btcusd"));
  futures.add(apiClient.fetchTrades(
    "bitfinex",
    "btcusd",
    since: 1588913266,
    limit: 3,
  ));

  Future.wait(futures).then((List<dynamic> results) {
    var assets = results[0];
    var pairs = results[1];
    var exchanges = results[2];
    var markets = results[3];
    var krakenMarkets = results[4];
    var btc = results[5];
    var btcusd = results[6];
    var btcusdVwap = results[7];
    var bitfinex = results[8];
    var bitfinexBtcUsd = results[9];
    var snapshot = results[10];
    var book = sdk.OrderBook.fromSnapshot(snapshot);
    var candles = results[11];
    var summary = results[12];
    var price = results[13];
    var trades = results[14];

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

    for (var m in krakenMarkets) {
      print(m);
    }

    print(btc);
    print(btcusd);
    print(btcusdVwap);
    print(bitfinex);
    print(bitfinexBtcUsd);
    print(snapshot);
    print(book.aggregatedSnapshot(10000));
    print(candles);
    print(summary);
    print(price);
    print(trades);

    io.exit(0);
  }, onError: (e) {
    print(e);
    io.exit(1);
  });
}
