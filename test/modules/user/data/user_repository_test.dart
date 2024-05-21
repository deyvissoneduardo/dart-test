import 'package:cuidapet_api/application/database/i_database_connection.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/user_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mysql1/mysql1.dart';
import 'package:test/test.dart';

import '../../../core/log/mock_logger.dart';
import '../../../core/mysql/mock_database_connection.dart';
import '../../../core/mysql/mock_mysql_connection.dart';
import '../../../core/mysql/mock_result.dart';
import '../../../core/mysql/mock_result_row.dart';

void main() {
  late IDatabaseConnection databaseConnection;
  late ILogger logger;
  late MockMysqlConnection mysqlConnection;
  late Results mysqlResults;
  late ResultRow mysqlResultRow;

  setUp(() {
    databaseConnection = MockDatabaseConnection();
    logger = MockLogger();
    mysqlConnection = MockMysqlConnection();
    mysqlResults = MockResult();
    mysqlResultRow = MockResultRow();
  });

  group('Group test findById', () {
    test('Should return user by Id', () async {
      final userRepository = UserRepository(
        connection: databaseConnection,
        log: logger,
      );

      when(() => databaseConnection.openConnection())
          .thenAnswer((_) async => mysqlConnection);

      when(() => mysqlConnection.query(any(), any()))
          .thenAnswer((_) async => mysqlResults);
      when(() => mysqlResults.isEmpty).thenReturn(false);

      when(() => mysqlResults.first).thenReturn(mysqlResultRow);

      when(() => mysqlResultRow['id']).thenAnswer((_) => 1);

      when(() => mysqlConnection.close()).thenAnswer((_) async => _);

      final user = await userRepository.findById(1);

      expect(user, isA<User>());
      expect(user.id, 1);
    });
  });
}
