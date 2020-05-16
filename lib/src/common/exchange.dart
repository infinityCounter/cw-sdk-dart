part of common;

class Exchange {
  int id;

  String name;
  String symbol;

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
