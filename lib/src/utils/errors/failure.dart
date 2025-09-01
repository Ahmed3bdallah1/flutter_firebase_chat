class GeneralError extends Failure {
  GeneralError(e, [String? text])
      : super(text ?? e?.toString() ?? 'There was an Error, Please try again');
}

abstract class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() {
    return message;
  }
}
