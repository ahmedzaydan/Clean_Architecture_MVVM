import 'dart:async';
import 'dart:ffi';

import 'package:mvvm_template/domain/model/models.dart';
import 'package:mvvm_template/domain/usecase/store_details_usecase.dart';
import 'package:mvvm_template/presentation/base/base_viewmodel.dart';
import 'package:mvvm_template/presentation/common/state_renderer/state_renderer.dart';
import 'package:mvvm_template/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class StoreDetailsViewModel extends BaseViewModel
    implements StoreDetailsViewModelInputs, StoreDetailsViewModelOutputs {
  final StoreDetailsUseCase _storeDetailsUseCase;

  StoreDetailsViewModel(this._storeDetailsUseCase);

  // Stream controllers
  final StreamController _storeDetailsDataStreamController =
      BehaviorSubject<StoreDetails>();
  @override
  void start() {
    _getStoreDetails();
  }

  // Inputs
  @override
  Sink get inputStoreDetails => _storeDetailsDataStreamController.sink;

  void _getStoreDetails() async {
    inputState.add(
      LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState,
      ),
    );
    (await _storeDetailsUseCase.execute(Void)).fold((failure) {
      inputState.add(
        ErrorState(
          stateRendererType: StateRendererType.fullScreenErrorState,
          message: failure.message,
        ),
      );
    }, (storeDetailsObject) {
      inputState.add(ContentState());
      inputStoreDetails.add(storeDetailsObject);
    });
  }

  // Outputs
  @override
  Stream<StoreDetails> get outputStoreDetails =>
      _storeDetailsDataStreamController.stream
          .map((storeDetails) => storeDetails);

  @override
  void dispose() {
    _storeDetailsDataStreamController.close();
    super.dispose();
  }
}

abstract class StoreDetailsViewModelInputs {
  Sink get inputStoreDetails;
}

abstract class StoreDetailsViewModelOutputs {
  Stream<StoreDetails> get outputStoreDetails;
}
