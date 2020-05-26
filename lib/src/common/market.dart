part of common;

/// A Market represents the listing/trading of a Pair on an Exchange.
class Market {
  /// The unique identifier used by Cryptowatch.
  int id;

  /// The symbol of the exchange that this market lives on.
  String exchange;

  /// The symbol of the underlying pair for this market.
  String pair;

  /// A boolean indicating whether or not the Market is still active
  /// on cryptowatch.
  bool active;

  toString() {
    return "Market(id=${this.id}, exchange=${this.exchange}, pair=${this.pair}, active=${this.active})";
  }

  operator ==(m) =>
      m is Market &&
      m.id == this.id &&
      m.exchange == this.exchange &&
      m.pair == this.pair &&
      m.active == this.active;

  get hashCode => quiver.hash4(this.id, this.exchange, this.pair, this.active);
}
