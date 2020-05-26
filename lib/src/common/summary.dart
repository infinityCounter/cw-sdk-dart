part of common;

/// A Summary is a 24 hour sliding window of a Market's metrics.
class Summary {
  /// The highest price of the Market within 24hrs.
  num high = 0;

  /// The lowest price of the Market within 24hrs.
  num low = 0;

  /// The last price at which a trade happened for the Market.
  num last = 0;

  /// The difference between the last price and the price 24hrs ago.
  num changeAbsolute = 0;

  /// The percentage increase in the price of the Market compared to 24hrs ago.
  num changePercentage = 0;

  /// The total volume of all trades that occurred within the previous 24hrs, in the base asset.
  num volumeBase = 0;

  /// The total volume of all trades that occurred within the previous 24hrs, in the quote asset.
  num volumeQuote = 0;

  toString() {
    var props = List<String>()
      ..add("high=${this.high}")
      ..add("low=${this.low}")
      ..add("last=${this.last}")
      ..add("changeAbsolute=${this.changeAbsolute}")
      ..add("changePercentage=${this.changePercentage}")
      ..add("volumeBase=${this.volumeBase}")
      ..add("volumeQuote=${this.volumeQuote}");

    return "Summary(${props.join(', ')})";
  }

  operator ==(s) =>
      s is Summary &&
      s.high == this.high &&
      s.low == this.low &&
      s.last == this.last &&
      s.changeAbsolute == this.changeAbsolute &&
      s.changePercentage == this.changePercentage &&
      s.volumeBase == this.volumeBase &&
      s.volumeQuote == this.volumeQuote;

  get hashCode => quiver.hashObjects([
        this.high,
        this.low,
        this.last,
        this.changeAbsolute,
        this.changePercentage,
        this.volumeBase,
        this.volumeQuote,
      ]);
}
