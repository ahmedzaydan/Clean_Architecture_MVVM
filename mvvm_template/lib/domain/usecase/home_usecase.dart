import 'package:dartz/dartz.dart';
import 'package:mvvm_template/data/network/failure.dart';
import 'package:mvvm_template/domain/usecase/base_usecase.dart';

import '../model/models.dart';
import '../repository/repository.dart';

class HomeUseCase extends BaseUseCase<void, HomeObject> {
  final Repository _repository;

  HomeUseCase(this._repository);
  
  @override
  Future<Either<Failure, HomeObject>> execute(void input) async {
    return await _repository.getHomeData();
  }
}