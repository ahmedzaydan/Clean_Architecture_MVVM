import 'package:dartz/dartz.dart';
import 'package:mvvm_template/data/network/failure.dart';
import 'package:mvvm_template/domain/repository/repository.dart';
import 'package:mvvm_template/domain/usecase/base_usecase.dart';

import '../../data/network/requests.dart';
import '../model/models.dart';

class ForgotPasswordUseCase
    implements BaseUseCase<ForgotPasswordUseCaseInput, ForgotPassword> {
  final Repository _repository;

  ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, ForgotPassword>> execute(
      ForgotPasswordUseCaseInput input) async {
    return await _repository
        .forgotPassword(ForgotPasswordRequest(email: input.email));
  }
}

class ForgotPasswordUseCaseInput {
  String email;

  ForgotPasswordUseCaseInput({
    required this.email,
  });
}
