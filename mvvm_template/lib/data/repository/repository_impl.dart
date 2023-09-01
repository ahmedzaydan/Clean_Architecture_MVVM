import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mvvm_template/app/extensions.dart';
import 'package:mvvm_template/data/data_source/local_data_source.dart';
import 'package:mvvm_template/data/data_source/remote_data_source.dart';
import 'package:mvvm_template/data/mapper/mapper.dart';
import 'package:mvvm_template/data/network/error_handler.dart';
import 'package:mvvm_template/data/network/failure.dart';
import 'package:mvvm_template/data/network/network_info.dart';
import 'package:mvvm_template/data/network/requests.dart';
import 'package:mvvm_template/domain/model/models.dart';
import 'package:mvvm_template/domain/repository/repository.dart';

class RepositoryImpl implements Repository {
  final LocalDataSource _localDataSource;
  final RemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  RepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.login(loginRequest);

        if (response.status == ApiInternalStatus.success) {
          return Right(
            response.toDomain(),
          );
        } else {
          return Left(
            Failure(
              message: response.message ?? ResponseMessage.defaultMessage,
              statusCode: response.status ?? ApiInternalStatus.failure,
            ),
          );
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // No internet connection
      return Left(
        DataSource.noInternetConnection.getFailure(),
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

        if (response.status == ApiInternalStatus.success) {
          return Right(
            response.toDomain(),
          );
        } else {
          return Left(
            Failure(
              statusCode: response.status ?? ApiInternalStatus.failure,
              message: response.message ?? ResponseMessage.defaultMessage,
            ),
          );
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // No internet connection
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest) async {
    // If device connected to internet
    if (await _networkInfo.isConnected) {
      try {
        // Receive response
        final response = await _remoteDataSource.register(registerRequest);

        // Check the response
        if (response.status == ApiInternalStatus.success) {
          // Convert AuthenticationResponse to Authentication
          return Right(response.toDomain());
        } else {
          // Return Failure object
          return Left(
            Failure(
              message: response.message ?? ResponseMessage.defaultMessage,
              statusCode: response.status ?? ApiInternalStatus.failure,
            ),
          );
        }
      } catch (error) {
        // Error happened
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // No internet connection
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }

  @override
  Future<Either<Failure, HomeObject>> getHomeData() async {
    try {
      // Get response from cache
      final cachedResponse = await _localDataSource.getHomeData();
      return Right(cachedResponse.toDomain());
    } catch (cacheError) {
      if (kDebugMode) print(cacheError.toString());
      // Cache is not existing or not valid
      // So get data from api

      // If device connected to internet
      if (await _networkInfo.isConnected) {
        try {
          // Receive response
          final response = await _remoteDataSource.getHomeData();

          // Check the response
          if (response.status == ApiInternalStatus.success) {
            // Cache response
            _localDataSource.cacheHomeData(response);

            // Convert AuthenticationResponse to Authentication
            return Right(response.toDomain());
          } else {
            // Return Failure object
            return Left(
              Failure(
                message: response.message ?? ResponseMessage.defaultMessage,
                statusCode: response.status ?? ApiInternalStatus.failure,
              ),
            );
          }
        } catch (error) {
          if (kDebugMode) print(error.toString());
          // Error happened
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        // No internet connection
        return Left(DataSource.noInternetConnection.getFailure());
      }
    }
  }
  
  @override
  Future<Either<Failure, StoreDetails>> getStoreDetails() async {
    try {
      // Get response from cache
      final cachedResponse = await _localDataSource.getStoreDetails();
      return Right(cachedResponse.toDomain());
    } catch (cacheError) {
      // Cache is not existing or not valid
      // So get data from api

      // If device connected to internet
      if (await _networkInfo.isConnected) {
        try {
          // Receive response
          final response = await _remoteDataSource.getStoreDetails();

          // Check the response
          if (response.status == ApiInternalStatus.success) {
            // Cache response
            _localDataSource.cacheStoreDetails(response);

            // Convert AuthenticationResponse to Authentication
            return Right(response.toDomain());
          } else {
            // Return Failure object
            return Left(
              Failure(
                message: response.message ?? ResponseMessage.defaultMessage,
                statusCode: response.status ?? ApiInternalStatus.failure,
              ),
            );
          }
        } catch (error) {
          // Error happened
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        // No internet connection
        return Left(DataSource.noInternetConnection.getFailure());
      }
    }
  }
}
