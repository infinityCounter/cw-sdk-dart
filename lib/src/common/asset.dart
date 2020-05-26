part of common;

/// An asset is something that is traded, like a crypto or fiat currency.
class Asset {
  /// The unique identifier used by Cryptowatch.
  int id;

  /// The name of the asset.
  String name;

  /// The unique symbol used to identify the asset by Cryptowatch.
  String symbol;

  /// A boolean indicating if the asset is a fiat or not.
  bool fiat;

  toString() {
    return "Asset(id=${this.id}, name='${this.name}', symbol='${this.symbol}', fiat=${this.fiat})";
  }

  bool operator ==(a) {
    if (a is! Asset) {
      return false;
    }

    return this.id == a.id &&
        this.name == a.name &&
        this.symbol == a.symbol &&
        this.fiat == a.fiat;
  }

  int get hashCode => quiver.hash4(this.id, this.name, this.symbol, this.fiat);
}
