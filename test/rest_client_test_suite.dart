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
  Map<String, String> wantHeaders = {};

  String methodName;

  int respStatusCode;
  String respJson = "";

  var wantRes;
  var wantException;
}

class restApiClientTestSet {
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

  static void _test_StatusCodeExceptions() {
    var bitfinex = sdk.Exchange()
      ..id = 1
      ..name = "Bitfinex"
      ..symbol = "bitfinex"
      ..active = true;

    var testSet = restApiClientTestSet()
      ..testGroupName = "Test throwing exceptions for status codes"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching Exchange, 200" // {{{
          ..methodName = "fetchExchange"
          ..posArgs = ["bitfinex"]
          ..setDomain = _testApiDomain
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
          ..setDomain = _testApiDomain
          ..wantPath = "/exchanges/bitfinex"
          ..respStatusCode = 429
          ..wantException = sdk.RateLimitException,
        // }}}
        restApiClientTestCase()
          ..descr = "Fetching Exchange, 500" // {{{
          ..methodName = "fetchExchange"
          ..posArgs = ["bitfinex"]
          ..setDomain = _testApiDomain
          ..wantPath = "/exchanges/bitfinex"
          ..respStatusCode = 500
          ..wantException = sdk.RestServerException,
        // }}}
        restApiClientTestCase()
          ..descr = "Fetching Exchange with API Key, 503" // {{{
          ..methodName = "fetchExchange"
          ..posArgs = ["bitfinex"]
          ..setDomain = _testApiDomain
          ..wantPath = "/exchanges/bitfinex"
          ..respStatusCode = 503
          ..wantException = sdk.RestServerException,
        // }}}
        restApiClientTestCase()
          ..descr = "Fetching Assets, 503" // {{{
          ..methodName = "fetchAssets"
          ..setDomain = _testApiDomain
          ..wantPath = "/assets"
          ..respStatusCode = 503
          ..wantException = sdk.RestServerException,
        // }}}
      ];

    _runRestApiClientTestSet(testSet);
  }

  static void _test_FetchAssets() {
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

    var testSet = restApiClientTestSet()
      ..testGroupName = "Test fetchAssets"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching assets" // {{{
          ..methodName = "fetchAssets"
          ..setDomain = _testApiDomain
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
          ..setDomain = _testApiDomain
          ..wantPath = "/assets"
          ..respJson = '{"result": []}'
          ..wantRes = <sdk.Asset>[],
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (asset symbol is null)" // {{{
          ..methodName = "fetchAssets"
          ..setDomain = _testApiDomain
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

    _runRestApiClientTestSet(testSet);
  }

  static void _test_FetchAsset() {
    var btc = sdk.Asset()
      ..id = 60
      ..symbol = "btc"
      ..name = "Bitcoin"
      ..fiat = false;

    var testSet = restApiClientTestSet()
      ..testGroupName = "Test fetchAsset"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching Bitcoin" // {{{
          ..methodName = "fetchAsset"
          ..posArgs = ["btc"]
          ..setDomain = _testApiDomain
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
          ..setDomain = _testApiDomain
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
          ..setDomain = _testApiDomain
          ..setApiKey = _testApiKey
          ..wantPath = "/assets/btc"
          ..wantHeaders = {"X-CW-API-Key": _testApiKey}
          ..respJson = '{"error": "Asset not found"}'
          ..respStatusCode = 404
          ..wantRes = null,
        // }}}
      ];

    _runRestApiClientTestSet(testSet);
  }

  static void _test_FetchPairs() {
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

    var testSet = restApiClientTestSet()
      ..testGroupName = "Test fetchPairs"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching pairs" // {{{
          ..methodName = "fetchPairs"
          ..setDomain = _testApiDomain
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
          ..setDomain = _testApiDomain
          ..wantPath = "/pairs"
          ..respJson = '{"result": []}'
          ..wantRes = <sdk.Pair>[],
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (should be list but is map)" // {{{
          ..methodName = "fetchPairs"
          ..setDomain = _testApiDomain
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
      ];

    _runRestApiClientTestSet(testSet);
  }

  static void _test_FetchPair() {
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

    var testSet = restApiClientTestSet()
      ..testGroupName = "Test fetchPair"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching spot pair" // {{{
          ..methodName = "fetchPair"
          ..posArgs = ["btcusd"]
          ..setDomain = _testApiDomain
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
          ..descr = "Fetching futures pair" // {{{
          ..methodName = "fetchPair"
          ..posArgs = ["btcusd-perpetual-futures"]
          ..setDomain = _testApiDomain
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
          ..setDomain = _testApiDomain
          ..wantPath = "/pairs/fooBarBaz"
          ..respJson = '{"error": "Pair not found"}'
          ..respStatusCode = 404
          ..wantRes = null,
        // }}}
        restApiClientTestCase()
          ..descr = "Malformed response (id is not set)" // {{{
          ..methodName = "fetchPair"
          ..posArgs = ["btcusd"]
          ..setDomain = _testApiDomain
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
          ..setDomain = _testApiDomain
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

    _runRestApiClientTestSet(testSet);
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

  static _runRestApiClientTestSet(restApiClientTestSet testSet) {
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
          if (path[0] != "/") {
            path = "/" + path;
          }

          var wantUrl = "https://${domain}${path}";

          var mockHttpClient = httpTesting.MockClient((http.Request req) {
            testing.expect(req.url.toString(), testing.equals(wantUrl));

            if (req.url.toString() != wantUrl) {
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
            tc.namedArgs.map((k, v) {
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
