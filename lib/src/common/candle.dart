part of common;

class Candle {
  num open = 0;
  num high = 0;
  num low = 0;
  num close = 0;
  num volumeBase = 0;
  num volumeQuote = 0;

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
