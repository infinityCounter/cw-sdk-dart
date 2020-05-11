part of cw_sdk_dart_test;

class restApiClientTestCase {
  String descr;

  List posArgs;
  Map<String, dynamic> namedArgs;

  String respJson;

  var wantRes;
  var wantException;
}

class restApiClientTestSet {
  String testName;
  String methodName;

  List<restApiClientTestCase> cases = [];
}
