part of rest;

/// UnexpectedResponseFormatException is thrown whenever the Cryptowatch REST API
/// responds to a request with a body that the sdk is unable to parse.
class UnexpectedResponseFormatException implements Exception {
  String reason = "";

  UnexpectedResponseFormatException(this.reason);

  toString() {
    return "Problem parsing API response; reason=${this.reason}";
  }

  /// Returns true if the object being compared is also an instance of
  /// UnexpectedResponseFormatException, and it has the same reason.
  operator ==(e) =>
      e is UnexpectedResponseFormatException && e.reason == this.reason;

  get hashCode => this.reason.hashCode;
}

UnexpectedResponseFormatException _buildExceptionWrongFieldType(
  String wantField,
  String wantType,
  got,
) {
  return UnexpectedResponseFormatException(
    "expected ${wantType} field ${wantField}, instead got ${got.runtimeType}(${got})",
  );
}

UnexpectedResponseFormatException _buildExceptionWrongIndexType(
  int wantIndex,
  String wantType,
  got,
) {
  return UnexpectedResponseFormatException(
    "expected element ${wantIndex} of array to be of type ${wantType}, instead got ${got.runtimeType}(${got})",
  );
}

UnexpectedResponseFormatException _buildResponseBodyNotMapException(got) {
  return UnexpectedResponseFormatException(
    "expected API response body to be of type Map<String, dynamic>, instead got ${got.runtimeType}(${got})",
  );
}

/// RateLimitException is thrown whenever the Cryptowatch REST API
/// indicates that the client is making too many API requests.
class RateLimitException implements Exception {
  toString() {
    return "Rate limited by Cryptowatch API";
  }

  // All instances of RateLimitException are equal to each other
  // and return the same hashCode.

  /// Returns true if the object being compared to is also an instance of
  /// RateLimitException.
  operator ==(e) => e is RateLimitException;

  get hashCode => toString().hashCode;
}

/// RestServerException is thrown whenever the Cryptowatch REST API
/// returns a 500+ status code.
class RestServerException implements Exception {
  toString() {
    return "Internal Server error returned by Cryptowatch API";
  }

  // All instances of RestServerException are equal to each other
  // and return the same hashCode.

  /// Returns true if the object being compared to is also an instance of
  /// RestServerException.
  operator ==(e) => e is RestServerException;

  get hashCode => toString().hashCode;
}
