import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mvvm_template/app/app_preferences.dart';
import 'package:mvvm_template/app/extensions.dart';
import 'package:mvvm_template/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:mvvm_template/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:mvvm_template/presentation/resources/routes_manager.dart';
import 'package:mvvm_template/presentation/resources/values_manager.dart';

import '../../../app/constants.dart';
import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/strings_manager.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel _viewModel = Constants.instance<LoginViewModel>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void _bind() {
    // Tell view model to start its job
    _viewModel.start();

    _usernameController
        .addListener(() => _viewModel.setUsername(_usernameController.text));

    _passwordController
        .addListener(() => _viewModel.setPassword(_passwordController.text));

    _viewModel.isUserLoggedInSuccessfullyStreamController.stream
        .listen((isLoggedIn) {
      if (isLoggedIn) {
        // Save user logged in state
        Constants.instance<AppPreferences>().setUserLoggedIn();

        // Navigate to home screen
        SchedulerBinding.instance.addPostFrameCallback(
          (_) => Navigator.of(context).pushReplacementNamed(Routes.mainRoute),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _bind();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(
                context: context,
                contentScreenWidget: _getContentWidget(),
                function: () {
                  _viewModel.login(); // When click on retry button
                },
              ) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(top: AppPadding.p100),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Image
              const Center(
                child: Image(
                  image: AssetImage(ImageAssets.splashLogo),
                ),
              ),

              const SizedBox(height: AppSize.s28),

              // Username
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                child: StreamBuilder<bool>(
                    stream: _viewModel.outIsUsernameValid,
                    builder: (context, snapshot) {
                      return TextFormField(
                        style: Theme.of(context).textTheme.bodyLarge,
                        keyboardType: TextInputType.emailAddress,
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: AppStrings.username.tr(),
                          labelText: AppStrings.username.tr(),
                          errorText: (snapshot.data ?? true)
                              ? null
                              : AppStrings.usernameError.tr(),
                        ),
                      );
                    }),
              ),

              const SizedBox(height: AppSize.s28),

              // Password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                child: StreamBuilder<bool>(
                    stream: _viewModel.outIsPasswordValid,
                    builder: (context, snapshot) {
                      return TextFormField(
                        style: Theme.of(context).textTheme.bodyLarge,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: AppStrings.password.tr(),
                          labelText: AppStrings.password.tr(),
                          errorText: (snapshot.data ?? true)
                              ? null
                              : AppStrings.passwordError.tr(),
                        ),
                      );
                    }),
              ),

              const SizedBox(height: AppSize.s28),

              // Login button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                child: StreamBuilder<bool>(
                  stream: _viewModel.outAreAllInputsValid,
                  builder: (context, snapshot) {
                    return SizedBox(
                      width: AppSize.infinity,
                      height: AppSize.s40,
                      child: ElevatedButton(
                        onPressed: (snapshot.data ?? false)
                            ? () => _viewModel.login()
                            : null,
                        child:  Text(AppStrings.login.tr()),
                      ),
                    );
                  },
                ),
              ),

              // Forgot password + register button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p20,
                  vertical: AppPadding.p8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Forgot password
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          Routes.forgotPasswordRoute,
                        );
                      },
                      child: Text(
                        AppStrings.forgotPassword.tr(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),

                    // Register button
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          Routes.registerRoute,
                        );
                      },
                      child: Text(
                        AppStrings.notMember.tr(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
