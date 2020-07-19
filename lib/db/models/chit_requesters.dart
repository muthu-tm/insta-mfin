import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/chit_fund.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chit_requesters.g.dart';

@JsonSerializable(explicitToJson: true)
class ChitRequesters {
  @JsonKey(name: 'customer_number')
  int custNumber;
  @JsonKey(name: 'chit_number')
  int chitNumber;
  @JsonKey(name: 'requested_at')
  int requestedAt;
  @JsonKey(name: 'requested_chits')
  int requestedChits;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  ChitRequesters();

  factory ChitRequesters.fromJson(Map<String, dynamic> json) =>
      _$ChitRequestersFromJson(json);
  Map<String, dynamic> toJson() => _$ChitRequestersToJson(this);

  CollectionReference getCollectionRef(String financeId, String branchName,
      String subBranchName, String chitID) {
    return ChitFund()
        .getDocumentReference(financeId, branchName, subBranchName, chitID)
        .collection("chit_requesters");
  }

  Future<void> create(bool cAlready, Map<String, dynamic> collDetails) async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();

    try {
      
    } catch (err) {
      print('Chit Requesters CREATE failure:' + err.toString());
      throw err;
    }
  }
}
