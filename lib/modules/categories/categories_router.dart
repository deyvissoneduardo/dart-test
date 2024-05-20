import '../../application/routers/i_router.dart';
import 'controller/categories_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/src/router.dart';

class CategoriesRouter implements IRouter {
  @override
  void configure(Router router) {
    final categoryController = GetIt.I.get<CategoriesController>();
    router.mount('/categories/', categoryController.router);
  }
}
