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

  @POST(Constants.registerEndpoint)
  Future<AuthenticationResponse> register(
    @Field("username") String username,
    @Field("password") String password,
    @Field("country_code") String countryCode,
    @Field("email") String email,
    @Field("phone") String phone,
    @Field("photo") String photo,
  );

  @GET(Constants.homeEndpoint)
  Future<HomeResponse> getHomeData();

  @GET("${Constants.storeDetailsEndpoint}/1")
  Future<StoreDetailsResponse> getStoreDetails();
}
