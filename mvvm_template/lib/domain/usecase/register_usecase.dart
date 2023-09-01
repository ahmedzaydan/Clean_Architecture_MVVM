import 'package:dartz/dartz.dart';
import 'package:mvvm_template/data/network/failure.dart';
import 'package:mvvm_template/domain/model/models.dart';
import 'package:mvvm_template/domain/repository/repository.dart';
import 'package:mvvm_template/domain/usecase/base_usecase.dart';

import '../../data/network/requests.dart';

class RegisterUseCase
    extends BaseUseCase<RegisterUseCaseInput, Authentication> {
  final Repository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(RegisterUseCaseInput input) {
    return _repository.register(
      RegisterRequest(
        username: input.username,
        password: input.password,
        countryCode: input.countryCode,
        email: input.email,
        phone: input.phone,
        photo: input.photo,
      ),
    );
  }
}

class RegisterUseCaseInput {
  String username;
  String password;
  String countryCode;
  String email;
  String phone;
  String photo;

  RegisterUseCaseInput({
    required this.username,
    required this.password,
    required this.countryCode,
    required this.email,
    required this.phone,
    required this.photo,
  });
}
