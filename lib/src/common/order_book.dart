part of common;

class OrderBookSnapshot {
  final int seqNum;

  final asks = List<PublicOrder>();
  final bids = List<PublicOrder>();

  OrderBookSnapshot(Iterable<PublicOrder> asks, Iterable<PublicOrder> bids,
      [this.seqNum = 0]) {
    this.asks.addAll(asks);
    this.bids.addAll(bids);
  }

  toString() {
    var asksJson = convert.jsonEncode(this.asks);
    var bidsJson = convert.jsonEncode(this.bids);

    return "OrderBookSnapshot(asks=${asksJson}, bids=${bidsJson}, seqNum=${this.seqNum})";
  }
}

/// An OrderBookDelta represents a diff between 2 orderbook snapshots.
///
/// These messages are only available over the Cryptowatch WS API and not
/// the REST API.
/// For more on these order book deltas:
/// https://docs.cryptowat.ch/websocket-api/data-subscriptions/order-books#deltas
class OrderBookDelta {
  final int seqNum;

  final setAsks = List<PublicOrder>();
  final setBids = List<PublicOrder>();

  final removeAskPriceLevels = List<num>();
  final removeBidPriceLevels = List<num>();

  OrderBookDelta(Iterable<PublicOrder> setAsks, Iterable<PublicOrder> setBids,
      Iterable<num> removeAskPriceLevels, Iterable<num> removeBidPriceLevels,
      [this.seqNum = 0]) {
    this.setAsks.addAll(setAsks);
    this.setBids.addAll(setBids);

    this.removeAskPriceLevels.addAll(removeAskPriceLevels);
    this.removeBidPriceLevels.addAll(removeBidPriceLevels);
  }

  toString() {
    var asksJson = convert.jsonEncode(this.setAsks);
    var bidsJson = convert.jsonEncode(this.setBids);

    var props = [
      "setAsks=${asksJson}",
      "setBids=${bidsJson}",
      "removeAskPriceLevels=${this.removeAskPriceLevels}",
      "removeBidPriceLevels=${this.removeBidPriceLevels}",
      "seqNum=${this.seqNum}",
    ].join(",");

    return "OrderBookDelta(${props})";
  }
}

class OrderBook {
  int seqNum = 0;

  // Internal maps are keyed by price.
  var _asks = Map<num, PublicOrder>();
  var _bids = Map<num, PublicOrder>();

  OrderBook(Iterable<PublicOrder> asks, Iterable<PublicOrder> bids,
      [int seqNum = 0]) {
    this.asks = asks;
    this.bids = bids;
    this.seqNum = seqNum;
  }

  OrderBook.fromSnapshot(OrderBookSnapshot snapshot) {
    this.asks = snapshot.asks;
    this.bids = snapshot.bids;
    this.seqNum = snapshot.seqNum;
  }

  Iterable<PublicOrder> get asks {
    var orders = this._asks.entries.map((entry) => entry.value).toList();
    sortPublicOrders(orders);

    return orders;
  }

  set asks(Iterable<PublicOrder> orders) {
    this._asks.clear();

    for (var o in orders) {
      var co = this._asks[o.price];
      if (co != null) {
        this._asks[o.price] = co + o;
      } else {
        this._asks[o.price] = o;
      }
    }
  }

  Iterable<PublicOrder> get bids {
    var orders = this._bids.entries.map((entry) => entry.value).toList();
    sortPublicOrders(orders);

    return orders;
  }

  set bids(Iterable<PublicOrder> orders) {
    this._bids.clear();

    for (var o in orders) {
      var co = this._bids[o.price];
      if (co != null) {
        this._bids[o.price] = co + o;
      } else {
        this._bids[o.price] = o;
      }
    }
  }

  OrderBookSnapshot get snapshot {
    return OrderBookSnapshot(this.asks, this.bids, this.seqNum);
  }

  OrderBookSnapshot aggregatedSnapshot(num aggLevel) {
    if (aggLevel == null || aggLevel == 0) {
      return this.snapshot;
    }

    var execption = ArgumentError.value(
      aggLevel,
      "aggLevel",
      "Aggregation level must be a finite non-negative number or null",
    );

    if (aggLevel.isNaN || aggLevel.isNegative || aggLevel.isInfinite) {
      throw execption;
    }

    var aggAsks = aggregatePublicOrders(this._asks.values, aggLevel);
    var aggBids = aggregatePublicOrders(this._bids.values, aggLevel);

    return OrderBookSnapshot(aggAsks, aggBids, this.seqNum);
  }

  applySnapshot(OrderBookSnapshot snapshot, [bool disregardSeq = false]) {
    if (!disregardSeq && this.seqNum >= snapshot.seqNum) {
      throw ApplyingOldDeltaException(this.seqNum, snapshot.seqNum);
    }

    this.seqNum = snapshot.seqNum;
    this.asks = snapshot.asks;
    this.bids = snapshot.bids;
  }

  applyDelta(OrderBookDelta delta) {
    if (this.seqNum >= delta.seqNum) {
      throw ApplyingOldDeltaException(this.seqNum, delta.seqNum);
    }

    for (var o in delta.setAsks) {
      this._asks[o.price] = o;
    }

    for (var o in delta.setBids) {
      this._bids[o.price] = o;
    }

    for (var pl in delta.removeAskPriceLevels) {
      this._asks.remove(pl);
    }

    for (var pl in delta.removeBidPriceLevels) {
      this._bids.remove(pl);
    }
  }

  toString() {
    var asksJson = convert.jsonEncode(this.asks);
    var bidsJson = convert.jsonEncode(this.bids);

    return "OrderBook(asks=${asksJson}, bids=${bidsJson}, seqNum=${this.seqNum})";
  }
}
