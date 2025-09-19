class ErrorExceptions implements Exception {
  String title;
  String body;

  ErrorExceptions({required this.title, required this.body});

  String toErrorString() {
    return "Error: $title\n$body";
  }
}

class FetchDataException extends ErrorExceptions {
  FetchDataException({required String body})
    : super(title: "Error During Communication", body: body);
}

class BadResquestException extends ErrorExceptions {
  BadResquestException({required String body})
    : super(title: "Invalid Request", body: body);
}

class UnauthorisedException extends ErrorExceptions {
  UnauthorisedException({required String body})
    : super(title: "Unauthorised", body: body);
}

class TooManyRequests extends ErrorExceptions {
  TooManyRequests({required String body})
    : super(title: "You made too many requests", body: body);
}

class InternalServerError extends ErrorExceptions {
  InternalServerError({required String body})
    : super(title: "Internal Server Error", body: body);
}
