part of common;

/// A representation of a traditional candlestick chart candle.
///
/// In addition to OHLC, a candle also contains volume traded on the candle
/// in both the base and quote asset, and the closing timestamp of the candle.
class Candle {
  /// The opening price of the candle.
  ///
  /// The price of the first trade that occurred in the candle.
  num open = 0;

  /// The high price of the candle.
  ///
  /// The highest price at which a trade occurred in the candle.
  num high = 0;

  /// The low price of the candle.
  ///
  /// The lowest price at which a trade occured in the candle.
  num low = 0;

  /// The closing price of the candle.
  ///
  /// The price of the final trade that occurred in the candle.
  num close = 0;

  /// The total volume of the trades that occurred in candle in the base asset.
  num volumeBase = 0;

  /// The total volume of the trades that occurred in the candle in the quote asset.
  num volumeQuote = 0;

  /// The unix timestamp at which the candle was/is scheduled to close.
  int timestamp = 0;

  toString() {
    var props = List<String>()
      ..add("open=${this.open}")
      ..add("high=${this.high}")
      ..add("low=${this.low}")
      ..add("close=${this.close}")
      ..add("volumeBase=${this.volumeBase}")
      ..add("volumeQuote=${this.volumeQuote}");

    return "Candle(${props.join(', ')})";
  }

  operator ==(c) =>
      c is Candle &&
      c.open == this.open &&
      c.high == this.high &&
      c.low == this.low &&
      c.close == this.close &&
      c.volumeBase == this.volumeBase &&
      c.volumeQuote == this.volumeQuote &&
      c.timestamp == this.timestamp;

  get hashCode => quiver.hashObjects([
        this.open,
        this.high,
        this.low,
        this.close,
        this.volumeBase,
        this.volumeQuote,
        this.timestamp,
      ]);
}
