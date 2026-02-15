import 'package:reyhowley/common/enums/data_source_enum.dart';
import 'package:reyhowley/features/brands/domain/models/brands_model.dart';
import 'package:reyhowley/features/item/domain/models/item_model.dart';
import 'package:reyhowley/interfaces/repository_interface.dart';

abstract class BrandsRepositoryInterface extends RepositoryInterface {
  Future<ItemModel?> getBrandItemList({required int brandId, int? offset});
  Future<List<BrandModel>?> getBrandList({required DataSourceEnum source});
}