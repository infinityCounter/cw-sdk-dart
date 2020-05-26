part of common;

/// A pair represents an instrument traded on an Exchange.
///
/// It is composed of at minimum two underlying assets,
/// however a Derivative pair might have other properties set.
class Pair {
  /// The unique identifier used by Cryptowatch.
  int id;

  /// The base asset of the pair.
  ///
  /// Example: In the pair BTCUSD the base is Bitcoin(BTC).
  Asset base;

  /// The quote asset of the pair.
  ///
  /// Example: In the pair BTCUSD the quote is United States Dollar(USD).
  Asset quote;

  /// The unique symbol used to identify the pair by Cryptowatch.
  String symbol;

  /// The settlement period of the contract. This is only set if
  /// the pair is a Future.
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

  operator ==(p) =>
      p is Pair &&
      p.id == this.id &&
      p.base == this.base &&
      p.quote == this.quote &&
      p.symbol == this.symbol &&
      p.futuresContractPeriod == this.futuresContractPeriod;

  get hashCode => quiver.hashObjects([
        this.id,
        this.base,
        this.quote,
        this.symbol,
        this.futuresContractPeriod,
      ]);
}
