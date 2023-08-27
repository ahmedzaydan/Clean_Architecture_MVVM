import 'package:dartz/dartz.dart';
import 'package:mvvm_template/data/network/failure.dart';
import 'package:mvvm_template/data/network/requests.dart';

import '../model/models.dart';

abstract class Repository {
  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest);
  Future<Either<Failure, ForgotPassword>> forgotPassword(ForgotPasswordRequest forgotPasswordRequest);
}
