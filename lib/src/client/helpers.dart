part of client;

common.Asset _parseAsset(Map<String, dynamic> props) {
  var id = props["id"];
  var name = props["name"];
  var symbol = props["symbol"];
  var fiat = props["fiat"];

  return new common.Asset(id, name, symbol, fiat);
}

common.Pair _parsePair(Map<String, dynamic> props) {
  var id = props["id"];
  var symbol = props["symbol"];
  var base = _parseAsset(props["base"]);
  var quote = _parseAsset(props["quote"]);
  var futuresContractPeriod = props["futuresContractPeriod"];

  return new common.Pair(
    id,
    symbol,
    base,
    quote,
    futuresContractPeriod,
  );
}

common.Exchange _parseExchange(Map<String, dynamic> props) {
  var id = props["id"];
  var name = props["name"];
  var symbol = props["symbol"];
  var active = props["active"];

  return new common.Exchange(id, name, symbol, active);
}

common.Market _parseMarket(Map<String, dynamic> props) {
  var id = props["id"];
  var exchange = props["exchange"];
  var pair = props["pair"];
  var active = props["active"];

  return new common.Market(id, exchange, pair, active);
}
