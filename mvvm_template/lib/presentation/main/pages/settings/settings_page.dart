import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvvm_template/app/app_preferences.dart';
import 'package:mvvm_template/app/constants.dart';
import 'package:mvvm_template/data/data_source/local_data_source.dart';
import 'package:mvvm_template/presentation/resources/assets_manager.dart';
import 'package:mvvm_template/presentation/resources/color_manager.dart';
import 'package:mvvm_template/presentation/resources/routes_manager.dart';
import 'package:mvvm_template/presentation/resources/values_manager.dart';
import 'dart:math' as math;
import '../../../resources/strings_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppPreferences _appPreferences = Constants.instance<AppPreferences>();
  final LocalDataSource _localDataSource =
      Constants.instance<LocalDataSource>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.all(AppPadding.p8),
        children: [
          // Change language
          ListTile(
            leading: SvgPicture.asset(ImageAssets.changeLangIc),
            title: Text(
              AppStrings.changeLanguage.tr(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: ColorManager.grey1,
                  ),
            ),
            trailing: _gerRightArrow(),
            onTap: () {
              _changeLanguage();
            },
          ),

          // Contact us
          ListTile(
            leading: SvgPicture.asset(ImageAssets.contactUsIc),
            title: Text(
              AppStrings.contactUs.tr(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: ColorManager.grey1,
                  ),
            ),
            trailing: _gerRightArrow(),
            onTap: () {
              _contactUs();
            },
          ),

          // Invite your friends
          ListTile(
            leading: SvgPicture.asset(ImageAssets.inviteFriendsIc),
            title: Text(
              AppStrings.inviteYourFriends.tr(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: ColorManager.grey1,
                  ),
            ),
            trailing: _gerRightArrow(),
            onTap: () {
              _inviteYourFriends();
            },
          ),
          // Logout
          ListTile(
            leading: SvgPicture.asset(ImageAssets.logoutIc),
            title: Text(
              AppStrings.logout.tr(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: ColorManager.grey1,
                  ),
            ),
            trailing: _gerRightArrow(),
            onTap: () {
              _logout();
            },
          ),
        ],
      ),
    );
  }

  bool isRtl() {
    return context.locale == Constants.arLocal;
  }

  void _changeLanguage() {
    _appPreferences.changeAppLanguage();
    Phoenix.rebirth(context);
  }

  void _contactUs() {}

  void _inviteYourFriends() {}

  void _logout() {
    // Set user logged out
    _appPreferences.logout();

    // Clear cache
    _localDataSource.clearCache();

    // Navigate to login screen
    Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
  }

  Widget _gerRightArrow() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
      child: SvgPicture.asset(ImageAssets.rightArrowSettingsIc),
    );
  }
}
