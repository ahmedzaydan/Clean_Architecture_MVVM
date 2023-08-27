import 'package:dartz/dartz.dart';
import 'package:mvvm_template/data/network/failure.dart';
import 'package:mvvm_template/data/network/requests.dart';
import 'package:mvvm_template/domain/model/models.dart';
import 'package:mvvm_template/domain/repository/repository.dart';
import 'package:mvvm_template/domain/usecase/base_usecase.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, Authentication> {
  final Repository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      LoginUseCaseInput input) async {
    return await _repository.login(
      LoginRequest(
        email: input.email,
        password: input.password,
      ),
    );
  }
}

class LoginUseCaseInput {
  String email;
  String password;

  LoginUseCaseInput({
    required this.email,
    required this.password,
  });
}
