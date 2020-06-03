import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:instamfin/db/models/user.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => new UserService());
}

class UserService {
  final Firestore _db = Firestore.instance;
  final String _collectionName = 'users';
  CollectionReference _ref;

  User cachedUser; //<----- Cached Here

  UserService() {
    this._ref = _db.collection(_collectionName);
  }

  User getCachedUser() {
    return cachedUser;
  }

  void setCachedUser(User user) {
    print("USER STATE chage occurred: " + user.toJson().toString());
    
    this.cachedUser = user;
  }

  Future<User> getUser(String id) async {
    DocumentSnapshot doc = await _ref.document(id).get();

    if (!doc.exists) {
      print("UserService.getUser(): Empty user ($id)");
      return null;
    }

    cachedUser = User.fromJson(doc.data);
    return cachedUser;
  }
}