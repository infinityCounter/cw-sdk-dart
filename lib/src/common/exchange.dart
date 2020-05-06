part of common;

class Exchange {
  int id;

  String name;
  String symbol;

  bool active;

  Exchange(this.id, this.name, this.symbol, this.active);

  toString() {
    return "Exchange(id=${this.id}, name=${this.name}, symbol=${this.symbol}, active=${this.active})";
  }
}
