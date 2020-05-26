part of common;

/// A PublicTrade is an exchange of a fixed amount of
/// an asset at a fixed price between parties.
///
/// A PublicTrade is created whenever two PublicOrders
/// are matched with each other by a matching engine
/// on an Exchange for a Pair, i.e. on a Market.
class PublicTrade {
  /// The unique identifier used by Cryptowatch.
  int id = 0;

  /// The unix timestamp at which the trade occurred.
  int timestamp = 0;

  /// The price/(amount of the Market's quote asset) at which the trade happened.
  num price = 0;

  /// The amount of the Market's base asset which was exchanged in the trade.
  num amount = 0;

  toString() {
    return "PublicTrade(id=${this.id},  timestamp=${this.timestamp}, price=${this.price}, amount=${this.amount})";
  }

  operator ==(pt) =>
      pt is PublicTrade &&
      pt.id == this.id &&
      pt.timestamp == this.timestamp &&
      pt.price == this.price &&
      pt.amount == this.amount;

  get hashCode =>
      quiver.hash4(this.id, this.timestamp, this.price, this.amount);
}
