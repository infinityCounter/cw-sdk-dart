library common;

class Asset {
  int id;

  String name;
  String symbol;

  bool fiat;

  Asset(this.id, this.name, this.symbol, this.fiat);

  toString() {
    return "Asset(id=${this.id}, name='${this.name}', symbol='${this.symbol}', fiat=${this.fiat})";
  }
}

class Pair {
  int id;

  Asset base;
  Asset quote;

  String symbol;
  String futuresContractPeriod;

  Pair(this.id, this.symbol, this.base, this.quote,
      [this.futuresContractPeriod]);

  toString() {
    List<String> props = [
      "id=${this.id}",
      "symbol='${this.symbol}'",
      "base=${this.base.toString()}",
      "quote=${this.quote.toString()}",
    ];

    if (this.futuresContractPeriod == null) {
      props.add("futuresContractPeriod=null");
    } else {
      props.add("futuresContractPeriod='${this.futuresContractPeriod}'");
    }

    return "Pair(${props.join(', ')})";
  }
}

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

class Market {
  int id;

  String exchange;
  String pair;

  bool active;

  Market(this.id, this.exchange, this.pair, this.active);

  toString() {
    return "Market(id=${this.id}, exchange=${this.exchange}, pair=${this.pair}, active=${this.active})";
  }
}
