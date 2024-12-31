import 'package:postgres/postgres.dart';
import 'package:nexus_finance/models/transaksi_model.dart';

class DatabaseInstance {
  final String host = 'localhost';  // Ganti dengan host PostgreSQL Anda
  final int port = 5432;           // Ganti dengan port PostgreSQL Anda
  final String databaseName = 'nexus_finance';  // Nama database
  final String username = 'postgres';          // Ganti dengan username PostgreSQL Anda
  final String password = '';                  // Ganti dengan password PostgreSQL Anda

  final String namaTabel = 'transaksi';

  final String id = 'id';
  final String type = 'type';
  final String total = 'total';
  final String name = 'name';
  final String createdAt = 'created_at';
  final String updatedAt = 'updated_at';

  PostgreSQLConnection? _connection;

  // Membuka koneksi ke PostgreSQL
  Future<PostgreSQLConnection> _connect() async {
    if (_connection == null || _connection!.isClosed) {
      _connection = PostgreSQLConnection(
        host,
        port,
        databaseName,
        username: username,
        password: password,
      );
      await _connection!.open();
    }
    return _connection!;
  }

  // Mengambil semua data transaksi
  Future<List<TransaksiModel>> getAll() async {
    final conn = await _connect();
    final result = await conn.query('SELECT * FROM $namaTabel');
    return result.map((row) {
      return TransaksiModel.fromJson({
        'id': row[0],
        'name': row[1],
        'type': row[2],
        'total': row[3],
        'created_at': row[4],
        'updated_at': row[5],
      });
    }).toList();
  }

  // Menambahkan transaksi
  Future<int> insert(Map<String, dynamic> row) async {
    final conn = await _connect();
    final query = '''
      INSERT INTO $namaTabel(name, type, total, created_at, updated_at) 
      VALUES (@name, @type, @total, @createdAt, @updatedAt)
    ''';
    await conn.query(query, substitutionValues: {
      'name': row['name'],
      'type': row['type'],
      'total': row['total'],
      'createdAt': row['created_at'],
      'updatedAt': row['updated_at'],
    });
    return 1; // Sukses menambahkan
  }

  // Menghitung total pemasukan
  Future<int> totalPemasukan() async {
    final conn = await _connect();
    final result = await conn.query(
      'SELECT COALESCE(SUM(total), 0) FROM $namaTabel WHERE type = 1',
    );
    return result[0][0] as int;
  }

  // Menghitung total pengeluaran
  Future<int> totalPengeluaran() async {
    final conn = await _connect();
    final result = await conn.query(
      'SELECT COALESCE(SUM(total), 0) FROM $namaTabel WHERE type = 2',
    );
    return result[0][0] as int;
  }

  // Menghapus transaksi berdasarkan ID
  Future<int> hapus(int idTransaksi) async {
    final conn = await _connect();
    final result = await conn.query(
      'DELETE FROM $namaTabel WHERE $id = @idTransaksi',
      substitutionValues: {'idTransaksi': idTransaksi},
    );
    return result.affectedRowCount ?? 0;
  }

  // Memperbarui transaksi berdasarkan ID
  Future<int> update(int idTransaksi, Map<String, dynamic> row) async {
    final conn = await _connect();
    final query = '''
      UPDATE $namaTabel 
      SET name = @name, type = @type, total = @total, updated_at = @updatedAt 
      WHERE $id = @idTransaksi
    ''';
    final result = await conn.query(query, substitutionValues: {
      'name': row['name'],
      'type': row['type'],
      'total': row['total'],
      'updatedAt': row['updated_at'],
      'idTransaksi': idTransaksi,
    });
    return result.affectedRowCount ?? 0;
  }

  // Menutup koneksi PostgreSQL
  Future<void> closeConnection() async {
    if (_connection != null && !_connection!.isClosed) {
      await _connection!.close();
    }
  }
}
