part of rest;

common.Asset _parseAsset(Map<String, dynamic> props) {
  var id = props["id"];
  if (id is! int) {
    throw _buildException("id", "int", id);
  }

  var name = props["name"];
  if (name is! String) {
    throw _buildException("name", "String", name);
  }

  var symbol = props["symbol"];
  if (symbol is! String) {
    throw _buildException("symbol", "String", symbol);
  }

  var fiat = props["fiat"];
  if (fiat is! bool) {
    throw _buildException("fiat", "bool", fiat);
  }

  return common.Asset()
    ..id = id
    ..name = name
    ..symbol = symbol
    ..fiat = fiat;
}

common.Pair _parsePair(Map<String, dynamic> props) {
  var id = props["id"];
  if (id is! int) {
    throw _buildException("id", "int", id);
  }

  var symbol = props["symbol"];
  if (symbol is! String) {
    throw _buildException("symbol", "String", symbol);
  }

  var futuresContractPeriod = props["futuresContractPeriod"];
  if (symbol is! String) {
    throw _buildException(
        "futuresContractPeriod", "String", futuresContractPeriod);
  }

  var base = _parseAsset(props["base"]);
  var quote = _parseAsset(props["quote"]);

  return common.Pair()
    ..id = id
    ..base = base
    ..quote = quote
    ..futuresContractPeriod = futuresContractPeriod;
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

common.Candle _parseCandle(Iterable props) {
  if (props.length < 7) {
    throw unexpectedResponseFormat;
  }

  return new common.Candle()
    ..timestamp = props.elementAt(0)
    ..open = props.elementAt(1)
    ..high = props.elementAt(2)
    ..low = props.elementAt(3)
    ..close = props.elementAt(4)
    ..volumeBase = props.elementAt(5)
    ..volumeQuote = props.elementAt(6);
}

Iterable<common.Candle> _parseCandles(Iterable props) {
  var candles = new List<common.Candle>();

  for (var p in props) {
    if (p is! Iterable) {
      throw unexpectedResponseFormat;
    }

    var candle = _parseCandle(p);
    candles.add(candle);
  }

  return candles;
}

common.Summary _parseSummary(Map<String, dynamic> props) {
  var priceProps = props["price"];
  if (priceProps == null || priceProps is! Map<String, dynamic>) {
    throw unexpectedResponseFormat;
  }

  var changeProps = priceProps["change"];
  if (changeProps == null || changeProps is! Map<String, dynamic>) {
    throw unexpectedResponseFormat;
  }

  var last = priceProps["last"];
  if (last == null || last is! num) {
    throw unexpectedResponseFormat;
  }

  var high = priceProps["high"];
  if (high == null || high is! num) {
    throw unexpectedResponseFormat;
  }

  var low = priceProps["low"];
  if (low == null || low is! num) {
    throw unexpectedResponseFormat;
  }

  var changeAbs = changeProps["absolute"];
  if (changeAbs == null || changeAbs is! num) {
    throw unexpectedResponseFormat;
  }

  var changePerc = changeProps["percentage"];
  if (changePerc == null || changePerc is! num) {
    throw unexpectedResponseFormat;
  }

  var volBase = props["volume"];
  if (volBase == null || volBase is! num) {
    throw unexpectedResponseFormat;
  }

  var volQuote = props["volumeQuote"];
  if (volQuote == null || volQuote is! num) {
    throw unexpectedResponseFormat;
  }

  return common.Summary()
    ..last = last
    ..high = high
    ..low = low
    ..changeAbsolute = changeAbs
    ..changePercentage = changePerc
    ..volumeBase = volBase
    ..volumeQuote = volQuote;
}

common.PublicTrade _parsePublicTrade(Iterable props) {
  if (props.length < 4) {
    throw unexpectedResponseFormat;
  }

  return new common.PublicTrade()
    ..id = props.elementAt(0)
    ..timestamp = props.elementAt(1)
    ..price = props.elementAt(2)
    ..amount = props.elementAt(3);
}

Iterable<common.PublicTrade> _parsePublicTrades(Iterable props) {
  var trades = new List<common.PublicTrade>();

  for (var p in props) {
    if (p is! Iterable) {
      throw unexpectedResponseFormat;
    }

    var trade = _parsePublicTrade(p);
    trades.add(trade);
  }

  return trades;
}

UnexpectedResponseFormatException _buildException(
  String wantField,
  String wantType,
  got,
) {
  return UnexpectedResponseFormatException(
    "expected ${wantType} field ${wantField}, instead got ${got.runtimeType}(${got})",
  );
}
