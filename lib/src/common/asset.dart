part of common;

class Asset {
  int id;

  String name;
  String symbol;

  bool fiat;

  toString() {
    return "Asset(id=${this.id}, name='${this.name}', symbol='${this.symbol}', fiat=${this.fiat})";
  }

  bool operator ==(otherAsset) {
    if (otherAsset is! Asset) {
      return false;
    }

    return this.id == otherAsset.id &&
        this.name == otherAsset.name &&
        this.symbol == otherAsset.symbol &&
        this.fiat == otherAsset.fiat;
  }

  int get hashCode => quiver.hash4(this.id, this.name, this.symbol, this.fiat);
}
