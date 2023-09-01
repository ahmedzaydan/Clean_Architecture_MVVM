import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_template/app/constants.dart';
import 'package:mvvm_template/app/extensions.dart';
import 'package:mvvm_template/domain/model/models.dart';
import 'package:mvvm_template/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:mvvm_template/presentation/resources/strings_manager.dart';
import 'package:mvvm_template/presentation/resources/values_manager.dart';
import 'package:mvvm_template/presentation/store_details/viewmodel/store_details_viewmodel.dart';

class StoreDetailsView extends StatefulWidget {
  const StoreDetailsView({super.key});

  @override
  State<StoreDetailsView> createState() => _StoreDetailsViewState();
}

class _StoreDetailsViewState extends State<StoreDetailsView> {
  final StoreDetailsViewModel _viewModel =
      Constants.instance<StoreDetailsViewModel>();
  void _bind() {
    _viewModel.start();
  }

  @override
  void initState() {
    super.initState();
    _bind();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: StreamBuilder<FlowState>(
            stream: _viewModel.outputState,
            builder: (context, snapshot) {
              return snapshot.data?.getScreenWidget(
                    context: context,
                    contentScreenWidget: _getContentWidget(),
                    function: () {
                      _viewModel.start();
                    },
                  ) ??
                  _getContentWidget();
            },
          ),
        ),
      ),
    );
  }

  Widget _getContentWidget() {
    return StreamBuilder<StoreDetails>(
        stream: _viewModel.outputStoreDetails,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Image.network(
                  snapshot.data?.image ?? AppStrings.empty.tr(),
                  fit: BoxFit.cover,
                  height: AppSize.s190,
                  width: AppSize.infinity,
                ),

                // Details
                _getSectionTitle(AppStrings.details.tr()),
                _getText(snapshot.data?.details),

                // Services
                _getSectionTitle(AppStrings.services),
                _getText(snapshot.data?.services),

                // About store
                _getSectionTitle(AppStrings.aboutStore.tr()),
                _getText(snapshot.data?.about),
              ],
            );
          } else {
            return Container();
          }
        });
  }

  Widget _getSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppPadding.p12,
        right: AppPadding.p12,
        top: AppPadding.p12,
        bottom: AppPadding.p2,
      ),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _getText(String? text) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p8),
      child: Text(
        text ?? AppStrings.empty.tr(),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
