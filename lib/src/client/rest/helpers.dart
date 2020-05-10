part of rest;

common.Asset _parseAsset(Map<String, dynamic> props) {
  var id = props["id"];
  if (id is! String) {
    throw _buildExceptionWrongFieldType("id", "int", id);
  }

  var name = props["name"];
  if (name is! String) {
    throw _buildExceptionWrongFieldType("name", "String", name);
  }

  var symbol = props["symbol"];
  if (symbol is! String) {
    throw _buildExceptionWrongFieldType("symbol", "String", symbol);
  }

  var fiat = props["fiat"];
  if (fiat is! bool) {
    throw _buildExceptionWrongFieldType("fiat", "bool", fiat);
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
    throw _buildExceptionWrongFieldType("id", "int", id);
  }

  var symbol = props["symbol"];
  if (symbol is! String) {
    throw _buildExceptionWrongFieldType("symbol", "String", symbol);
  }

  var futuresContractPeriod = props["futuresContractPeriod"];
  if (symbol is! String) {
    throw _buildExceptionWrongFieldType(
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
  var id = props["id"];
  if (id is! int) {
    throw _buildExceptionWrongFieldType("id", "int", id);
  }

  var name = props["name"];
  if (name is! String) {
    throw _buildExceptionWrongFieldType("name", "String", name);
  }

  var symbol = props["symbol"];
  if (symbol is! String) {
    throw _buildExceptionWrongFieldType("symbol", "String", symbol);
  }

  var active = props["active"];
  if (active is! bool) {
    throw _buildExceptionWrongFieldType("active", "bool", active);
  }

  return common.Exchange()
    ..id = id
    ..name = name
    ..symbol = symbol
    ..active = active;
}

common.Market _parseMarket(Map<String, dynamic> props) {
  var id = props["id"];
  if (id is! int) {
    throw _buildExceptionWrongFieldType("id", "int", id);
  }

  var exchange = props["exchange"];
  if (exchange is! String) {
    throw _buildExceptionWrongFieldType("exchange", "String", exchange);
  }

  var pair = props["pair"];
  if (pair is! String) {
    throw _buildExceptionWrongFieldType("pair", "String", pair);
  }

  var active = props["active"];
  if (active is! bool) {
    throw _buildExceptionWrongFieldType("active", "bool", active);
  }

  return common.Market()
    ..id = id
    ..exchange = exchange
    ..pair = pair
    ..active = active;
}

common.PublicOrder _parsePublicOrder(Iterable props) {
  if (props.length < 2) {
    throw UnexpectedResponseFormatException(
      "expected order array to have at least 2 elements, got ${props}",
    );
  }

  var price = props.elementAt(0);
  if (price is! num) {
    throw _buildExceptionWrongFieldType("price", "num", price);
  }

  var amount = props.elementAt(1);
  if (amount is! num) {
    throw _buildExceptionWrongFieldType("amount", "num", amount);
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
    throw _buildExceptionWrongFieldType("asks", "Iterable", unparsedAsks);
  }

  var asks = _parsePublicOrders(unparsedAsks);

  var unparsedBids = props["bids"];
  if (unparsedBids != null && unparsedBids is! Iterable) {
    throw _buildExceptionWrongFieldType("bids", "Iterable", unparsedBids);
  }

  var bids = _parsePublicOrders(unparsedBids);

  var seqNum = props["seqNum"];
  if (seqNum is! int) {
    throw _buildExceptionWrongFieldType("seqNum", "int", seqNum);
  }

  return common.OrderBookSnapshot(asks, bids, seqNum);
}

common.Candle _parseCandle(Iterable props) {
  if (props.length < 7) {
    throw UnexpectedResponseFormatException(
      "expected candle array to have at least 7 elements, got ${props}",
    );
  }

  var timestamp = props.elementAt(0);
  if (timestamp is! int) {
    throw _buildExceptionWrongIndexType(0, "int", timestamp);
  }

  for (var i = 1; i < 7; i++) {
    var p = props.elementAt(i);
    if (p is! num) {
      throw _buildExceptionWrongIndexType(i, "num", p);
    }
  }

  return common.Candle()
    ..timestamp = timestamp
    ..open = props.elementAt(1)
    ..high = props.elementAt(2)
    ..low = props.elementAt(3)
    ..close = props.elementAt(4)
    ..volumeBase = props.elementAt(5)
    ..volumeQuote = props.elementAt(6);
}

Iterable<common.Candle> _parseCandles(Iterable props) {
  var candles = new List<common.Candle>();

  for (var i = 0; i < props.length; i++) {
    var p = props.elementAt(i);
    if (p is! Iterable) {
      throw _buildExceptionWrongIndexType(i, "Iterable", p);
    }

    var candle = _parseCandle(p);
    candles.add(candle);
  }

  return candles;
}

common.Summary _parseSummary(Map<String, dynamic> props) {
  var priceProps = props["price"];
  if (priceProps is! Map<String, dynamic>) {
    throw _buildExceptionWrongFieldType(
      "price",
      "Map<String, dynamic>",
      priceProps,
    );
  }

  var changeProps = priceProps["change"];
  if (changeProps is! Map<String, dynamic>) {
    throw _buildExceptionWrongFieldType(
      "change",
      "Map<String, dynamic>",
      changeProps,
    );
  }

  var last = priceProps["last"];
  if (last is! num) {
    throw _buildExceptionWrongFieldType("last", "num", last);
  }

  var high = priceProps["high"];
  if (high is! num) {
    throw _buildExceptionWrongFieldType("high", "num", high);
  }

  var low = priceProps["low"];
  if (low is! num) {
    throw _buildExceptionWrongFieldType("low", "num", low);
  }

  var changeAbs = changeProps["absolute"];
  if (changeAbs is! num) {
    throw _buildExceptionWrongFieldType("absolute", "num", changeAbs);
  }

  var changePerc = changeProps["percentage"];
  if (changePerc is! num) {
    throw _buildExceptionWrongFieldType("percentage", "num", changePerc);
  }

  var volBase = props["volume"];
  if (volBase is! num) {
    throw _buildExceptionWrongFieldType("volume", "num", volBase);
  }

  var volQuote = props["volumeQuote"];
  if (volQuote is! num) {
    throw _buildExceptionWrongFieldType("volumeQuote", "num", volQuote);
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
    throw UnexpectedResponseFormatException(
      "expected trade array to have at least 4 elements, got ${props}",
    );
  }

  var id = props.elementAt(1);
  if (id is! int) {
    throw _buildExceptionWrongIndexType(0, "int", id);
  }

  var timestamp = props.elementAt(1);
  if (timestamp is! int) {
    throw _buildExceptionWrongIndexType(1, "int", timestamp);
  }

  var price = props.elementAt(2);
  if (price is! num) {
    throw _buildExceptionWrongIndexType(2, "num", price);
  }

  var amount = props.elementAt(3);
  if (amount is! num) {
    throw _buildExceptionWrongIndexType(3, "num", amount);
  }

  return common.PublicTrade()
    ..id = id
    ..timestamp = timestamp
    ..price = price
    ..amount = amount;
}

Iterable<common.PublicTrade> _parsePublicTrades(Iterable props) {
  var trades = new List<common.PublicTrade>();

  for (var i = 0; i < props.length; i++) {
    var p = props.elementAt(i);
    if (p is! Iterable) {
      throw _buildExceptionWrongIndexType(i, "Iterable", p);
    }

    var trade = _parsePublicTrade(p);
    trades.add(trade);
  }

  return trades;
}
