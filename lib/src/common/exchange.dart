part of common;

class Exchange {
  int id;

  String name;
  String symbol;

  bool active;

  toString() {
    return "Exchange(id=${this.id}, name=${this.name}, symbol=${this.symbol}, active=${this.active})";
  }
}
