part of common;

class ApplyingOldDeltaException implements Exception {
  final num _bookSeqNum;
  final num _deltaSeqNum;

  ApplyingOldDeltaException(this._bookSeqNum, this._deltaSeqNum);

  toString() {
    return "Applying old delta to orderbook; Current SeqNum=${this._bookSeqNum}    Delta SeqNum=${this._deltaSeqNum}";
  }
}
