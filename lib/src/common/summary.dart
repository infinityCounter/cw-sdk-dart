part of common;

class Summary {
  num high = 0;
  num low = 0;
  num last = 0;

  num changeAbsolute = 0;
  num changePercentage = 0;

  num volumeBase = 0;
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
