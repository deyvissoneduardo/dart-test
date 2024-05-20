// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../modules/categories/controller/categories_controller.dart' as _i33;
import '../../modules/categories/data/categories_repository.dart' as _i22;
import '../../modules/categories/data/i_categories_repository.dart' as _i21;
import '../../modules/categories/service/categories_service.dart' as _i32;
import '../../modules/categories/service/i_categories_service.dart' as _i31;
import '../../modules/chat/controller/chat_controller.dart' as _i16;
import '../../modules/chat/data/chat_repository.dart' as _i11;
import '../../modules/chat/data/i_chat_repository.dart' as _i10;
import '../../modules/chat/service/chat_service.dart' as _i13;
import '../../modules/chat/service/i_chat_service.dart' as _i12;
import '../../modules/schedules/controller/schedule_controller.dart' as _i29;
import '../../modules/schedules/data/i_schedule_repository.dart' as _i19;
import '../../modules/schedules/data/schedule_repository.dart' as _i20;
import '../../modules/schedules/service/i_schedule_service.dart' as _i27;
import '../../modules/schedules/service/schedule_service.dart' as _i28;
import '../../modules/supplier/controller/supplier_controller.dart' as _i30;
import '../../modules/supplier/data/i_supplier_repository.dart' as _i14;
import '../../modules/supplier/data/supplier_repository.dart' as _i15;
import '../../modules/supplier/service/i_supplier_service.dart' as _i23;
import '../../modules/supplier/service/supplier_service.dart' as _i24;
import '../../modules/user/controller/auth_controller.dart' as _i25;
import '../../modules/user/controller/user_controller.dart' as _i26;
import '../../modules/user/data/i_user_repository.dart' as _i8;
import '../../modules/user/data/user_repository.dart' as _i9;
import '../../modules/user/service/i_user_service.dart' as _i17;
import '../../modules/user/service/user_service.dart' as _i18;
import '../database/database_connection.dart' as _i6;
import '../database/i_database_connection.dart' as _i5;
import '../facades/push_notification_facade.dart' as _i3;
import '../logger/i_logger.dart' as _i4;
import 'database_connection_configuration.dart' as _i7;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.lazySingleton<_i3.PushNotificationFacade>(
      () => _i3.PushNotificationFacade(log: gh<_i4.ILogger>()));
  gh.lazySingleton<_i5.IDatabaseConnection>(
      () => _i6.DatabaseConnection(gh<_i7.DatabaseConnectionConfiguration>()));
  gh.lazySingleton<_i8.IUserRepository>(() => _i9.UserRepository(
        connection: gh<_i5.IDatabaseConnection>(),
        log: gh<_i4.ILogger>(),
      ));
  gh.lazySingleton<_i10.IChatRepository>(() => _i11.ChatRepository(
        connection: gh<_i5.IDatabaseConnection>(),
        log: gh<_i4.ILogger>(),
      ));
  gh.lazySingleton<_i12.IChatService>(() => _i13.ChatService(
        repository: gh<_i10.IChatRepository>(),
        pushNotificationFacade: gh<_i3.PushNotificationFacade>(),
      ));
  gh.lazySingleton<_i14.ISupplierRepository>(() => _i15.SupplierRepository(
        connection: gh<_i5.IDatabaseConnection>(),
        log: gh<_i4.ILogger>(),
      ));
  gh.factory<_i16.ChatController>(() => _i16.ChatController(
        service: gh<_i12.IChatService>(),
        log: gh<_i4.ILogger>(),
      ));
  gh.lazySingleton<_i17.IUserService>(() => _i18.UserService(
        userRepository: gh<_i8.IUserRepository>(),
        log: gh<_i4.ILogger>(),
      ));
  gh.lazySingleton<_i19.IScheduleRepository>(() => _i20.ScheduleRepository(
        connection: gh<_i5.IDatabaseConnection>(),
        log: gh<_i4.ILogger>(),
      ));
  gh.lazySingleton<_i21.ICategoriesRepository>(() => _i22.CategoriesRepository(
        connection: gh<_i5.IDatabaseConnection>(),
        log: gh<_i4.ILogger>(),
      ));
  gh.lazySingleton<_i23.ISupplierService>(() => _i24.SupplierService(
        repository: gh<_i14.ISupplierRepository>(),
        userService: gh<_i17.IUserService>(),
      ));
  gh.factory<_i25.AuthController>(() => _i25.AuthController(
        userService: gh<_i17.IUserService>(),
        log: gh<_i4.ILogger>(),
      ));
  gh.factory<_i26.UserController>(() => _i26.UserController(
        userService: gh<_i17.IUserService>(),
        log: gh<_i4.ILogger>(),
      ));
  gh.lazySingleton<_i27.IScheduleService>(
      () => _i28.ScheduleService(repository: gh<_i19.IScheduleRepository>()));
  gh.factory<_i29.ScheduleController>(() => _i29.ScheduleController(
        service: gh<_i27.IScheduleService>(),
        log: gh<_i4.ILogger>(),
      ));
  gh.factory<_i30.SupplierController>(() => _i30.SupplierController(
        service: gh<_i23.ISupplierService>(),
        log: gh<_i4.ILogger>(),
      ));
  gh.lazySingleton<_i31.ICategoriesService>(() =>
      _i32.CategoriesService(repository: gh<_i21.ICategoriesRepository>()));
  gh.factory<_i33.CategoriesController>(
      () => _i33.CategoriesController(service: gh<_i31.ICategoriesService>()));
  return getIt;
}
