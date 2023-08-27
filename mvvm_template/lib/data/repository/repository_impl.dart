import 'package:dartz/dartz.dart';
import 'package:mvvm_template/data/data_source/remote_data_source.dart';
import 'package:mvvm_template/data/mapper/mapper.dart';
import 'package:mvvm_template/data/network/error_handler.dart';
import 'package:mvvm_template/data/network/failure.dart';
import 'package:mvvm_template/data/network/network_info.dart';
import 'package:mvvm_template/data/network/requests.dart';
import 'package:mvvm_template/domain/model/models.dart';
import 'package:mvvm_template/domain/repository/repository.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  RepositoryImpl(
    this._remoteDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.login(loginRequest);

        if (response.status == ApiInternalStatus.SUCCESS) {
          return Right(
            response.toDomain(),
          );
        } else {
          return Left(
            Failure(
              statusCode: response.status ?? ApiInternalStatus.FAILURE,
              message: response.message ?? ResponseMessage.DEFAULT,
            ),
          );
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // No internet connection
      return Left(
        DataSource.NO_INTERNET_CONNECTION.getFailure(),
      );
    }
  }

  @override
  Future<Either<Failure, ForgotPassword>> forgotPassword(
      ForgotPasswordRequest forgotPasswordRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        final response =
            await _remoteDataSource.forgotPassword(forgotPasswordRequest);

        if (response.status == ApiInternalStatus.SUCCESS) {
          return Right(
            response.toDomain(),
          );
        } else {
          return Left(
            Failure(
              statusCode: response.status ?? ApiInternalStatus.FAILURE,
              message: response.message ?? ResponseMessage.DEFAULT,
            ),
          );
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // No internet connection
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
