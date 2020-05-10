part of common;

class Market {
  int id;

  String exchange;
  String pair;

  bool active;

  toString() {
    return "Market(id=${this.id}, exchange=${this.exchange}, pair=${this.pair}, active=${this.active})";
  }
}
