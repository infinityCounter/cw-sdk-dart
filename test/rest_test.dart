library cw_sdk_dart_test;

import 'dart:convert' as convert;
import 'dart:mirrors' as mirrors;

import 'package:test/test.dart' as testing;
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as httpTesting;

import 'package:cw_sdk_dart/cw_sdk_dart.dart' as sdk;

part 'test_case.dart';

main() {
  const apiDomain = "test-api.cryptowat.ch";
  const apiKey = "827e9876-2e28-403b-b277-9f17d892337c";

  var anonApiClient = sdk.RestApiClient();
  var altDomainApiClient = sdk.RestApiClient(apiDomain: apiDomain);
  var authenticatedApiClient = sdk.RestApiClient(apiKey: apiKey);
  var fullyConfiguredApiClient = sdk.RestApiClient(
    apiDomain: apiDomain,
    apiKey: apiKey,
  );

  var clientReflections = [
    mirrors.reflect(anonApiClient),
    // mirrors.reflect(altDomainApiClient),
    // mirrors.reflect(authenticatedApiClient),
    // mirrors.reflect(fullyConfiguredApiClient),
  ];

  var testFuncIMs = _getAllTestFuncInstanceMirrors();
  var testSetsToRun = List<restApiClientTestSet>();

  for (var tf in testFuncIMs) {
    testSetsToRun.add(tf.reflectee());
  }

  for (var tset in testSetsToRun) {
    testing.group(tset.testName, () {
      var methodSym = mirrors.MirrorSystem.getSymbol(tset.methodName);

      for (var tc in tset.cases) {
        testing.test(tc.descr, () {
          for (var clientRef in clientReflections) {
            Map<Symbol, dynamic> namedArgs;

            if (tc.namedArgs != null) {
              tc.namedArgs.map((k, v) {
                var kSym = mirrors.MirrorSystem.getSymbol(k);
                return MapEntry(kSym, v);
              });
            }

            clientRef.invoke(methodSym, tc.posArgs, namedArgs);
          }
        });
      }
    });
  }
}

restApiClientTestSet f1() {
  var testSet = restApiClientTestSet()
    ..testName = "Assets"
    ..methodName = "fetchAsset"
    ..cases = [
      restApiClientTestCase()..posArgs = ["btc"]
    ];

  return testSet;
}

restApiClientTestSet _f2() {
  return restApiClientTestSet();
}

restApiClientTestSet _f3() {
  return restApiClientTestSet();
}

List<mirrors.InstanceMirror> _getAllTestFuncInstanceMirrors() {
  var testFuncIMs = List<mirrors.InstanceMirror>();

  var ms = mirrors.currentMirrorSystem();
  var retMir = mirrors.reflectClass(restApiClientTestSet);

  // Reflect this library itself
  var thisLib = ms.isolate.rootLibrary;

  thisLib.declarations.forEach((k, decMir) {
    if (decMir is! mirrors.MethodMirror) {
      return;
    }

    mirrors.MethodMirror methodMir = decMir;
    String methodName = mirrors.MirrorSystem.getName(k);

    if (methodMir.isPrivate || methodMir.returnType != retMir) {
      return;
    }

    var testFuncIM = thisLib.getField(decMir.simpleName);

    testFuncIMs.add(testFuncIM);
  });

  return testFuncIMs;
}
