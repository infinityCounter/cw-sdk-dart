part of common;

class PublicTrade {
  int id = 0;
  int timestamp = 0;

  num price = 1;
  num amount = 2;

  toString() {
    return "PublicTrade(id=${this.id},  timestamp=${this.timestamp}, price=${this.price}, amount=${this.amount})";
  }
}
