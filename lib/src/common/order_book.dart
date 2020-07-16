part of common;

/// An OrderBookSnapshot is the deterministic state of an OrderBook at
/// any given point in time.
///
/// An OrderBookSnapshot is immutable.
class OrderBookSnapshot {
  /// The sequence number of the snapshot among all OrderBook states
  /// inclusive of OrderBookDeltas.
  final int seqNum;

  /// A sorted list of all ask orders.
  ///
  /// Asks are sorted in ascending order (lowest price first).
  final asks = List<PublicOrder>();

  /// A sorted list of all bid orders.
  ///
  /// Bids are sorted in descending order (highest price first).
  final bids = List<PublicOrder>();

  /// Instantiates a new OrderBookSnapshot object using an Iterable set of
  /// [asks] and [bids] PublicOrders. Optionally a [seqNum] can be passed.
  OrderBookSnapshot(Iterable<PublicOrder> asks, Iterable<PublicOrder> bids,
      [this.seqNum = 0]) {
    sortPublicOrders(asks);
    sortPublicOrders(bids);

    this.asks.addAll(asks);
    this.bids.addAll(bids);
  }

  toString() {
    var asksJson = _publicOrdersToJson(this.asks);
    var bidsJson = _publicOrdersToJson(this.bids);

    return "OrderBookSnapshot(asks=${asksJson}, bids=${bidsJson}, seqNum=${this.seqNum})";
  }

  operator ==(s) =>
      s is OrderBookSnapshot &&
      s.seqNum == this.seqNum &&
      _listsAreEqual(s.asks, this.asks) &&
      _listsAreEqual(s.bids, this.bids);

  get hashCode => quiver.hash3(this.seqNum, this.asks, this.bids);
}

/// An OrderBookDelta represents a diff between 2 orderbook snapshots.
///
/// An OrderBookDelta is immutable.
///
/// These messages are only available over the Cryptowatch WS API and not
/// the REST API.
/// For more on these order book deltas:
/// https://docs.cryptowat.ch/websocket-api/data-subscriptions/order-books#deltas
class OrderBookDelta {
  /// The sequence number of the delta among all OrderBook states
  /// inclusive of OrderBookSnapshots.
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
    var asksJson = _publicOrdersToJson(this.setAsks);
    var bidsJson = _publicOrdersToJson(this.setBids);

    var props = [
      "setAsks=${asksJson}",
      "setBids=${bidsJson}",
      "removeAskPriceLevels=${this.removeAskPriceLevels}",
      "removeBidPriceLevels=${this.removeBidPriceLevels}",
      "seqNum=${this.seqNum}",
    ].join(",");

    return "OrderBookDelta(${props})";
  }

  operator ==(s) =>
      s is OrderBookDelta &&
      s.seqNum == this.seqNum &&
      _listsAreEqual(s.setAsks, this.setAsks) &&
      _listsAreEqual(s.setBids, this.setBids) &&
      _listsAreEqual(s.removeAskPriceLevels, this.removeAskPriceLevels) &&
      _listsAreEqual(s.removeBidPriceLevels, this.removeBidPriceLevels);

  get hashCode => quiver.hashObjects([
        this.seqNum,
        this.setAsks,
        this.setBids,
        this.removeAskPriceLevels,
        this.removeBidPriceLevels,
      ]);
}

/// An OrderBook is a sorted set of orders (asks and bids)
/// for a particular Market.
///
/// Asks are sorted in ascending order (lowest price first),
/// while Bids are sorted in descending order (highest price first).
/// An OrderBook can be updated by applying either an OrderBookSnapshot
/// or an OrderBookDelta. Applying a snapshot will overwrite the
/// entire state of the book, while a delta will only update the
/// price levels and orders specified by the particular delta.
class OrderBook {
  /// The sequence number of the state of the book.
  ///
  /// The value is set to the seqNum of the last applied
  /// OrderBookSnapshot/Delta.
  int seqNum = 0;

  // Internal maps are keyed by price.
  var _asks = Map<num, PublicOrder>();
  var _bids = Map<num, PublicOrder>();

  /// Instantiates a new OrderBook object using an Iterable set of
  /// [asks] and [bids] PublicOrders. Optionally a [seqNum] can be passed.
  OrderBook(Iterable<PublicOrder> asks, Iterable<PublicOrder> bids,
      [int seqNum = 0]) {
    this.asks = asks;
    this.bids = bids;
    this.seqNum = seqNum;
  }

  /// Instantiates a new OrderBook object and directly applies
  /// the [snapshot] to it.
  OrderBook.fromSnapshot(OrderBookSnapshot snapshot) {
    this.asks = snapshot.asks;
    this.bids = snapshot.bids;
    this.seqNum = snapshot.seqNum;
  }

  /// Returns a sorted iterable set of all asks.
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

  /// Returns a sorted iterable set of all bids.
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

  /// Returns a snapshot representation of the current order book state.
  OrderBookSnapshot get snapshot {
    return OrderBookSnapshot(this.asks, this.bids, this.seqNum);
  }

  /// Returns a snapshot representation of the current order book state,
  /// with orders amounts aggregated at certain price levels.
  ///
  /// If [aggLevel] is null then this method just returns the snapshot
  /// without any aggregation.
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

  /// Attempts to apply [snapshot] to the OrderBook.
  ///
  /// If [disregardSeq] is not set to true, then the
  /// seqNum of [snapshot] is compared against that of the book,
  /// and if is not greater an ApplyingOldSnapshotException is thrown.
  applySnapshot(OrderBookSnapshot snapshot, [bool disregardSeq = false]) {
    if (!disregardSeq && this.seqNum >= snapshot.seqNum) {
      throw ApplyingOldSnapshotException(this.seqNum, snapshot.seqNum);
    }

    this.seqNum = snapshot.seqNum;
    this.asks = snapshot.asks;
    this.bids = snapshot.bids;
  }

  /// Attempts to apply [delta] to the OrderBook.
  ///
  /// If seqNum of the delta is not greater than that of the
  /// the book an ApplyingOldDeltaException is thrown.
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
    var asksJson = _publicOrdersToJson(this.asks);
    var bidsJson = _publicOrdersToJson(this.bids);

    return "OrderBook(asks=${asksJson}, bids=${bidsJson}, seqNum=${this.seqNum})";
  }

  operator ==(s) {
    if (s is OrderBook) {
      return s.snapshot == this.snapshot;
    } else if (s is OrderBookSnapshot) {
      return s == this.snapshot;
    }

    return false;
  }

  get hashCode => quiver.hash3(this.seqNum, this._asks, this._bids);
}

const _listEquality = collection.ListEquality();

bool _listsAreEqual(List listA, List listB) {
  return _listEquality.equals(listA, listB);
}
