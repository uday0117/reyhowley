import 'package:reyhowley/common/enums/data_source_enum.dart';
import 'package:reyhowley/features/home/domain/models/advertisement_model.dart';
import 'package:reyhowley/interfaces/repository_interface.dart';

abstract class AdvertisementRepositoryInterface extends RepositoryInterface{
  @override
  Future<List<AdvertisementModel>?> getList({int? offset, DataSourceEnum source = DataSourceEnum.client});
}