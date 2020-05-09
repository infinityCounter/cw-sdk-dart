part of common;

class Pair {
  int id;

  Asset base;
  Asset quote;

  String symbol;
  String futuresContractPeriod;

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
