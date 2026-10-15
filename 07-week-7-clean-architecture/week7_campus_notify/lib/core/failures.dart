sealed class Failure {
  const Failure(this.message);
  final String message;
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class AnnouncementFailure extends Failure {
  const AnnouncementFailure(super.message);
}

class StorageFailure extends Failure {
  const StorageFailure(super.message);
}
