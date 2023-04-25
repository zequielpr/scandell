import 'package:cloud_firestore/cloud_firestore.dart';

class DBSetting {
  FirebaseFirestore _db;
  DBSetting(this._db);

  void habilitarPersistenciaSinConexion() {
    _db.settings = const Settings(persistenceEnabled: true);
  }

  void setSizeCache() {
    _db.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  void inabilitarAccesoRed() {
    _db.disableNetwork().then((_) {
      // Do offline things
    });
  }

  void habilitarAccesoRed() {
    _db.enableNetwork().then((_) {
      // Back online
    });
  }
}
