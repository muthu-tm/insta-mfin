import 'package:instamfin/db/models/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ifin_config.g.dart';

class IfinConfig {
  static CollectionReference _configCollRef =
      Model.db.collection("ifin_config");

  @JsonKey(name: 'current_version')
  String cVersion;
  @JsonKey(name: 'min_version')
  String minVersion;
  @JsonKey(name: 'platform')
  String platform;
  @JsonKey(name: 'app_url', nullable: true)
  String appURL;
  @JsonKey(name: 'recharge_enabled', defaultValue: true)
  bool rechargeEnabled;
  @JsonKey(name: 'payment_enabled', defaultValue: true)
  bool payEnabled;

  IfinConfig();

  factory IfinConfig.fromJson(Map<String, dynamic> json) =>
      _$IfinConfigFromJson(json);
  Map<String, dynamic> toJson() => _$IfinConfigToJson(this);

  CollectionReference getCollectionRef() {
    return _configCollRef;
  }

  Future<IfinConfig> getConfigByPlatform(String platform) async {
    List<DocumentSnapshot> docSnapshot = (await getCollectionRef()
            .where('platform', isEqualTo: platform)
            .getDocuments())
        .documents;

    if (docSnapshot.isEmpty) {
      return null;
    }
    IfinConfig conf = IfinConfig.fromJson(docSnapshot.first.data);

    return conf;
  }
}
