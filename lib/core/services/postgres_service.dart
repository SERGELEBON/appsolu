/*import 'package:postgres/legacy.dart';


class PostgresService {
  static final PostgresService _instance = PostgresService._internal();
  late PostgreSQLConnection _connection;

  factory PostgresService() {
    return _instance;
  }

  PostgresService._internal();

  Future<void> init() async {
    _connection = PostgreSQLConnection(
      'hostname', // Remplacez par l'hôte de votre serveur PostgreSQL
      5432, // Port par défaut de PostgreSQL
      'databaseName', // Remplacez par le nom de votre base de données
      username: 'username', // Remplacez par votre nom d'utilisateur PostgreSQL
      password: 'password', // Remplacez par votre mot de passe PostgreSQL
    );
    await _connection.open();
  }

  PostgreSQLConnection get connection => _connection;
}
 */