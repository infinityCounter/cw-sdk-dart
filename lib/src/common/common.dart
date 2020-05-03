library common;

class Asset {
  final id;
  final name;
  final symbol;
  final fiat;

  Asset(this.id, this.name, this.symbol, this.fiat);

  toString() {
    return "Asset(id=${this.id}, name='${this.name}', symbol='${this.symbol}', fiat=${this.fiat})";
  }
}
