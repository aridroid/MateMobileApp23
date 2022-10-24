class CustomException implements Exception {
  CustomException([this._message, this._prefix]);

  final dynamic _message;
  final dynamic _prefix;

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([String message]) : super(message, "Invalid Request: ");
}


class NotFoundException extends CustomException {
  NotFoundException([String message]) : super(message, "");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([String message]) : super(message, "");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}

class ValidationFailureException extends CustomException {

  Map<String, dynamic> _validationErrors;

  get validationErrors => _validationErrors;

  ValidationFailureException([String message, Map<String, dynamic>validationErrors]) : super(message, "Validation Failed: ") {
    _validationErrors = validationErrors;
  }
}
