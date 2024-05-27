import 'dart:convert';

import 'package:cuidapet_api/application/exceptions/database_exception.dart';
import 'package:cuidapet_api/application/exceptions/user_exists_exception.dart';
import 'package:cuidapet_api/application/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/application/helpers/cripty_helper.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/user_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../core/fixture/fixture_reader.dart';
import '../../../core/log/mock_logger.dart';
import '../../../core/mysql/_mysql_mocks.dart';

void main() {
  late MockDatabaseConnection database;
  late ILogger log;
  late UserRepository userRepository;

  setUp(() {
    database = MockDatabaseConnection();
    log = MockLogger();
    userRepository = UserRepository(connection: database, log: log);
  });

  group('Group test findById', () {
    test('Should return user by Id', () async {
      final userFixtureDB = FixtureReader.getJsonData(
        'modules/user/data/fixture/find_by_id_sucess_fixture.json',
      );

      final mockResults = MockResults(userFixtureDB, [
        'ios_token',
        'android_token',
        'refresh_token',
        'img_avatar',
      ]);

      database.mockQuery(mockResults);

      final userMap = jsonDecode(userFixtureDB);
      final userExpected = User(
        id: userMap['id'],
        email: userMap['email'],
        registerType: userMap['tipo_cadastro'],
        iosToken: userMap['ios_token'],
        androidToken: userMap['android_token'],
        refreshToken: userMap['refresh_token'],
        imageAvatar: userMap['img_avatar'],
        supplierId: userMap['fornecedor_id'],
      );

      final user = await userRepository.findById(1);

      expect(user, isA<User>());
      expect(user, userExpected);
      database.verifyConnectionClose();
    });
    test('Should return exception UserNotFoundException', () async {
      final userId = 1;

      final mockResults = MockResults();

      database.mockQuery(mockResults, [userId]);

      final call = userRepository.findById;

      expect(() => call(userId), throwsA(isA<UserNotfoundException>()));
      await Future.delayed(Duration(seconds: 1));
      database.verifyConnectionClose();
    });
  });

  group('Group test create user', () {
    test('Should create user with suucess', () async {
      final userId = 1;
      final mockResults = MockResults();

      when(() => mockResults.insertId).thenReturn(userId);

      database.mockQuery(mockResults);

      final userInsert = User(
        email: 'eduardo@gmail.com',
        registerType: 'APP',
        imageAvatar: '',
        password: '123123',
      );

      final userExpected = User(
        id: userId,
        email: 'eduardo@gmail.com',
        registerType: 'APP',
        imageAvatar: '',
        password: '',
      );

      final user = await userRepository.createUser(userInsert);

      expect(user, userExpected);
      database.verifyConnectionClose();
    });

    test('Should throw DatabaseExcpetion', () async {
      database.mockQueryException();

      final call = userRepository.createUser;

      expect(() => call(User()), throwsA(isA<DatabaseException>()));
      await Future.delayed(Duration(seconds: 1));
      database.verifyConnectionClose();
    });

    test('Should throw UserExistsException', () async {
      final excetion = MockMysqlException();

      when(() => excetion.message).thenReturn('usuario.email_UNIQUE');

      database.mockQueryException(mockMysqlException: excetion);

      final call = userRepository.createUser;

      expect(() => call(User()), throwsA(isA<UserExistsException>()));
      await Future.delayed(Duration(seconds: 1));
      database.verifyConnectionClose();
    });
  });

  group('Group test login with email and password', () {
    test(
        'Should login with email and password and verify return user is not null',
        () async {
      final userFixtureDB = FixtureReader.getJsonData(
        'modules/user/data/fixture/login_with_email_password_success.json',
      );

      final mockResults = MockResults(userFixtureDB, [
        'ios_token',
        'android_token',
        'refresh_token',
        'img_avatar',
      ]);

      final email = 'eduardo@gmail.com';
      final password = '12qwe';
      database.mockQuery(mockResults, [
        email,
        CriptyHelper.generateSha256Hash(password),
      ]);

      final userMap = jsonDecode(userFixtureDB);
      final userExpected = User(
        id: userMap['id'],
        email: userMap['email'],
        registerType: userMap['tipo_cadastro'],
        iosToken: userMap['ios_token'],
        androidToken: userMap['android_token'],
        refreshToken: userMap['refresh_token'],
        imageAvatar: userMap['img_avatar'],
        supplierId: userMap['fornecedor_id'],
      );

      final user =
          await userRepository.loginWithEmailPassword(email, password, false);

      expect(user, isNotNull);
      expect(user, userExpected);
      database.verifyConnectionClose();
    });

    test(
        'Should login with email and password and return self instance of the user',
        () async {
      final userFixtureDB = FixtureReader.getJsonData(
        'modules/user/data/fixture/login_with_email_password_success.json',
      );

      final mockResults = MockResults(userFixtureDB, [
        'ios_token',
        'android_token',
        'refresh_token',
        'img_avatar',
      ]);

      final email = 'eduardo@gmail.com';
      final password = '12qwe';
      database.mockQuery(mockResults, [
        email,
        CriptyHelper.generateSha256Hash(password),
      ]);

      final userMap = jsonDecode(userFixtureDB);
      final userExpected = User(
        id: userMap['id'],
        email: userMap['email'],
        registerType: userMap['tipo_cadastro'],
        iosToken: userMap['ios_token'],
        androidToken: userMap['android_token'],
        refreshToken: userMap['refresh_token'],
        imageAvatar: userMap['img_avatar'],
        supplierId: userMap['fornecedor_id'],
      );

      final user =
          await userRepository.loginWithEmailPassword(email, password, false);

      expect(user, userExpected);
      database.verifyConnectionClose();
    });

    test('Should return UserNotfoundException', () async {
      final mockResults = MockResults();

      final email = 'eduardo@gmail.com';
      final password = '12qwe';
      database.mockQuery(mockResults, [
        email,
        CriptyHelper.generateSha256Hash(password),
      ]);

      final call = await userRepository.loginWithEmailPassword;

      expect(
        () => call(email, password, false),
        throwsA(isA<UserNotfoundException>()),
      );
      await Future.delayed(Duration(seconds: 1));
      database.verifyConnectionClose();
    });

    test('Should return DatabaseException', () async {
      final email = 'eduardo@gmail.com';
      final password = '12qwe';

      database.mockQueryException(
        params: [
          email,
          CriptyHelper.generateSha256Hash(password),
        ],
      );

      final call = await userRepository.loginWithEmailPassword;

      expect(
        () => call(email, password, false),
        throwsA(isA<DatabaseException>()),
      );
      await Future.delayed(Duration(seconds: 1));
      database.verifyConnectionClose();
    });
  });
}
