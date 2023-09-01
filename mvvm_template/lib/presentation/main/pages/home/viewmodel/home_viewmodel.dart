import 'dart:async';
import 'dart:ffi';

import 'package:mvvm_template/domain/model/models.dart';
import 'package:mvvm_template/domain/usecase/home_usecase.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../base/base_viewmodel.dart';
import '../../../../common/state_renderer/state_renderer.dart';
import '../../../../common/state_renderer/state_renderer_impl.dart';

class HomeViewModel extends BaseViewModel
    implements HomeViewModelInputs, HomeViewModelOutputs {
  // Stream controllers
  final StreamController _homeDataStreamController =
      BehaviorSubject<HomeData>();

  final HomeUseCase _homeUseCase;

  HomeViewModel(this._homeUseCase);

  // Inputs
  @override
  void start() {
    _getHomeData();
  }

  @override
  Sink get inputHomeData => _homeDataStreamController.sink;

  void _getHomeData() async {
    inputState.add(
      LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState,
      ),
    );
    (await _homeUseCase.execute(Void)).fold((failure) {
      inputState.add(
        ErrorState(
          stateRendererType: StateRendererType.fullScreenErrorState,
          message: failure.message,
        ),
      );
    }, (homeDataObject) {
      inputState.add(ContentState());
      inputHomeData.add(HomeData(
        services: homeDataObject.data.services,
        banners: homeDataObject.data.banners,
        stores: homeDataObject.data.stores,
      ));
    });
  }

  // Outputs
  @override
  Stream<HomeData> get outputHomeData =>
      _homeDataStreamController.stream.map((homeData) => homeData);

  @override
  void dispose() {
    _homeDataStreamController.close();
    super.dispose();
  }
}

abstract class HomeViewModelInputs {
  Sink get inputHomeData;
}

abstract class HomeViewModelOutputs {
  Stream<HomeData> get outputHomeData;
}
