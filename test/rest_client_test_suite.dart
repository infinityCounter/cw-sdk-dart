part of cw_sdk_dart_test;

const _testApiDomain = "test-api.cryptowat.ch";
const _testApiKey = "827e9876-2e28-403b-b277-9f17d892337c";

class restApiClientTestCase {
  String descr = "";

  String setDomain;
  String setApiKey;

  List posArgs;
  Map<String, dynamic> namedArgs;

  String wantPath = "";
  Map<String, String> wantParams;
  Map<String, String> wantHeaders = {};

  String methodName;

  int respStatusCode;
  String respJson = "";

  var wantRes;
  var wantException;
}

class restApiClientTestGroup {
  String testGroupName;

  List<restApiClientTestCase> cases = [];
}

class restApiClientTestSuite {
  static runTests() {
    var testFuncIMs = _getAllTestFuncInstanceMirrors();

    for (var tf in testFuncIMs) {
      tf.reflectee();
    }
  }

  static void _test_statusCodeExceptions() {
    var bitfinex = sdk.Exchange()
      ..id = 1
      ..name = "Bitfinex"
      ..symbol = "bitfinex"
      ..active = true;

    var testGroup = restApiClientTestGroup()
      ..testGroupName = "Test throwing exceptions for status codes"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching Exchange, 200" // {{{
          ..methodName = "fetchExchange"
          ..posArgs = ["bitfinex"]
          ..wantPath = "/exchanges/bitfinex"
          ..respJson = '''
          {
            "result": {
              "id":1,
              "symbol":"bitfinex",
              "name":"Bitfinex",
              "active":true
            }
          }
          '''
          ..respStatusCode = 200
          ..wantRes = bitfinex,
        // }}}
        restApiClientTestCase()
          ..descr = "Fetching Exchange, 429" // {{{
          ..methodName = "fetchExchange"
          ..posArgs = ["bitfinex"]
          ..wantPath = "/exchanges/bitfinex"
          ..respStatusCode = 429
          ..wantException = sdk.RateLimitException,
        // }}}
        restApiClientTestCase()
          ..descr = "Fetching Exchange, 500" // {{{
          ..methodName = "fetchExchange"
          ..posArgs = ["bitfinex"]
          ..wantPath = "/exchanges/bitfinex"
          ..respStatusCode = 500
          ..wantException = sdk.RestServerException,
        // }}}
        restApiClientTestCase()
          ..descr = "Fetching Exchange with API Key, 503" // {{{
          ..methodName = "fetchExchange"
          ..posArgs = ["bitfinex"]
          ..wantPath = "/exchanges/bitfinex"
          ..respStatusCode = 503
          ..wantException = sdk.RestServerException,
        // }}}
        restApiClientTestCase()
          ..descr = "Fetching Assets, 503" // {{{
          ..methodName = "fetchAssets"
          ..wantPath = "/assets"
          ..respStatusCode = 503
          ..wantException = sdk.RestServerException,
        // }}}
      ];

