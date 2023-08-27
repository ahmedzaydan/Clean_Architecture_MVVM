import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mvvm_template/app/app_preferences.dart';
import 'package:mvvm_template/data/network/app_api.dart';
import 'package:mvvm_template/data/network/dio_factory.dart';
import 'package:mvvm_template/domain/usecase/forgot_password_usecase.dart';
import 'package:mvvm_template/domain/usecase/login_usecase.dart';
import 'package:mvvm_template/presentation/forgot_password/viewmodel/forgot_password_viewmodel.dart';
import 'package:mvvm_template/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/data_source/remote_data_source.dart';
import '../data/network/network_info.dart';
import '../data/repository/repository_impl.dart';
import '../domain/repository/repository.dart';
import 'constants.dart';

Future<void> initAppModule() async {
  // App module is a module where we put all generic dependencies

  // Shared preferences instance
  final sharedPreferences = await SharedPreferences.getInstance();
  Constants.instance
      .registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // App preferences instance
  Constants.instance.registerLazySingleton<AppPreferences>(
      () => AppPreferences(Constants.instance()));

  // Network info instance
  Constants.instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  // Dio factory instance
  Constants.instance.registerLazySingleton<DioFactory>(
      () => DioFactory(Constants.instance()));

  // App service client instance
  Dio dio = await Constants.instance<DioFactory>().getDio();
  Constants.instance
      .registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  // Remote data source instance
  Constants.instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(Constants.instance()));

  // Repository instance
  Constants.instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(Constants.instance(), Constants.instance()));
}

void initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    Constants.instance.registerFactory<LoginUseCase>(
        () => LoginUseCase(Constants.instance()));
    Constants.instance.registerFactory<LoginViewModel>(
        () => LoginViewModel(Constants.instance()));
  }
}

void initForgotPassword() {
  if (!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
    Constants.instance.registerFactory<ForgotPasswordUseCase>(
        () => ForgotPasswordUseCase(Constants.instance()));
    Constants.instance.registerFactory<ForgotPasswordViewModel>(
        () => ForgotPasswordViewModel(Constants.instance()));
  }
}
