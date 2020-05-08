library cmd;

import 'dart:io' as io;

import 'package:cw_sdk_dart/cw_sdk_dart.dart' as sdk
    show RestApiClient, OrderBook;

main() {
  var apiClient = new sdk.RestApiClient();
  var futures = new List<Future>();

  futures.add(apiClient.fetchAssets());
  futures.add(apiClient.fetchPairs());
  futures.add(apiClient.fetchExchanges());
  futures.add(apiClient.fetchMarkets());
  futures.add(apiClient.fetchMarkets("kraken"));
  futures.add(apiClient.fetchAsset("btc"));
  futures.add(apiClient.fetchPair("btcusd"));
  futures.add(apiClient.fetchExchange("bitfinex"));
  futures.add(apiClient.fetchMarket("bitfinex", "btcusd"));
  futures.add(apiClient.fetchOrderBookSnapshot("bitfinex", "btcusd"));
  futures.add(apiClient.fetchCandles(
    "bitfinex",
    "btcdomusdt-perpetual-futures",
    periods: ["60"],
    before: 1588850880,
    after: 1588810620,
  ));
  futures.add(apiClient.fetchSummary("bitfinex", "btcusd"));
  futures.add(apiClient.fetchMarketPrice("bitfinex", "btcusd"));

  Future.wait(futures).then((List<dynamic> results) {
    var assets = results[0];
    var pairs = results[1];
    var exchanges = results[2];
    var markets = results[3];
    var krakenMarkets = results[4];
    var btc = results[5];
    var btcusd = results[6];
    var bitfinex = results[7];
    var bitfinexBtcUsd = results[8];
    var snapshot = results[9];
    var book = new sdk.OrderBook.fromSnapshot(snapshot);
    var candles = results[10];
    var summary = results[11];
    var price = results[12];

    // for (var a in assets) {
    //   print(a);
    // }

    // for (var p in pairs) {
    //   print(p);
    // }

    // for (var e in exchanges) {
    //   print(e);
    // }

    // for (var m in markets) {
    //   print(m);
    // }

    // for (var m in krakenMarkets) {
    //   print(m);
    // }

    // print(btc);
    // print(btcusd);
    // print(bitfinex);
    // print(bitfinexBtcUsd);
    // print(snapshot);
    // print(book.aggregatedSnapshot(10000));
    // print(candles);
    // print(summary);
    // print(price);

    io.exit(0);
  }, onError: (e) {
    print(e);
    io.exit(1);
  });
}
