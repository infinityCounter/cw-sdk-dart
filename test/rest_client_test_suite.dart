part of cw_sdk_dart_test;

const _testApiDomain = "test-api.cryptowat.ch";
const _testApiKey = "827e9876-2e28-403b-b277-9f17d892337c";

class restApiClientTestCase {
  String descr;

  String setDomain;
  String setApiKey;

  List posArgs;
  Map<String, dynamic> namedArgs;

  String wantUrl;
  String methodName;

  int respStatusCode;
  String respJson;

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

  static void _test_FetchAsset() {
    var btc = sdk.Asset()
      ..id = 60
      ..symbol = "btc"
      ..name = "Bitcoin"
      ..fiat = false;

    var testSet = restApiClientTestSet()
      ..testGroupName = "Test Fetch Assets"
      ..cases = [
        restApiClientTestCase()
          ..descr = "Fetching Bitcoin from API, full response" // {{{
          ..methodName = "fetchAsset"
          ..posArgs = ["btc"]
          ..setDomain = _testApiDomain
          ..wantUrl = "https://${_testApiDomain}/assets/btc"
          ..respJson = '''
          {
            "result": {
              "id":60,
              "symbol":"btc",
              "name":"Bitcoin",
              "fiat":false,
              "markets":{
                "base":[
                  {
                    "id":4635,
                    "exchange":"kraken-futures",
                    "pair":"btcusd-quarterly-futures",
                    "active":true,
                    "route":"https://api.cryptowat.ch/markets/kraken-futures/btcusd-quarterly-futures"
                  }
                ],
                "quote":[
                  {
                    "id":60917,
                    "exchange":"kraken-futures",
                    "pair":"xrpbtc-perpetual-futures",
                    "active":true,
                    "route":"https://api.cryptowat.ch/markets/kraken-futures/xrpbtc-perpetual-futures"
                  }
                ]
              }
            },
            "allowance":{
              "cost":1117794,
              "remaining": 3998882206,
              "remainingPaid":0,
              "upgrade": "Upgrade for a higher allowance, starting at \$15/month for 16 seconds/hour. https://cryptowat.ch/pricing"
            }
          }
          '''
          ..respStatusCode = 200
          ..wantRes = btc,
        // }}}
        restApiClientTestCase()
          ..descr = "Fetching Bitcoin from API, just the essentials" // {{{
          ..methodName = "fetchAsset"
          ..posArgs = ["btc"]
          ..setDomain = _testApiDomain
          ..wantUrl = "https://${_testApiDomain}/assets/btc"
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
          ..respStatusCode = 200
          ..wantRes = btc
        // }}}
      ];

    return _runRestApiClientTestSet(testSet);
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
          var mockHttpClient = httpTesting.MockClient((http.Request req) {
            testing.expect(req.url.toString(), testing.equals(tc.wantUrl));

            if (req.url.toString() != tc.wantUrl) {
              return Future.value(http.Response("Not Found", 404));
            }

            return Future.value(http.Response(tc.respJson, tc.respStatusCode));
          });

          var apiClient = sdk.RestApiClient(
            httpClient: mockHttpClient,
            apiDomain: tc.setDomain,
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

          var resMir = clientMirror.invoke(methodSym, tc.posArgs, namedArgs);
          var gotRes = resMir.reflectee;

          if (gotRes is Future) {
            Future resFuture = gotRes;
            gotRes = await resFuture;
          }

          testing.expect(gotRes, testing.equals(tc.wantRes));
        });
      }
    });
  }
}
