import 'dart:convert';

import 'package:cuidapet_api/application/exceptions/database_exception.dart';
import 'package:cuidapet_api/application/exceptions/user_exists_exception.dart';
import 'package:cuidapet_api/application/exceptions/user_notfound_exception.dart';
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
    });

    test('Should throw DatabaseExcpetion', () async {
      database.mockQueryException();

      final call = userRepository.createUser;

      expect(() => call(User()), throwsA(isA<DatabaseException>()));
    });

    test('Should throw UserExistsException', () async {
      final excetion = MockMysqlException();

      when(() => excetion.message).thenReturn('usuario.email_UNIQUE');

      database.mockQueryException(excetion);

      final call = userRepository.createUser;

      expect(() => call(User()), throwsA(isA<UserExistsException>()));
    });
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
}
