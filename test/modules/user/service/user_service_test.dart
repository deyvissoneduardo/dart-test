import 'package:cuidapet_api/application/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/i_user_repository.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:cuidapet_api/modules/user/service/user_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../core/log/mock_logger.dart';
import '../../../core/repository/mock_user_repository.dart';

void main() {
  late IUserRepository userRepository;
  late IUserService userService;
  late ILogger log;

  setUp(() {
    userRepository = MockUserRepository();
    log = MockLogger();
    userService = UserService(userRepository: userRepository, log: log);
    registerFallbackValue(User());
  });

  group('Group test loginWithEmailPassword', () {
    test('Should login e-mail and password', () async {
      final userMockResponse = User(
        id: 1,
        email: 'eduardo@gmail.com',
      );
      final email = 'eduardo@gmail.com';
      final password = '123qwe';
      final supplier = false;

      when(
        () => userRepository.loginWithEmailPassword(email, password, supplier),
      ).thenAnswer((_) async => userMockResponse);

      final user =
          await userService.loginWithEmailPassword(email, password, supplier);

      expect(user, userMockResponse);
      verify(
        () => userRepository.loginWithEmailPassword(email, password, supplier),
      ).called(1);
    });

    test('Should login e-mail and password and return UserNotFoundException',
        () async {
      final email = 'eduardo@gmail.com';
      final password = '123qwe';
      final supplier = false;

      when(
        () => userRepository.loginWithEmailPassword(email, password, supplier),
      ).thenThrow(UserNotfoundException(message: 'User Not Found'));

      final call = await userService.loginWithEmailPassword;

      expect(
        () => call(email, password, supplier),
        throwsA(isA<UserNotfoundException>()),
      );
      verify(
        () => userRepository.loginWithEmailPassword(email, password, supplier),
      ).called(1);
    });
  });

  group('Group test loginWithSocial', () {
    test('Should login Social with success', () async {
      final email = 'eduardo@gmail.com';
      final socialType = '123';
      final socialKey = 'Facebook';

      final userReturn = User(
        id: 1,
        email: email,
        socialKey: socialKey,
      );
      when(
        () =>
            userRepository.loginByEmailSocialKey(email, socialKey, socialType),
      ).thenAnswer((_) async => userReturn);

      final user = await userService.loginWithSocial(
        email,
        'avatar',
        socialType,
        socialKey,
      );

      expect(user, userReturn);
      verify(
        () => userRepository.loginByEmailSocialKey(
          email,
          socialKey,
          socialType,
        ),
      ).called(1);
    });

    test('Should login Social with user not found and create a new user',
        () async {
      final email = 'eduardo@gmail.com';
      final socialType = '123';
      final socialKey = 'Facebook';

      final userCreated = User(
        id: 1,
        email: email,
        socialKey: socialKey,
        registerType: socialType,
      );

      when(
        () =>
            userRepository.loginByEmailSocialKey(email, socialKey, socialType),
      ).thenThrow(UserNotfoundException(message: 'User not found!'));

      when(() => userRepository.createUser(any<User>()))
          .thenAnswer((_) async => userCreated);

      final user = await userService.loginWithSocial(
        email,
        'avatar',
        socialType,
        socialKey,
      );

      expect(user, userCreated);
      verify(
        () =>
            userRepository.loginByEmailSocialKey(email, socialKey, socialType),
      ).called(1);
      verify(
        () => userRepository.createUser(any<User>()),
      ).called(1);
    });
  });
}
