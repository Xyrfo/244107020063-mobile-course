import '../repositories/auth_repository.dart';

class IsLoggedIn {
  const IsLoggedIn(this._repository);
  final AuthRepository _repository;

  Future<bool> call() async {
    final access = await _repository.readAccessToken();
    return access != null;
  }
}
