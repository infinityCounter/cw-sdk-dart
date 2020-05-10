part of rest;

class UnexpectedResponseFormatException implements Exception {
  String reason = "";

  UnexpectedResponseFormatException(this.reason);

  toString() {
    return "Problem parsing API response; reason=${this.reason}";
  }
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