    _runRestApiClientTestSet(testGroup);
  }

  static void _test_fetchAssets() {
    var btc = sdk.Asset()
      ..id = 60
      ..symbol = "btc"
      ..name = "Bitcoin"
      ..fiat = false;

    var eth = sdk.Asset()
      ..id = 77
      ..symbol = "eth"
      ..name = "Ethereum"
      ..fiat = false;

    var usd = sdk.Asset()
      ..id = 98
      ..symbol = "usd"
      ..name = "United States Dollar"
      ..fiat = true;

    var testGroup = restApiClientTestGroup()
      ..testGroupName = "Test fetchAssets"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching assets" // {{{
          ..methodName = "fetchAssets"
          ..wantPath = "/assets"
          ..respJson = '''
          {
            "result": [{
              "id":60,
              "symbol":"btc",
              "name":"Bitcoin",
              "fiat":false
            },{
              "id":77,
              "symbol":"eth",
              "name":"Ethereum",
              "fiat":false
            },{
              "id":98,
              "symbol":"usd",
              "name":"United States Dollar",
              "fiat":true
            }]
          }
          '''
          ..wantRes = [btc, eth, usd],
        // }}}
        restApiClientTestCase()
          ..descr = "Empty list of results" // {{{
          ..methodName = "fetchAssets"
          ..wantPath = "/assets"
          ..respJson = '{"result": []}'
          ..wantRes = <sdk.Asset>[],
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (asset symbol is null)" // {{{
          ..methodName = "fetchAssets"
          ..wantPath = "/assets"
          ..respJson = '''
          {
            "result": [{
              "id":60,
              "symbol":null,
              "name":"Bitcoin",
              "fiat":false
            }]
          }
          '''
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected String field symbol, instead got Null(null)",
          ),
        // }}}
      ];

    _runRestApiClientTestSet(testGroup);
  }

  static void _test_fetchAsset() {
    var btc = sdk.Asset()
      ..id = 60
      ..symbol = "btc"
      ..name = "Bitcoin"
      ..fiat = false;

    var testGroup = restApiClientTestGroup()
      ..testGroupName = "Test fetchAsset"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching Asset, Ok" // {{{
          ..methodName = "fetchAsset"
          ..posArgs = ["btc"]
          ..wantPath = "/assets/btc"
          ..respJson = '''
          {
            "result": {
              "id":60,
              "symbol":"btc",
              "name":"Bitcoin",
              "fiat":false
            }
          }
          '''
          ..wantRes = btc,
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed asset (id is NaN)" // {{{
          ..methodName = "fetchAsset"
          ..posArgs = ["btc"]
          ..setApiKey = _testApiKey
          ..wantPath = "/assets/btc"
          ..wantHeaders = {"X-CW-API-Key": _testApiKey}
          ..respJson = '''
          {
            "result": {
              "id":"NaN",
              "symbol":"btc",
              "name":"Bitcoin",
              "fiat":false
            }
          }
          '''
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected int field id, instead got String(NaN)",
          ),
        // }}}
        restApiClientTestCase()
          ..descr = "Asset not found" // {{{
          ..methodName = "fetchAsset"
          ..posArgs = ["btc"]
          ..setApiKey = _testApiKey
          ..wantPath = "/assets/btc"
          ..wantHeaders = {"X-CW-API-Key": _testApiKey}
          ..respJson = '{"error": "Asset not found"}'
          ..respStatusCode = 404
          ..wantRes = null,
        // }}}
      ];

    _runRestApiClientTestSet(testGroup);
  }

  static void _test_fetchPairs() {
    var btc = sdk.Asset()
      ..id = 60
      ..symbol = "btc"
      ..name = "Bitcoin"
      ..fiat = false;

    var eth = sdk.Asset()
      ..id = 77
      ..symbol = "eth"
      ..name = "Ethereum"
      ..fiat = false;

    var usd = sdk.Asset()
      ..id = 98
      ..symbol = "usd"
      ..name = "United States Dollar"
      ..fiat = true;

    var btcusd = sdk.Pair()
      ..id = 9
      ..symbol = "btcusd"
      ..base = btc
      ..quote = usd;

    var ethusd = sdk.Pair()
      ..id = 125
      ..symbol = "ethusd"
      ..base = eth
      ..quote = usd;

    var btcusdPerpFuture = sdk.Pair()
      ..id = 175
      ..symbol = "btcusd-perpetual-futures"
      ..base = btc
      ..quote = usd
      ..futuresContractPeriod = "perpetual";

    var testGroup = restApiClientTestGroup()
      ..testGroupName = "Test fetchPairs"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching pairs, Ok" // {{{
          ..methodName = "fetchPairs"
          ..wantPath = "/pairs"
          ..respJson = '''
          {
            "result": [{
              "id": 9,
              "symbol": "btcusd",
              "base": {
                "id": 60,
                "symbol": "btc",
                "name": "Bitcoin",
                "fiat": false
              },
              "quote": {
                "id": 98,
                "symbol": "usd",
                "name": "United States Dollar",
                "fiat": true
              }
            },{
              "id": 125,
              "symbol": "ethusd",
              "base": {
                "id": 77,
                "symbol": "eth",
                "name": "Ethereum",
                "fiat": false
              },
              "quote": {
                "id": 98,
                "symbol": "usd",
                "name": "United States Dollar",
                "fiat": true
              }
            },{
              "id": 175,
              "symbol": "btcusd-perpetual-futures",
              "base": {
                "id": 60,
                "symbol": "btc",
                "name": "Bitcoin",
                "fiat": false
              },
              "quote": {
                "id": 98,
                "symbol": "usd",
                "name": "United States Dollar",
                "fiat": true
              },
              "futuresContractPeriod": "perpetual"
            }]
          }
          '''
          ..wantRes = [btcusd, ethusd, btcusdPerpFuture],
        // }}}
        restApiClientTestCase()
          ..descr = "Empty list of results" // {{{
          ..methodName = "fetchPairs"
          ..wantPath = "/pairs"
          ..respJson = '{"result": []}'
          ..wantRes = <sdk.Pair>[],
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (should be list but is map)" // {{{
          ..methodName = "fetchPairs"
          ..wantPath = "/pairs"

          // FetchPairs is expecting an array, not an object
          ..respJson = '''
          {
            "result": {
              "id":60,
              "symbol":"btc",
              "name":"Bitcoin",
              "fiat":false
            }
          }
          '''
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected Iterable field result, instead got _InternalLinkedHashMap<String, dynamic>({id: 60, symbol: btc, name: Bitcoin, fiat: false})",
          )
        // }}}
      ];

    _runRestApiClientTestSet(testGroup);
  }

  static void _test_fetchPair() {
    var btc = sdk.Asset()
      ..id = 60
      ..symbol = "btc"
      ..name = "Bitcoin"
      ..fiat = false;

    var usd = sdk.Asset()
      ..id = 98
      ..symbol = "usd"
      ..name = "United States Dollar"
      ..fiat = true;

    var btcusd = sdk.Pair()
      ..id = 9
      ..symbol = "btcusd"
      ..base = btc
      ..quote = usd;

    var btcusdPerpFuture = sdk.Pair()
      ..id = 175
      ..symbol = "btcusd-perpetual-futures"
      ..base = btc
      ..quote = usd
      ..futuresContractPeriod = "perpetual";

    var testGroup = restApiClientTestGroup()
      ..testGroupName = "Test fetchPair"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching spot pair, Ok" // {{{
          ..methodName = "fetchPair"
          ..posArgs = ["btcusd"]
          ..wantPath = "/pairs/btcusd"
          ..respJson = '''
          {
            "result": {
              "id": 9,
              "symbol": "btcusd",
              "base": {
                "id": 60,
                "symbol": "btc",
                "name": "Bitcoin",
                "fiat": false
              },
              "quote": {
                "id": 98,
                "symbol": "usd",
                "name": "United States Dollar",
                "fiat": true
              }
            }
          }
          '''
          ..wantRes = btcusd,
        // }}}
        restApiClientTestCase()
          ..descr = "Fetching futures pair, Ok" // {{{
          ..methodName = "fetchPair"
          ..posArgs = ["btcusd-perpetual-futures"]
          ..wantPath = "/pairs/btcusd-perpetual-futures"
          ..respJson = '''
          {
            "result": {
              "id": 175,
              "symbol": "btcusd-perpetual-futures",
              "base": {
                "id": 60,
                "symbol": "btc",
                "name": "Bitcoin",
                "fiat": false
              },
              "quote": {
                "id": 98,
                "symbol": "usd",
                "name": "United States Dollar",
                "fiat": true
              },
              "futuresContractPeriod": "perpetual"
            }
          }
          '''
          ..wantRes = btcusdPerpFuture,
        // }}}
        restApiClientTestCase()
          ..descr = "Pair not found" // {{{
          ..methodName = "fetchPair"
          ..posArgs = ["fooBarBaz"]
          ..wantPath = "/pairs/fooBarBaz"
          ..respJson = '{"error": "Pair not found"}'
          ..respStatusCode = 404
          ..wantRes = null,
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (id is not set)" // {{{
          ..methodName = "fetchPair"
          ..posArgs = ["btcusd"]
          ..wantPath = "/pairs/btcusd"
          ..respJson = '''
          {
            "result": {
              "symbol": "btcusd",
              "base": {
                "id": 60,
                "symbol": "btc",
                "name": "Bitcoin",
                "fiat": false
              },
              "quote": {
                "id": 98,
                "symbol": "usd",
                "name": "United States Dollar",
                "fiat": true
              }
            }
          }
          '''
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected int field id, instead got Null(null)",
          ),
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (symbol should be string)" // {{{
          ..methodName = "fetchPair"
          ..posArgs = ["btcusd"]
          ..wantPath = "/pairs/btcusd"
          ..respJson = '''
          {
            "result": {
              "id": 9,
              "symbol": 42,
              "base": {
                "id": 60,
                "symbol": "btc",
                "name": "Bitcoin",
                "fiat": false
              },
              "quote": {
                "id": 98,
                "symbol": "usd",
                "name": "United States Dollar",
                "fiat": true
              }
            }
          }
          '''
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected String field symbol, instead got int(42)",
          )
        // }}}
      ];

    _runRestApiClientTestSet(testGroup);
  }

  static void _test_fetchPairVwap() {
    var testGroup = restApiClientTestGroup()
      ..testGroupName = "Test fetchPairVwap"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching vwap, Ok" // {{{
          ..methodName = "fetchPairVwap"
          ..posArgs = ["btcusd"]
          ..wantPath = "/pairs/btcusd/vwap"
          ..respJson = '{"result": {"vwap": 9200}}'
          ..wantRes = 9200,
        // }}}
        restApiClientTestCase()
          ..descr = "Pair not found" // {{{
          ..methodName = "fetchPairVwap"
          ..posArgs = ["btcusd"]
          ..wantPath = "/pairs/btcusd/vwap"
          ..respJson = '{"error": "Pair not found"}'
          ..respStatusCode = 404
          ..wantRes = null,
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (vwap is NaN)" // {{{
          ..methodName = "fetchPairVwap"
          ..posArgs = ["btcusd"]
          ..wantPath = "/pairs/btcusd/vwap"
          ..respJson = '{"result": {"vwap": "NaN"}}'
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected num field vwap, instead got String(NaN)",
          ),
        // }}}
      ];

    _runRestApiClientTestSet(testGroup);
  }

  static void _test_fetchExchanges() {
    var bitfinex = sdk.Exchange()
      ..id = 1
      ..name = "Bitfinex"
      ..symbol = "bitfinex"
      ..active = true;

    var kraken = sdk.Exchange()
      ..id = 4
      ..name = "Kraken"
      ..symbol = "kraken"
      ..active = true;

    var quadriga = sdk.Exchange()
      ..id = 26
      ..name = "QuadrigaCX"
      ..symbol = "quadriga"
      ..active = false;

    var testGroup = restApiClientTestGroup()
      ..testGroupName = "Test fetchExchanges"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching exchanges, Ok" // {{{
          ..methodName = "fetchExchanges"
          ..wantPath = "/exchanges"
          ..respJson = '''
          {
            "result": [{
              "id": 1,
              "symbol": "bitfinex",
              "name": "Bitfinex",
              "active": true
            },{
              "id": 4,
              "symbol": "kraken",
              "name": "Kraken",
              "active": true
            },{
              "id": 26,
              "symbol": "quadriga",
              "name": "QuadrigaCX",
              "active": false
            }]
          }
          '''
          ..wantRes = [bitfinex, kraken, quadriga],
        // }}}
        restApiClientTestCase()
          ..descr = "Empty list of results" // {{{
          ..methodName = "fetchExchanges"
          ..wantPath = "/exchanges"
          ..respJson = '{"result": []}'
          ..wantRes = <sdk.Exchange>[],
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (active field is int)" // {{{
          ..methodName = "fetchExchanges"
          ..wantPath = "/exchanges"
          ..respJson = '''
          {
            "result": [{
              "id": 1,
              "symbol": "bitfinex",
              "name": "Bitfinex",
              "active": 42
            }]
          }
          '''
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected bool field active, instead got int(42)",
          )
        // }}}
      ];

    _runRestApiClientTestSet(testGroup);
  }

  static void _test_fetchExchange() {
    var bitfinex = sdk.Exchange()
      ..id = 1
      ..name = "Bitfinex"
      ..symbol = "bitfinex"
      ..active = true;

    var testGroup = restApiClientTestGroup()
      ..testGroupName = "Test fetchExchanges"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching exchange, Ok" // {{{
          ..methodName = "fetchExchange"
          ..posArgs = ["bitfinex"]
          ..wantPath = "/exchanges/bitfinex"
          ..respJson = '''
          {
            "result": {
              "id": 1,
              "symbol": "bitfinex",
              "name": "Bitfinex",
              "active": true
            }
          }
          '''
          ..wantRes = bitfinex,
        // }}}
        restApiClientTestCase()
          ..descr = "Exchange not found" // {{{
          ..methodName = "fetchExchange"
          ..posArgs = ["bitfinex"]
          ..wantPath = "/exchanges/bitfinex"
          ..respJson = '{"error": "Exchange not found"}'
          ..respStatusCode = 404
          ..wantRes = null,
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (active field is int)" // {{{
          ..methodName = "fetchExchange"
          ..posArgs = ["bitfinex"]
          ..wantPath = "/exchanges/bitfinex"
          ..respJson = '''
          {
            "result": {
              "id": 1,
              "symbol": "bitfinex",
              "name": "Bitfinex",
              "active": 42
            }
          }
          '''
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected bool field active, instead got int(42)",
          )
        // }}}
      ];

    _runRestApiClientTestSet(testGroup);
  }

  static void _test_fetchMarkets() {
    var bitfinexBtcUsd = sdk.Market()
      ..id = 1
      ..exchange = "bitfinex"
      ..pair = "btcusd"
      ..active = true;

    var krakenEthUsd = sdk.Market()
      ..id = 96
      ..exchange = "kraken"
      ..pair = "ethusd"
      ..active = true;

    var bitmexXtzFuture = sdk.Market()
      ..id = 244
      ..exchange = "bitmex"
      ..pair = "xtzbtc-quarterly-futures"
      ..active = false;

    var testGroup = restApiClientTestGroup()
      ..testGroupName = "Test fetchMarkets"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching markets, Ok" // {{{
          ..methodName = "fetchMarkets"
          ..wantPath = "/markets"
          ..respJson = '''
          {
            "result": [{
              "id": 1,
              "exchange": "bitfinex",
              "pair": "btcusd",
              "active": true
            },{
              "id": 96,
              "exchange": "kraken",
              "pair": "ethusd",
              "active": true
            },{
              "id": 244,
              "exchange": "bitmex",
              "pair": "xtzbtc-quarterly-futures",
              "active": false
            }]
          }
          '''
          ..wantRes = [bitfinexBtcUsd, krakenEthUsd, bitmexXtzFuture],
        // }}}
        restApiClientTestCase()
          ..descr = "Empty list of results" // {{{
          ..methodName = "fetchMarkets"
          ..wantPath = "/markets"
          ..respJson = '{"result": []}'
          ..wantRes = <sdk.Market>[],
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (result is not Iterable)" // {{{
          ..methodName = "fetchMarkets"
          ..wantPath = "/markets"
          ..respJson = '{"result": "fooBar"}'
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected Iterable field result, instead got String(fooBar)",
          ),
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (exchange is int)" // {{{
          ..methodName = "fetchMarkets"
          ..wantPath = "/markets"
          ..respJson = '''
          {
            "result": [{
              "id": 1,
              "exchange": 42,
              "pair": "btcusd",
              "active": true
            }]
          }
          '''
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected String field exchange, instead got int(42)",
          ),
        // }}}
        restApiClientTestCase()
          ..descr = "Use exchange filter" // {{{
          ..methodName = "fetchMarkets"
          ..namedArgs = {"exchange": "kraken"}
          ..wantPath = "/markets/kraken"
          ..respJson = '''
          {
            "result": [{
              "id": 96,
              "exchange": "kraken",
              "pair": "ethusd",
              "active": true
            }]
          }
          '''
          ..wantRes = [krakenEthUsd],
        // }}}
      ];

    _runRestApiClientTestSet(testGroup);
  }

  static void _test_fetchMarket() {
    var bitfinexBtcUsd = sdk.Market()
      ..id = 1
      ..exchange = "bitfinex"
      ..pair = "btcusd"
      ..active = true;

    var testGroup = restApiClientTestGroup()
      ..testGroupName = "Test fetchMarket"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching market, Ok" // {{{
          ..methodName = "fetchMarket"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd"
          ..respJson = '''
          {
            "result": {
              "id": 1,
              "exchange": "bitfinex",
              "pair": "btcusd",
              "active": true
            }
          }
          '''
          ..wantRes = bitfinexBtcUsd,
        // }}}
        restApiClientTestCase()
          ..descr = "Exchange for market not found" // {{{
          ..methodName = "fetchMarket"
          ..posArgs = ["foo", "btcusd"]
          ..wantPath = "/markets/foo/btcusd"
          ..respJson = '{"error": "Exchange not found"}'
          ..respStatusCode = 404
          ..wantRes = null,
        // }}}
        restApiClientTestCase()
          ..descr = "Pair for market not found" // {{{
          ..methodName = "fetchMarket"
          ..posArgs = ["bitfinex", "barbaz"]
          ..wantPath = "/markets/bitfinex/barbaz"
          ..respJson = '{"error": "Instrument not found"}'
          ..respStatusCode = 404
          ..wantRes = null,
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (result is not Map)" // {{{
          ..methodName = "fetchMarket"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd"
          ..respJson = '{"result": []}'
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected Map<String, dynamic> field result, instead got List<dynamic>([])",
          ),
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (exchange is int)" // {{{
          ..methodName = "fetchMarket"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd"
          ..respJson = '''
          {
            "result": {
              "id": 1,
              "exchange": 42,
              "pair": "btcusd",
              "active": true
            }
          }
          '''
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected String field exchange, instead got int(42)",
          )
        // }}}
      ];

    _runRestApiClientTestSet(testGroup);
  }

  static void _test_fetchOrderBook() {
    var ask1 = sdk.PublicOrder()
      ..price = 9100
      ..amount = 0.1;

    var ask2 = sdk.PublicOrder()
      ..price = 9105
      ..amount = 0.2;

    var ask3 = sdk.PublicOrder()
      ..price = 9110
      ..amount = 1;

    var bid1 = sdk.PublicOrder()
      ..price = 9095
      ..amount = 1;

    var bid2 = sdk.PublicOrder()
      ..price = 9090
      ..amount = 0.2;

    var bid3 = sdk.PublicOrder()
      ..price = 9085
      ..amount = 0.1;

    var testGroup = restApiClientTestGroup()
      ..testGroupName = "Test fetchOrderBook"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching order book, Ok" // {{{
          ..methodName = "fetchOrderBook"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd/orderbook"
          ..respJson = '''
          {
            "result": {
              "asks":[
                [9100, 0.1],
                [9105, 0.2],
                [9110, 1]
              ],
              "bids":[
                [9095, 1],
                [9090, 0.2],
                [9085, 0.1]
              ],
              "seqNum": 20
            }
          }
          '''
          ..wantRes = sdk.OrderBook(
            [ask1, ask2, ask3],
            [bid1, bid2, bid3],
            20,
          ),
        // }}}
        restApiClientTestCase()
          ..descr = "Exchange for market not found" // {{{
          ..methodName = "fetchOrderBook"
          ..posArgs = ["foo", "btcusd"]
          ..wantPath = "/markets/foo/btcusd/orderbook"
          ..respJson = '{"error": "Exchange not found"}'
          ..respStatusCode = 404
          ..wantRes = null,
        // }}}
        restApiClientTestCase()
          ..descr = "Pair for market not found" // {{{
          ..methodName = "fetchOrderBook"
          ..posArgs = ["bitfinex", "barbaz"]
          ..wantPath = "/markets/bitfinex/barbaz/orderbook"
          ..respJson = '{"error": "Instrument not found"}'
          ..respStatusCode = 404
          ..wantRes = null,
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (result is not Map)" // {{{
          ..methodName = "fetchOrderBook"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd/orderbook"
          ..respJson = '{"result": []}'
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected Map<String, dynamic> field result, instead got List<dynamic>([])",
          ),
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (ask price is NaN)" // {{{
          ..methodName = "fetchOrderBook"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd/orderbook"
          ..respJson = '''
          {
            "result": {
              "asks":[
                ["NaN", 0.1],
                [9105, 0.2],
                [9110, 1]
              ],
              "bids":[
                [9095, 1],
                [9090, 0.2],
                [9085, 0.1]
              ],
              "seqNum": 20
            }
          }
          '''
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected element 0 of array to be of type num, instead got String(NaN)",
          ),
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (bid amount is NaN)" // {{{
          ..methodName = "fetchOrderBook"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd/orderbook"
          ..respJson = '''
          {
            "result": {
              "asks":[
                [9100, 0.1],
                [9105, 0.2],
                [9110, 1]
              ],
              "bids":[
                [9095, 1],
                [9090, "NaN"],
                [9085, 0.1]
              ],
              "seqNum": 20
            }
          }
          '''
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected element 1 of array to be of type num, instead got String(NaN)",
          ),
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (seqNum is double)" // {{{
          ..methodName = "fetchOrderBook"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd/orderbook"
          ..respJson = '''
          {
            "result": {
              "asks":[
                [9100, 0.1],
                [9105, 0.2],
                [9110, 1]
              ],
              "bids":[
                [9095, 1],
                [9090, 0.2],
                [9085, 0.1]
              ],
              "seqNum": 1.3
            }
          }
          '''
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected int field seqNum, instead got double(1.3)",
          )
        // }}}
      ];

    _runRestApiClientTestSet(testGroup);
  }

  static void _test_fetchCandles() {
    var candles = {
      "60": [
        sdk.Candle()
          ..timestamp = 1589627580
          ..open = 9400
          ..high = 9450
          ..low = 9400
          ..close = 9440
          ..volumeBase = 0.1
          ..volumeQuote = 943,
        sdk.Candle()
          ..timestamp = 1589627640
          ..open = 9440
          ..high = 9440
          ..low = 9420
          ..close = 9420
          ..volumeBase = 0.2
          ..volumeQuote = 1800,
        sdk.Candle()
          ..timestamp = 1589627700
          ..open = 9420
          ..high = 9480
          ..low = 9410
          ..close = 9450
          ..volumeBase = 0.15
          ..volumeQuote = 1250,
      ],
      "180": [
        sdk.Candle()
          ..timestamp = 1589507820
          ..open = 9350
          ..high = 9390
          ..low = 9340
          ..close = 9370
          ..volumeBase = 1
          ..volumeQuote = 9350,
        sdk.Candle()
          ..timestamp = 1589628000
          ..open = 9370
          ..high = 9400
          ..low = 9360
          ..close = 9370
          ..volumeBase = 0.2
          ..volumeQuote = 1800,
        sdk.Candle()
          ..timestamp = 1589628180
          ..open = 9370
          ..high = 9370
          ..low = 9310
          ..close = 9310
          ..volumeBase = 0.5
          ..volumeQuote = 4670,
      ],
      "300": [
        sdk.Candle()
          ..timestamp = 1589388000
          ..open = 9400
          ..high = 9480
          ..low = 9250
          ..close = 9280
          ..volumeBase = 2.5
          ..volumeQuote = 24500,
        sdk.Candle()
          ..timestamp = 1589388300
          ..open = 9280
          ..high = 9280
          ..low = 9250
          ..close = 9250
          ..volumeBase = 1.8
          ..volumeQuote = 18000,
        sdk.Candle()
          ..timestamp = 1589388600
          ..open = 9250
          ..high = 9350
          ..low = 9250
          ..close = 9300
          ..volumeBase = 0.4
          ..volumeQuote = 3760,
      ],
    };
    var testGroup = restApiClientTestGroup()
      ..testGroupName = "Test fetchCandles"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching candles, Ok" // {{{
          ..methodName = "fetchCandles"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd/ohlc"
          ..respJson = '''
          {
            "result": {
              "60": [
                [1589627580,9400,9450,9400,9440,0.1,943],
                [1589627640,9440,9440,9420,9420,0.2,1800],
                [1589627700,9420,9480,9410,9450,0.15,1250]
              ],
              "180": [
                [1589507820,9350,9390,9340,9370,1,9350],
                [1589628000,9370,9400,9360,9370,0.2,1800],
                [1589628180,9370,9370,9310,9310,0.5,4670]
              ],
              "300": [
                [1589388000,9400,9480,9250,9280,2.5,24500],
                [1589388300,9280,9280,9250,9250,1.8,18000],
                [1589388600,9250,9350,9250,9300,0.4,3760]
              ]
            }
          }
          '''
          ..wantRes = candles,
        // }}}
        restApiClientTestCase()
          ..descr = "Use Filter Params" // {{{
          ..methodName = "fetchCandles"
          ..posArgs = ["bitfinex", "btcusd"]
          ..namedArgs = {
            "periods": ["180,300"],
            "before": 1589388100,
            "after": 1589628150,
          }
          ..wantPath = "/markets/bitfinex/btcusd/ohlc"
          ..wantParams = {
            "periods": "180,300",
            "before": "1589388100",
            "after": "1589628150",
          }
          ..respJson = '''
          {
            "result": {
              "180": [
                [1589628180,9370,9370,9310,9310,0.5,4670]
              ],
              "300": [
                [1589388000,9400,9480,9250,9280,2.5,24500]
              ]
            }
          }
          '''
          ..wantRes = {
            "180": [candles["180"][2]],
            "300": [candles["300"][0]],
          },
        // }}}
        restApiClientTestCase()
          ..descr = "Exchange for market not found" // {{{
          ..methodName = "fetchCandles"
          ..posArgs = ["foo", "btcusd"]
          ..wantPath = "/markets/foo/btcusd/ohlc"
          ..respJson = '{"error": "Exchange not found"}'
          ..respStatusCode = 404
          ..wantRes = null,
        // }}}
        restApiClientTestCase()
          ..descr = "Pair for market not found" // {{{
          ..methodName = "fetchCandles"
          ..posArgs = ["bitfinex", "barbaz"]
          ..wantPath = "/markets/bitfinex/barbaz/ohlc"
          ..respJson = '{"error": "Instrument not found"}'
          ..respStatusCode = 404
          ..wantRes = null,
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (result is not Map)" // {{{
          ..methodName = "fetchCandles"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd/ohlc"
          ..respJson = '{"result": []}'
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected Map<String, dynamic> field result, instead got List<dynamic>([])",
          ),
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (timestamp is NaN)" // {{{
          ..methodName = "fetchCandles"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd/ohlc"
          ..respJson = '''
          {
            "result": {
              "180": [
                ["NaN",9370,9370,9310,9310,0.5,4670]
              ]
            }
          }
          '''
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected element 0 of array to be of type int, instead got String(NaN)",
          ),
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (candle is not an array)" // {{{
          ..methodName = "fetchCandles"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd/ohlc"
          ..respJson = '''
          {
            "result": {
              "180": [
                {
                  "timestamp": 1589388000,
                  "open": 9370,
                  "high": 9370,
                  "low": 9310,
                  "close": 9310,
                  "volumeBase": 0.5,
                  "volumeQuote": 4670
                }
              ]
            }
          }
          '''
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected element 0 of array to be of type Iterable, instead got _InternalLinkedHashMap<String, dynamic>({timestamp: 1589388000, open: 9370, high: 9370, low: 9310, close: 9310, volumeBase: 0.5, volumeQuote: 4670})",
          ),
        // }}}
        // }}}
      ];

    _runRestApiClientTestSet(testGroup);
  }

  static void _test_fetchSummary() {
    var summary = sdk.Summary()
      ..last = 9500.60
      ..high = 9600.7
      ..low = 9200.5
      ..changeAbsolute = -48.29
      ..changePercentage = -0.005
      ..volumeBase = 3980.669
      ..volumeQuote = 37500000;

    var testGroup = restApiClientTestGroup()
      ..testGroupName = "Test fetchSummary"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching summary, Ok" // {{{
          ..methodName = "fetchSummary"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd/summary"
          ..respJson = '''
          {
            "result": {
              "price": {
                "last": 9500.60,
                "high": 9600.7,
                "low": 9200.5,
                "change": {
                  "percentage": -0.005,
                  "absolute": -48.29
                }
              },
              "volume": 3980.669,
              "volumeQuote": 37500000
            }
          }
          '''
          ..wantRes = summary,
        // }}}
        restApiClientTestCase()
          ..descr = "Exchange for market not found" // {{{
          ..methodName = "fetchSummary"
          ..posArgs = ["foo", "btcusd"]
          ..wantPath = "/markets/foo/btcusd/summary"
          ..respJson = '{"error": "Exchange not found"}'
          ..respStatusCode = 404
          ..wantRes = null,
        // }}}
        restApiClientTestCase()
          ..descr = "Pair for market not found" // {{{
          ..methodName = "fetchSummary"
          ..posArgs = ["bitfinex", "barbaz"]
          ..wantPath = "/markets/bitfinex/barbaz/summary"
          ..respJson = '{"error": "Instrument not found"}'
          ..respStatusCode = 404
          ..wantRes = null,
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (result is not Map)" // {{{
          ..methodName = "fetchSummary"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd/summary"
          ..respJson = '{"result": []}'
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected Map<String, dynamic> field result, instead got List<dynamic>([])",
          ),
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (last price is NaN)" // {{{
          ..methodName = "fetchSummary"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd/summary"
          ..respJson = '''
          {
            "result": {
              "price": {
                "last": "NaN",
                "high": 9600.7,
                "low": 9200.5,
                "change": {
                  "percentage": -0.005,
                  "absolute": -48.29
                }
              },
              "volume": 3980.669,
              "volumeQuote": 37500000
            }
          }
          '''
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected num field last, instead got String(NaN)",
          ),
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (change is null)" // {{{
          ..methodName = "fetchSummary"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd/summary"
          ..respJson = '''
          {
            "result": {
              "price": {
                "last": "NaN",
                "high": 9600.7,
                "low": 9200.5,
                "change": null
              },
              "volume": 3980.669,
              "volumeQuote": 37500000
            }
          }
          '''
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected Map<String, dynamic> field change, instead got Null(null)",
          ),
        // }}}
      ];

    _runRestApiClientTestSet(testGroup);
  }

  static void _test_fetchMarketPrice() {
    var testGroup = restApiClientTestGroup()
      ..testGroupName = "Test fetchMarketPrice"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching price, Ok" // {{{
          ..methodName = "fetchMarketPrice"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd/price"
          ..respJson = '{"result": {"price": 9200}}'
          ..wantRes = 9200,
        // }}}
        restApiClientTestCase()
          ..descr = "Exchange not found" // {{{
          ..methodName = "fetchMarketPrice"
          ..posArgs = ["fooBar", "btcusd"]
          ..wantPath = "/markets/fooBar/btcusd/price"
          ..respJson = '{"error": "Exchange not found"}'
          ..respStatusCode = 404
          ..wantRes = null,
        // }}}
        restApiClientTestCase()
          ..descr = "Pair not found" // {{{
          ..methodName = "fetchMarketPrice"
          ..posArgs = ["bitfinex", "fooBaz"]
          ..wantPath = "/markets/bitfinex/fooBaz/price"
          ..respJson = '{"error": "Instrument not found"}'
          ..respStatusCode = 404
          ..wantRes = null,
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (price is NaN)" // {{{
          ..methodName = "fetchMarketPrice"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd/price"
          ..respJson = '{"result": {"price": "NaN"}}'
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected num field price, instead got String(NaN)",
          ),
        // }}}
      ];

    _runRestApiClientTestSet(testGroup);
  }

  static void _test_fetchTrades() {
    var trade1 = sdk.PublicTrade()
      ..id = 1
      ..timestamp = 1589388000
      ..price = 9000
      ..amount = 0.1;

    var trade2 = sdk.PublicTrade()
      ..id = 2
      ..timestamp = 1589388060
      ..price = 8750
      ..amount = 0.5;

    var trade3 = sdk.PublicTrade()
      ..id = 3
      ..timestamp = 1589388120
      ..price = 8990.5
      ..amount = 0.2;

    var trade4 = sdk.PublicTrade()
      ..id = 4
      ..timestamp = 1589388180
      ..price = 9001.7
      ..amount = 1;

    var testGroup = restApiClientTestGroup()
      ..testGroupName = "Test fetchTrades"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching candles, Ok" // {{{
          ..methodName = "fetchTrades"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd/trades"
          ..respJson = '''
          {
            "result": [
              [1, 1589388000, 9000, 0.1],
              [2, 1589388060, 8750, 0.5],
              [3, 1589388120, 8990.5, 0.2],
              [4, 1589388180, 9001.7, 1]
            ]
          }
          '''
          ..wantRes = [trade1, trade2, trade3, trade4],
        // }}}
        restApiClientTestCase()
          ..descr = "Use Filter Params" // {{{
          ..methodName = "fetchTrades"
          ..posArgs = ["bitfinex", "btcusd"]
          ..namedArgs = {
            "since": 1589388000,
            "limit": 3,
          }
          ..wantPath = "/markets/bitfinex/btcusd/trades"
          ..wantParams = {
            "since": "1589388000",
            "limit": "3",
          }
          ..respJson = '''
          {
            "result": [
              [2, 1589388060, 8750, 0.5],
              [3, 1589388120, 8990.5, 0.2],
              [4, 1589388180, 9001.7, 1]
            ]
          }
          '''
          ..wantRes = [trade2, trade3, trade4],
        // }}}
        restApiClientTestCase()
          ..descr = "Exchange for market not found" // {{{
          ..methodName = "fetchTrades"
          ..posArgs = ["foo", "btcusd"]
          ..wantPath = "/markets/foo/btcusd/trades"
          ..respJson = '{"error": "Exchange not found"}'
          ..respStatusCode = 404
          ..wantRes = null,
        // }}}
        restApiClientTestCase()
          ..descr = "Pair for market not found" // {{{
          ..methodName = "fetchTrades"
          ..posArgs = ["bitfinex", "barbaz"]
          ..wantPath = "/markets/bitfinex/barbaz/trades"
          ..respJson = '{"error": "Instrument not found"}'
          ..respStatusCode = 404
          ..wantRes = null,
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (timestamp is NaN)" // {{{
          ..methodName = "fetchTrades"
          ..posArgs = ["bitfinex", "btcusd"]
          ..wantPath = "/markets/bitfinex/btcusd/trades"
          ..respJson = '''
          {
            "result": [
              [1, 1589388000, 9000, 0.1],
              [2, 1589388060, 8750, 0.5],
              [3, "NaN", 8990.5, 0.2],
              [4, 1589388180, 9001.7, 1]
            ]
          }
          '''
          ..wantException = sdk.UnexpectedResponseFormatException(
            "expected element 1 of array to be of type int, instead got String(NaN)",
          ),
        // }}}
      ];

    _runRestApiClientTestSet(testGroup);
  }

  static List<mirrors.InstanceMirror> _getAllTestFuncInstanceMirrors() {
    var testFuncIMs = List<mirrors.InstanceMirror>();

    var thisClass = mirrors.reflectClass(restApiClientTestSuite);
    var voidMir = mirrors.currentMirrorSystem().voidType;

    thisClass.staticMembers.forEach((k, methodMir) {
      if (methodMir.isGetter ||
          methodMir.isSetter ||
          !methodMir.isPrivate ||
          !methodMir.isStatic ||
          methodMir.returnType != voidMir) {
        return;
      }

      String methodName = mirrors.MirrorSystem.getName(methodMir.simpleName);
      if (!methodName.startsWith("_test_")) {
        return;
      }

      var testFuncIM = thisClass.getField(methodMir.simpleName);

      testFuncIMs.add(testFuncIM);
    });

    return testFuncIMs;
  }

  static _runRestApiClientTestSet(restApiClientTestGroup testSet) {
    if (testSet.cases.length == 0) {
      return;
    }

    testing.group(testSet.testGroupName, () {
      for (var tc in testSet.cases) {
        var clientMirror;
        var methodSym = mirrors.MirrorSystem.getSymbol(tc.methodName);

        {
          var domain = tc.setDomain;
          domain ??= _testApiDomain;

          var path = tc.wantPath;
          if (path[0] == "/") {
            path = path.replaceFirst("/", "");
          }

          var wantUrl = Uri.https(domain, path, tc.wantParams);

          var mockHttpClient = httpTesting.MockClient((http.Request req) {
            testing.expect(req.url, testing.equals(wantUrl));

            if (req.url != wantUrl) {
              return Future.value(http.Response("Not Found", 404));
            }

            var wantHeaders = {
              // This header is always included by default
              "User-Agent": "infinityCounter/cw-sdk-dart@${sdk.version}",
            };

            tc.wantHeaders.forEach((k, v) {
              wantHeaders[k] = v;
            });

            testing.expect(req.headers, testing.equals(wantHeaders));

            var statusCode = tc.respStatusCode;
            statusCode ??= 200;

            return Future.value(http.Response(tc.respJson, statusCode));
          });

          var apiClient = sdk.RestApiClient(
            httpClient: mockHttpClient,
            apiDomain: domain,
            apiKey: tc.setApiKey,
          );

          clientMirror = mirrors.reflect(apiClient);
        }

        testing.test(tc.descr, () async {
          Map<Symbol, dynamic> namedArgs;

          if (tc.namedArgs != null) {
            namedArgs = tc.namedArgs.map((k, v) {
              var kSym = mirrors.MirrorSystem.getSymbol(k);
              return MapEntry(kSym, v);
            });
          }

          var posArgs = List();
          if (tc.posArgs != null) {
            posArgs.addAll(tc.posArgs);
          }

          var resMir = clientMirror.invoke(methodSym, posArgs, namedArgs);
          if (tc.wantException != null) {
            testing.expect(
              resMir.reflectee,
              testing.throwsA(testing.predicate((e) => e == tc.wantException)),
            );
          } else {
            var gotRes = resMir.reflectee;

            if (gotRes is Future) {
              Future resFuture = resMir.reflectee;
              gotRes = await resFuture;
            }

            testing.expect(gotRes, testing.equals(tc.wantRes));
          }
        });
      }
    });
  }
}
