part of common;

class Market {
  int id;

  String exchange;
  String pair;

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
