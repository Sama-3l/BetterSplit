abstract class Failure {
  final String? message;

  const Failure({this.message});

  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({String? message}) : super(message: message);
}

class CacheFailure extends Failure {
  const CacheFailure({String? message}) : super(message: message);
}

class LocalStorageFailure extends Failure {
  const LocalStorageFailure({String? message}) : super(message: message);
}

class InternetFailure extends Failure {
  const InternetFailure({String? message = 'No Internet Connection'})
    : super(message: message);
}

class ApiFailure extends Failure {
  const ApiFailure({String? message}) : super(message: message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message ?? 'An error occurred.';
}

class FirebaseFailure extends Failure {
  const FirebaseFailure({String? message}) : super(message: message);
}

class DatabaseFailure extends Failure {}

class NormalFailure extends Failure {
  const NormalFailure({String? message}) : super(message: message);
}

class ValidationFailure extends Failure {
  const ValidationFailure({String? message}) : super(message: message);
}

class JsonSerializationFailure extends Failure {
  const JsonSerializationFailure({String? message}) : super(message: message);
}
