part of common;

class Asset {
  int id;

  String name;
  String symbol;

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
