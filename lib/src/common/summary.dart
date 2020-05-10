part of common;

class Summary {
  num last = 0;
  num high = 0;
  num low = 0;

  num changeAbsolute = 0;
  num changePercentage = 0;

  num volumeBase = 0;
  num volumeQuote = 0;

  toString() {
    var props = List<String>()
      ..add("last=${this.last}")
      ..add("high=${this.high}")
      ..add("low=${this.low}")
      ..add("changeAbsolute=${this.changeAbsolute}")
      ..add("changePercentage=${this.changePercentage}")
      ..add("volumeBase=${this.volumeBase}")
      ..add("volumeQuote=${this.volumeQuote}");

    return "Summary(${props.join(', ')})";
  }
}
