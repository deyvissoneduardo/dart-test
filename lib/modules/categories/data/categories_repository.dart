import '../../../application/exceptions/database_exception.dart';
import 'package:injectable/injectable.dart';

import '../../../application/database/i_database_connection.dart';
import '../../../application/logger/i_logger.dart';
import '../../../entities/category.dart';
import 'package:mysql1/mysql1.dart';

import './i_categories_repository.dart';

@LazySingleton(as: ICategoriesRepository)
class CategoriesRepository implements ICategoriesRepository {
  IDatabaseConnection connection;
  ILogger log;
  CategoriesRepository({
    required this.connection,
    required this.log,
  });

  @override
  Future<List<Category>> findAll() async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final result = await conn.query('select * from categorias_fornecedor');

      if (result.isNotEmpty) {
        return result
            .map(
              (e) => Category(
                id: e['id'],
                name: e['nome_categoria'],
                type: e['tipo_categoria'],
              ),
            )
            .toList();
      }

      return [];
    } on MySqlException catch (e, s) {
      log.error('Erro ao buscar as categorias do fornecedor', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
