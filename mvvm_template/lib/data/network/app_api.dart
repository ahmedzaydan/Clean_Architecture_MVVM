import 'package:dio/dio.dart';
import 'package:mvvm_template/app/constants.dart';
import 'package:mvvm_template/data/response/responses.dart';
import 'package:retrofit/retrofit.dart';
part 'app_api.g.dart';

@RestApi(
  baseUrl: Constants.baseUrl,
)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST(Constants.loginEndpoint)
  Future<AuthenticationResponse> login(
    @Field("email") String email,
    @Field("password") String password,
  );

  @POST(Constants.forgotPasswordEndpoint)
  Future<ForgotPasswordResponse> forgotPassword(
    @Field("email") String email,
  );
}
