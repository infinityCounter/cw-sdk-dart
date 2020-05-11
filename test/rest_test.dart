library cw_sdk_dart_test;

import 'dart:convert' as convert;
import 'dart:mirrors' as mirrors;

import 'package:test/test.dart' as test;
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as httpTesting;

import 'package:cw_sdk_dart/cw_sdk_dart.dart' as sdk;

part 'test_case.dart';

const _thisLibName = "cw_sdk_dart_test";

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

  var clients = [
    anonApiClient,
    altDomainApiClient,
    authenticatedApiClient,
    fullyConfiguredApiClient,
  ];

  var ms = mirrors.currentMirrorSystem();
  var retMir = mirrors.reflectClass(restApiClientTestCase);

  // Reflect this library itself
  var thisLibSymbol = mirrors.MirrorSystem.getSymbol(_thisLibName);
  var thisLib = ms.findLibrary(thisLibSymbol);

  thisLib.declarations.forEach((k, decMir) {
    if (decMir is! mirrors.MethodMirror) {
      return;
    }

    mirrors.MethodMirror methodMir = decMir;
    String methodName = mirrors.MirrorSystem.getName(k);
    if (methodName == "main") {
      return;
    }

    print(methodName);
    print(methodMir.returnType);

    print(methodMir.returnType == retMir);
  });
}

restApiClientTestCase f1() {
  return restApiClientTestCase();
}
