part of common;

class PublicTrade {
  int id = 0;
  int timestamp = 0;

  num price = 0;
  num amount = 0;

  toString() {
    return "PublicTrade(id=${this.id},  timestamp=${this.timestamp}, price=${this.price}, amount=${this.amount})";
  }
}
