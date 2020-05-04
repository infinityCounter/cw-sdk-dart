part of client;

class _Cache {
  var assetsBySymbol = new Map<String, common.Asset>();
  var pairsBySymbol = new Map<String, common.Pair>();
  var exchangesBySymbol = new Map<String, common.Exchange>();
  var marketsByExchangePair = new Map<String, Map<String, common.Market>>();

  List<common.Asset> GetAssets() {
    return assetsBySymbol.entries.map((entry) => entry.value).toList();
  }
}
