import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mvvm_template/app/app_preferences.dart';
import 'package:mvvm_template/data/data_source/local_data_source.dart';
import 'package:mvvm_template/data/network/app_api.dart';
import 'package:mvvm_template/data/network/dio_factory.dart';
import 'package:mvvm_template/domain/usecase/forgot_password_usecase.dart';
import 'package:mvvm_template/domain/usecase/login_usecase.dart';
import 'package:mvvm_template/domain/usecase/store_details_usecase.dart';
import 'package:mvvm_template/presentation/forgot_password/viewmodel/forgot_password_viewmodel.dart';
import 'package:mvvm_template/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:mvvm_template/presentation/main/pages/home/viewmodel/home_viewmodel.dart';
import 'package:mvvm_template/presentation/store_details/viewmodel/store_details_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/data_source/remote_data_source.dart';
import '../data/network/network_info.dart';
import '../data/repository/repository_impl.dart';
import '../domain/repository/repository.dart';
import '../domain/usecase/home_usecase.dart';
import '../domain/usecase/register_usecase.dart';
import '../presentation/register/viewmodel/register_viewmodel.dart';
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

  // Local data source instance
  Constants.instance
      .registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());

  // Repository instance
  Constants.instance.registerLazySingleton<Repository>(() => RepositoryImpl(
      Constants.instance(), Constants.instance(), Constants.instance()));
}

void initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    // Login use case instance
    Constants.instance.registerFactory<LoginUseCase>(
        () => LoginUseCase(Constants.instance()));

    // Login view model instance
    Constants.instance.registerFactory<LoginViewModel>(
        () => LoginViewModel(Constants.instance()));
  }
}

void initForgotPasswordModule() {
  if (!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
    // Forgot password use case instance
    Constants.instance.registerFactory<ForgotPasswordUseCase>(
        () => ForgotPasswordUseCase(Constants.instance()));

    // Forgot password view model instance
    Constants.instance.registerFactory<ForgotPasswordViewModel>(
        () => ForgotPasswordViewModel(Constants.instance()));
  }
}

void initRegisterModule() {
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    // Register use case instance
    Constants.instance.registerFactory<RegisterUseCase>(
        () => RegisterUseCase(Constants.instance()));

    // Register view model instance
    Constants.instance.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(Constants.instance()));

    // Add image picker instance
    Constants.instance.registerLazySingleton<ImagePicker>(() => ImagePicker());
  }
}

void initHomeModule() {
  if (!GetIt.I.isRegistered<HomeUseCase>()) {
    // Home use case instance
    Constants.instance
        .registerFactory<HomeUseCase>(() => HomeUseCase(Constants.instance()));

    // Home view model instance
    Constants.instance.registerFactory<HomeViewModel>(
        () => HomeViewModel(Constants.instance()));
  }
}

void initStoreDetailsModule() {
  if (!GetIt.I.isRegistered<StoreDetailsUseCase>()) {
    // Home use case instance
    Constants.instance.registerFactory<StoreDetailsUseCase>(
        () => StoreDetailsUseCase(Constants.instance()));

    // Home view model instance
    Constants.instance.registerFactory<StoreDetailsViewModel>(
        () => StoreDetailsViewModel(Constants.instance()));
  }
}
