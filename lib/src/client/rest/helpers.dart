part of rest;

common.Asset _parseAsset(Map<String, dynamic> props) {
  // TODO: Enforce some type checks and throw exceptions otherwise.
  var id = props["id"];
  var name = props["name"];
  var symbol = props["symbol"];
  var fiat = props["fiat"];

  return new common.Asset(id, name, symbol, fiat);
}

common.Pair _parsePair(Map<String, dynamic> props) {
  // TODO: Enforce some type checks and throw exceptions otherwise.
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
  // TODO: Enforce some type checks and throw exceptions otherwise.
  var id = props["id"];
  var name = props["name"];
  var symbol = props["symbol"];
  var active = props["active"];

  return new common.Exchange(id, name, symbol, active);
}

common.Market _parseMarket(Map<String, dynamic> props) {
  // TODO: Enforce some type checks and throw exceptions otherwise.
  var id = props["id"];
  var exchange = props["exchange"];
  var pair = props["pair"];
  var active = props["active"];

  return new common.Market(id, exchange, pair, active);
}

common.PublicOrder _parsePublicOrder(Iterable props) {
  if (props.length < 2) {
    throw unexpectedResponseFormat;
  }

  var price = props.elementAt(0);
  if (price is! num) {
    throw unexpectedResponseFormat;
  }

  var amount = props.elementAt(1);
  if (amount is! num) {
    throw unexpectedResponseFormat;
  }

  return common.PublicOrder(price, amount);
}

Iterable<common.PublicOrder> _parsePublicOrders(Iterable unparsedOrders) {
  var orders = new List<common.PublicOrder>();
  for (var unparsedOrder in unparsedOrders) {
    orders.add(_parsePublicOrder(unparsedOrder));
  }

  return orders;
}

common.OrderBookSnapshot _parseOrderBookSnapshot(Map<String, dynamic> props) {
  var unparsedAsks = props["asks"];
  if (unparsedAsks != null && unparsedAsks is! Iterable) {
    throw unexpectedResponseFormat;
  }

  var asks = _parsePublicOrders(unparsedAsks);

  var unparsedBids = props["bids"];
  if (unparsedBids != null && unparsedBids is! Iterable) {
    throw unexpectedResponseFormat;
  }

  var bids = _parsePublicOrders(unparsedBids);

  var seqNum = props["seqNum"];
  if (seqNum is! num) {
    throw unexpectedResponseFormat;
  }

  return new common.OrderBookSnapshot(asks, bids, seqNum);
}
