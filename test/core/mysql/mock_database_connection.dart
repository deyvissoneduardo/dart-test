import 'package:cuidapet_api/application/database/i_database_connection.dart';
import 'package:mocktail/mocktail.dart';

import '_mysql_mocks.dart';

class MockDatabaseConnection extends Mock implements IDatabaseConnection {
  final mysqlConnection = MockMysqlConnection();

  MockDatabaseConnection() {
    when(() => openConnection()).thenAnswer((_) async => mysqlConnection);
  }

  void mockQuery(MockResults mockResults, [List<Object>? params]) {
    when(() => mysqlConnection.query(any(), params ?? any()))
        .thenAnswer((_) async => mockResults);
  }

  void mockQueryException({
    MockMysqlException? mockMysqlException,
    List<Object>? params,
  }) {
    var exception = mockMysqlException;

    if (exception == null) {
      exception = MockMysqlException();
      when(() => exception!.message).thenReturn('Erro mysql generico');
    }

    when(() => mysqlConnection.query(any(), params ?? any()))
        .thenThrow(exception);
  }

  void verifyConnectionClose() =>
      verify(() => mysqlConnection.close()).called(1);

  void verifyQueryCalled({int? called, List<Object>? params}) =>
      verify(() => mysqlConnection.query(any(), params ?? any()))
          .called(called ?? 1);

  void verifyQueryNeverCalled({List<Object>? params}) =>
      verifyNever(() => mysqlConnection.query(any(), params ?? any()));
}
