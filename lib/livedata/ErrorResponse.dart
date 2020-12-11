class ErrorResponse implements Exception {

  int code;
  String message;
  dynamic data;

  ErrorResponse({this.code, this.message, this.data});

  @override
  String toString() {
    return "code = $code, message = $message, data = $data";
  }

}