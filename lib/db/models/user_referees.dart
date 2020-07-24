import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_referees.g.dart';

@JsonSerializable()
class UserReferees {
  @JsonKey(name: 'user_number', nullable: true)
  int userNumber;
  @JsonKey(name: 'guid', nullable: true)
  String guid;
  @JsonKey(name: 'registered_at', nullable: true)
  int registeredAt;
  @JsonKey(name: 'subscribed_at', nullable: true)
  int subscribedAt;
  @JsonKey(name: 'amount', nullable: true)
  int amount;
  @JsonKey(name: 'type', nullable: true)
  int type;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;

  UserReferees();

  factory UserReferees.fromJson(Map<String, dynamic> json) =>
      _$UserRefereesFromJson(json);
  Map<String, dynamic> toJson() => _$UserRefereesToJson(this);

  CollectionReference getCollectionRef(String userID) {
    return Model.db.collection("users").document(userID).collection('referees');
  }

  Stream<QuerySnapshot> streamReferees(String userID) {
    return getCollectionRef(userID).snapshots();
  }

  Future<UserReferees> getRegistrationBonus(String userID) async {
    QuerySnapshot snap = await getCollectionRef(userID)
        .where('type', isEqualTo: 0)
        .getDocuments();
    if (snap.documents.isEmpty)
      return null;
    else
      return UserReferees.fromJson(snap.documents.first.data);
  }
}
