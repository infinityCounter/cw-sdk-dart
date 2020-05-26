part of common;

/// An Exchange is a marketplace for securities, or in this case assets and pairs.
class Exchange {
  /// The unique identifier used by Cryptowatch.
  int id;

  /// The name of the exchange.
  String name;

  /// The unique symbol used to identify the exchange by Cryptowatch.
  String symbol;

  /// A boolean indicating whether or not the Exchange is still active
  /// on cryptowatch.
  ///
  /// If set to false then all markets for this exchange will no longer
  /// be updated by Cryptowatch.
  bool active;

  toString() {
    return "Exchange(id=${this.id}, name=${this.name}, symbol=${this.symbol}, active=${this.active})";
  }

  operator ==(e) =>
      e is Exchange &&
      e.id == this.id &&
      e.name == this.name &&
      e.symbol == this.symbol &&
      e.active == this.active;

  get hashCode => quiver.hash4(this.id, this.name, this.symbol, this.active);
}
