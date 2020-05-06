part of common;

class PublicOrder {
  num price = 0;
  num amount = 0;

  PublicOrder(this.price, this.amount);

  /// Aggregates orders of the same price.
  ///
  /// It returns a PublicOrder with the same price as [this] and [o],
  /// but with the sum of their amounts.
  PublicOrder operator +(PublicOrder o) {
    if (o.price != this.price) {
      throw "incompatible operands, orders must have same price but ${this.price} != ${o.price}";
    }

    return new PublicOrder(this.price, this.amount + o.amount);
  }

  /// Decrements the amount of an order.
  ///
  /// It returns a PublicOrder with the same price as [this] and [o],
  /// but with the [this]'s amount less that of [o].
  PublicOrder operator -(PublicOrder o) {
    if (o.price != this.price) {
      throw "incompatible operands, orders must have same price but ${this.price} != ${o.price}";
    }

    return new PublicOrder(this.price, this.amount - o.amount);
  }

  toString() {
    return "PublicOrder(price=${this.price}, amount=${this.amount})";
  }
}

sortPublicOrders(List<PublicOrder> orders, [bool asc = true]) {
  orders.sort((a, b) {
    if (a.price < b.price) {
      return (asc) ? -1 : 1;
    } else if (a.price > b.price) {
      return (asc) ? 1 : -1;
    } else {
      return 0;
    }
  });
}
