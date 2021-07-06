import 'package:mongo_dart/mongo_dart.dart' show Db, DbCollection;
class DBConnection {

  static DBConnection _instance;

  final String _host = "elle";
  final String _port = "BXC3LtrS4N2j3Ah2@cluster0.oxady.mongodb.net";
  final String _dbName = "Tocsin";
  Db _db;
  DbCollection _coll;

  static getInstance(){
    if(_instance == null) {
      _instance = DBConnection();
    }
    return _instance;
  }

  Future<Db> getConnection() async{
    if (_db == null){
      try {
        _db = Db(_getConnectionString());
        await _db.open();
      } catch(e){
        print(e);
      }
    }
    return _db;
  }

  _getConnectionString(){
    return "mongodb+srv://$_host:$_port/$_dbName";
  }

  closeConnection() {
    _db.close();
  }

  Future<DbCollection> getCollection(String coll) async {
    try {
      _coll = await DbCollection(_db, coll);
    } catch(e){
      print(e);
    }
    return _coll;
  }

}