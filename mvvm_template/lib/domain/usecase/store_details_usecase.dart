import 'package:dartz/dartz.dart';
import 'package:mvvm_template/data/network/failure.dart';
import 'package:mvvm_template/domain/model/models.dart';
import 'package:mvvm_template/domain/repository/repository.dart';
import 'package:mvvm_template/domain/usecase/base_usecase.dart';

class StoreDetailsUseCase extends BaseUseCase<void, StoreDetails> {
  final Repository _repository;

  StoreDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, StoreDetails>> execute(void input) async {
    return await _repository.getStoreDetails();
  }
}
