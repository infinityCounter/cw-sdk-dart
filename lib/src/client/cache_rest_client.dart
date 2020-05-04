part of client;

class RestApiClientWithCache extends BasicRestApiClient {
  _Cache _cache;

  RestApiClientWithCache(
      {String apiDomain: defaultApiDomain, String apiKey: ""})
      : super(apiDomain: apiDomain, apiKey: apiKey) {
    this._cache = new _Cache();
  }

  List<common.Asset> GetAssets() {
    return _cache.GetAssets();
  }
}
