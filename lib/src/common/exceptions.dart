part of common;

/// A instance ApplyingOldDeltaException is thrown whenver an attempt
/// is made to apply a OrderBookDelta to an OrderBook with a higher
/// seqNum.
class ApplyingOldDeltaException implements Exception {
  final num _bookSeqNum;
  final num _deltaSeqNum;

  /// Constructs an ApplyingOldDeltaException using the OrderBook seqNum
  /// supplied as the first argument and the OrderBookDelta supplied as the
  /// second argument.
  ApplyingOldDeltaException(this._bookSeqNum, this._deltaSeqNum);

  toString() {
    return "Applying old delta to orderbook; Current SeqNum=${this._bookSeqNum}    Delta SeqNum=${this._deltaSeqNum}";
  }

  operator ==(e) {
    if (e is! ApplyingOldDeltaException) {
      return false;
    }

    return this._bookSeqNum == e._bookSeqNum &&
        this._deltaSeqNum == e._deltaSeqNum;
  }

  get hashCode => quiver.hash2(this._bookSeqNum, this._deltaSeqNum);
}

/// A instance ApplyingOldSnapshotException is thrown whenver an attempt
/// is made to apply a OrderBookSnapshot to an OrderBook with a higher
/// seqNum.
class ApplyingOldSnapshotException implements Exception {
  final num _bookSeqNum;
  final num _snapshotSeqNum;

  /// Constructs an ApplyingOldSnapshotException using the OrderBook seqNum
  /// supplied as the first argument and the OrderBookSnapshot supplied as the
  /// second argument.
  ApplyingOldSnapshotException(this._bookSeqNum, this._snapshotSeqNum);

  toString() {
    return "Applying old snapshot to orderbook; Current SeqNum=${this._bookSeqNum}    Snapshot SeqNum=${this._snapshotSeqNum}";
  }

  operator ==(e) {
    if (e is! ApplyingOldSnapshotException) {
      return false;
    }

    return this._bookSeqNum == e._bookSeqNum &&
        this._snapshotSeqNum == e._snapshotSeqNum;
  }

  get hashCode => quiver.hash2(this._bookSeqNum, this._snapshotSeqNum);
}
