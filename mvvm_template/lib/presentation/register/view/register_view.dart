import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvvm_template/app/extensions.dart';
import 'package:mvvm_template/presentation/resources/color_manager.dart';
import 'package:mvvm_template/presentation/resources/values_manager.dart';

import '../../../app/app_preferences.dart';
import '../../../app/constants.dart';
import '../../common/state_renderer/state_renderer_impl.dart';
import '../../resources/assets_manager.dart';
import '../../resources/routes_manager.dart';
import '../../resources/strings_manager.dart';
import '../viewmodel/register_viewmodel.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewModel _viewModel = Constants.instance<RegisterViewModel>();
  final ImagePicker _imagePicker = Constants.instance<ImagePicker>();
  final AppPreferences _appPreferences = Constants.instance<AppPreferences>();
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _bind() {
    _viewModel.start();

    _usernameController
        .addListener(() => _viewModel.setUsername(_usernameController.text));
    _emailController
        .addListener(() => _viewModel.setEmail(_emailController.text));
    _passwordController
        .addListener(() => _viewModel.setPassword(_passwordController.text));
    _phoneController
        .addListener(() => _viewModel.setPhone(_phoneController.text));

    _viewModel.isUserRegisteredSuccessfullyStreamController.stream
        .listen((isLoggedIn) {
      if (isLoggedIn) {
        // navigate to main screen
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _appPreferences.setUserLoggedIn();

          Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
        });
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
      appBar: AppBar(
        elevation: AppSize.s0,
        backgroundColor: ColorManager.white,
        iconTheme: IconThemeData(color: ColorManager.primary),
      ),
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(
                context: context,
                contentScreenWidget: _getContentWidget(),
                function: () => _viewModel.register(),
              ) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(top: AppPadding.p28),
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

              const SizedBox(height: AppSize.s18),

              // Username
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                child: StreamBuilder<String?>(
                    stream: _viewModel.outputErrorUsername,
                    builder: (context, snapshot) {
                      return TextFormField(
                        style: Theme.of(context).textTheme.bodyLarge,
                        keyboardType: TextInputType.emailAddress,
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: AppStrings.username.tr(),
                          labelText: AppStrings.username.tr(),
                          errorText: snapshot.data,
                        ),
                      );
                    }),
              ),

              const SizedBox(height: AppSize.s18),

              // Country code + phone number
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p18),
                  child: Row(
                    children: [
                      // Country code
                      Expanded(
                        flex: 1,
                        child: CountryCodePicker(
                          onChanged: (country) {
                            _viewModel.setCountryCode(country.dialCode!);
                          },
                          initialSelection: '+20',
                          favorite: const ['+039', 'FR' '+966'],
                          showCountryOnly: true,
                          hideMainText: true,
                          showOnlyCountryWhenClosed: true,
                        ),
                      ),

                      // Phone number
                      Expanded(
                        flex: 4,
                        child: StreamBuilder<String?>(
                          stream: _viewModel.outputErrorPhone,
                          builder: (context, snapshot) {
                            return TextFormField(
                              style: Theme.of(context).textTheme.bodyLarge,
                              keyboardType: TextInputType.phone,
                              controller: _phoneController,
                              decoration: InputDecoration(
                                hintText: AppStrings.phone.tr(),
                                labelText: AppStrings.phone.tr(),
                                errorText: snapshot.data,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSize.s18),

              // Email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                child: StreamBuilder<String?>(
                    stream: _viewModel.outputErrorEmail,
                    builder: (context, snapshot) {
                      return TextFormField(
                        style: Theme.of(context).textTheme.bodyLarge,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: AppStrings.emailHint.tr(),
                          labelText: AppStrings.emailHint.tr(),
                          errorText: snapshot.data,
                        ),
                      );
                    }),
              ),

              const SizedBox(height: AppSize.s18),

              // Password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                child: StreamBuilder<String?>(
                    stream: _viewModel.outputErrorPassword,
                    builder: (context, snapshot) {
                      return TextFormField(
                        style: Theme.of(context).textTheme.bodyLarge,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: AppStrings.password.tr(),
                          labelText: AppStrings.password.tr(),
                          errorText: snapshot.data,
                        ),
                      );
                    }),
              ),

              const SizedBox(height: AppSize.s18),

              // Profile picture
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                child: Container(
                  height: AppSize.s40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.s8),
                    border: Border.all(
                      color: ColorManager.grey,
                    ),
                  ),
                  child: GestureDetector(
                      child: _getMediaWidget(),
                      onTap: () {
                        _showMediaPicker(context);
                      }),
                ),
              ),

              const SizedBox(height: AppSize.s40),

              // Register button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                child: StreamBuilder<bool>(
                  stream: _viewModel.outputAreAllInputsValid,
                  builder: (context, snapshot) {
                    return SizedBox(
                      width: AppSize.infinity,
                      height: AppSize.s40,
                      child: ElevatedButton(
                        onPressed: (snapshot.data ?? false)
                            ? () => _viewModel.register()
                            : null,
                        child: Text(AppStrings.register.tr()),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppSize.s18),

              // Login text button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p20,
                  vertical: AppPadding.p8,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppStrings.alreadyHaveAnAccount.tr(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getMediaWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile picture text
          Flexible(child: Text(AppStrings.profilePicture.tr())),

          // Profile picture view
          Flexible(
            child: StreamBuilder<File>(
              stream: _viewModel.outputProfilePicture,
              builder: (context, snapshot) {
                return _imagePickedByUser(snapshot.data);
              },
            ),
          ),

          // Profile picture icon
          Flexible(child: SvgPicture.asset(ImageAssets.photoCameraIc)),
        ],
      ),
    );
  }

  Widget _imagePickedByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      return Image.file(image);
    } else {
      return Container();
    }
  }

  void _showMediaPicker(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              // Gallery
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.browse_gallery),
                title: Text(AppStrings.photoFromGallery.tr()),
                onTap: () {
                  _imageFromGallery();
                  Navigator.of(context).pop();
                },
              ),

              // Camera
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera),
                title: Text(AppStrings.photoFromCamera.tr()),
                onTap: () {
                  _imageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _imageFromGallery() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(
      image?.path ?? AppStrings.empty.tr(),
    ));
  }

  void _imageFromCamera() async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    _viewModel.setProfilePicture(File(
      image?.path ?? AppStrings.empty.tr(),
    ));
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
