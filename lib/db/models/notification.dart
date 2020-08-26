import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification extends Model {
  static CollectionReference _notificationCollRef =
      Model.db.collection("notifications");

  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'created_by', nullable: true)
  String createdBy;
  @JsonKey(name: 'user_number', nullable: true)
  int userNumber;
  @JsonKey(name: 'type', nullable: true)
  int type;
  @JsonKey(name: 'data', nullable: true)
  Map<String, dynamic> data;
  @JsonKey(name: 'title', nullable: true)
  String title;
  @JsonKey(name: 'description', nullable: true)
  String desc;
  @JsonKey(name: 'logo_path', nullable: true)
  String logoPath;
  @JsonKey(name: 'ref_path', nullable: true)
  String refPath;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;

  Notification();

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  CollectionReference getCollectionRef() {
    return _notificationCollRef;
  }

  Query getGroupQuery() {
    return Model.db.collectionGroup('user_notifications');
  }

  DocumentReference getDocumentReference() {
    return getCollectionRef().document();
  }

  create() async {
    this.createdAt = DateTime.now();
    this.financeID = cachedLocalUser.primary.financeID;
    this.createdBy = cachedLocalUser.name;

    await getDocumentReference().setData(this.toJson());
  }

  Stream<QuerySnapshot> streamAllByType(List<int> type) {
    return getCollectionRef()
        .where('type', whereIn: type)
        .where('user_number', isEqualTo: cachedLocalUser.getIntID())
        .snapshots();
  }

  Stream<QuerySnapshot> streamAll() {
    return getCollectionRef()
        .where('user_number', isEqualTo: cachedLocalUser.getIntID())
        .snapshots();
  }
}
