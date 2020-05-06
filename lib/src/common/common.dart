library common;

class Asset {
  int id;

  String name;
  String symbol;

  bool fiat;

  Asset(this.id, this.name, this.symbol, this.fiat);

  toString() {
    return "Asset(id=${this.id}, name='${this.name}', symbol='${this.symbol}', fiat=${this.fiat})";
  }
}

class Pair {
  int id;

  Asset base;
  Asset quote;

  String symbol;
  String futuresContractPeriod;

  Pair(this.id, this.symbol, this.base, this.quote,
      [this.futuresContractPeriod]);

  toString() {
    List<String> props = [
      "id=${this.id}",
      "symbol='${this.symbol}'",
      "base=${this.base.toString()}",
      "quote=${this.quote.toString()}",
    ];

    if (this.futuresContractPeriod == null) {
      props.add("futuresContractPeriod=null");
    } else {
      props.add("futuresContractPeriod='${this.futuresContractPeriod}'");
    }

    return "Pair(${props.join(', ')})";
  }
}

class Exchange {
  int id;

  String name;
  String symbol;

  bool active;

  Exchange(this.id, this.name, this.symbol, this.active);

  toString() {
    return "Exchange(id=${this.id}, name=${this.name}, symbol=${this.symbol}, active=${this.active})";
  }
}

class Market {
  int id;

  String exchange;
  String pair;

  bool active;

  Market(this.id, this.exchange, this.pair, this.active);

  toString() {
    return "Market(id=${this.id}, exchange=${this.exchange}, pair=${this.pair}, active=${this.active})";
  }
}

class PublicOrder {
  num price = 0;
  num amount = 0;

  PublicOrder(this.price, this.amount);

  /// Aggregates orders of the same price.
  ///
  /// It returns a PublicOrder with the same price as [this] and [o],
  /// but with the sum of their amounts.
  PublicOrder operator +(PublicOrder o) {
    if (o.price != this.price) {
      throw "incompatible operands, orders must have same price but ${this.price} != ${o.price}";
    }

    return new PublicOrder(this.price, this.amount + o.amount);
  }

  /// Decrements the amount of an order.
  ///
  /// It returns a PublicOrder with the same price as [this] and [o],
  /// but with the [this]'s amount less that of [o].
  PublicOrder operator -(PublicOrder o) {
    if (o.price != this.price) {
      throw "incompatible operands, orders must have same price but ${this.price} != ${o.price}";
    }

    return new PublicOrder(this.price, this.amount - o.amount);
  }

  toString() {
    return "PublicOrder(price=${this.price}, amount=${this.amount})";
  }
}

class OrderBookSnapshot {
  final num seqNum;

  final asks = new List<PublicOrder>();
  final bids = new List<PublicOrder>();

  OrderBookSnapshot(List<PublicOrder> asks, List<PublicOrder> bids,
      [this.seqNum = 0]) {
    this.asks.addAll(asks);
    this.bids.addAll(bids);
  }
}

class OrderBook {
  num seqNum = 0;

  var _asks = new List<PublicOrder>();
  var _bids = new List<PublicOrder>();

  OrderBook(List<PublicOrder> asks, List<PublicOrder> bids) {
    this.asks = asks;
    this.bids = bids;
  }

  OrderBook.fromSnapshot(OrderBookSnapshot snapshot) {}

  List<PublicOrder> get asks {
    return this._asks;
  }

  set asks(List<PublicOrder> orders) {
    sortPublicOrders(orders);
    this._asks = orders;
  }

  List<PublicOrder> get bids {
    return this._bids;
  }

  set bids(List<PublicOrder> orders) {
    sortPublicOrders(orders);
    this._bids = orders;
  }

  OrderBookSnapshot get Snapshot {
    return OrderBookSnapshot(this.asks, this.bids);
  }

  OrderBookSnapshot aggregatedSnapshot(num aggLevel) {
    // TODO: implement this.
  }
}

sortPublicOrders(List<PublicOrder> orders, [bool asc = true]) {
  orders.sort((a, b) {
    if (a.price < b.price) {
      return (asc) ? -1 : 1;
    } else if (a.price > b.price) {
      return (asc) ? 1 : -1;
    } else {
      return 0;
    }
  });
}
