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

    return PublicOrder(this.price, this.amount + o.amount);
  }

  /// Decrements the amount of an order.
  ///
  /// It returns a PublicOrder with the same price as [this] and [o],
  /// but with the [this]'s amount less that of [o].
  PublicOrder operator -(PublicOrder o) {
    if (o.price != this.price) {
      throw "incompatible operands, orders must have same price but ${this.price} != ${o.price}";
    }

    return PublicOrder(this.price, this.amount - o.amount);
  }

  toString() {
    return "PublicOrder(price=${this.price}, amount=${this.amount})";
  }

  List<num> _toJson() {
    return [this.price, this.amount];
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

Iterable<PublicOrder> aggregatePublicOrders(
    Iterable<PublicOrder> orders, num aggLevel) {
  var aggOrders = Map<num, PublicOrder>();
  for (var o in orders) {
    var absPrice = o.price.abs();
    var remainder = absPrice % aggLevel;

    var lvl;
    if (remainder == 0) {
      lvl = o.price;
    } else if (remainder == absPrice) {
      lvl = aggLevel;
    } else if (!o.price.isNegative) {
      lvl = o.price + aggLevel - remainder;
    } else {
      lvl = o.price - aggLevel + remainder;
    }

    var co = aggOrders[lvl];
    if (co != null) {
      co.amount += o.amount;
      aggOrders[lvl] = co;
    } else {
      aggOrders[lvl] = PublicOrder(lvl, o.amount);
    }
  }

  return aggOrders.values;
}

List<List<num>> _publicOrdersToJson(Iterable<PublicOrder> orders) {
  var res = List<List<num>>();
  for (var o in orders) {
    res.add(o._toJson());
  }
  return res;
}
