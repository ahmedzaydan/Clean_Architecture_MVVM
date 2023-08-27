import 'package:mvvm_template/presentation/common/state_renderer/state_renderer.dart';
import 'package:mvvm_template/presentation/resources/strings_manager.dart';

// This class is like controller between view and StateRenderer class
// View --> ViewModel --> StateRendererImpl --> StateRenderer
// View <-- ViewModel <-- StateRendererImpl <-- StateRenderer

abstract class FlowState {
  StateRendererType getStateRendererType();
  String getMessage();
}

// Loading state (popup, full)
class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  LoadingState({
    required this.stateRendererType,
    this.message = AppStrings.loading,
  });

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// Error state (popup, full)
class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  ErrorState({
    required this.stateRendererType,
    required this.message,
  });

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// Content state
class ContentState extends FlowState {
  @override
  String getMessage() => AppStrings.empty;

  @override
  StateRendererType getStateRendererType() => StateRendererType.contentState;
}

// Empty state
class EmptyState extends FlowState {
  String message;
  EmptyState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.fullScreenEmptyState;
}

// Success state
class SuccessState extends FlowState {
  String message;
  SuccessState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.popupSuccessState;
}
