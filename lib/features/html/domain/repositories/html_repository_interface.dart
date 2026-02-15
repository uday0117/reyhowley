import 'package:reyhowley/interfaces/repository_interface.dart';
import 'package:reyhowley/util/html_type.dart';

abstract class HtmlRepositoryInterface extends RepositoryInterface {
  Future<dynamic> getHtmlText(HtmlType htmlType);
}