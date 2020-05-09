part of common;

class Asset {
  int id;

  String name;
  String symbol;

  bool fiat;

  toString() {
    return "Asset(id=${this.id}, name='${this.name}', symbol='${this.symbol}', fiat=${this.fiat})";
  }
}
