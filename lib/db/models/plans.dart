import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'plans.g.dart';

@JsonSerializable()
class Plans extends Model {
  static CollectionReference _plansCollRef = Model.db.collection("plans");

  @JsonKey(name: 'allowed_sms_credits', defaultValue: 0)
  int smsCredits;
  @JsonKey(name: 'inr', defaultValue: 0)
  int inr;
  @JsonKey(name: 'notes', defaultValue: '')
  String notes;
  @JsonKey(name: 'plan_id', defaultValue: 0)
  int planID;
  @JsonKey(name: 'plan_name', defaultValue: 0)
  String name;
  @JsonKey(name: 'plan_type', defaultValue: 0)
  String type;
  @JsonKey(name: 'valid_for', defaultValue: 0)
  int validFor;

  Plans();

  factory Plans.fromJson(Map<String, dynamic> json) => _$PlansFromJson(json);
  Map<String, dynamic> toJson() => _$PlansToJson(this);

  CollectionReference getCollectionRef() {
    return _plansCollRef;
  }

  Future<List<Plans>> getAllPlans() async {
    try {
      QuerySnapshot plansSnap =
          await getCollectionRef().orderBy('plan_id').getDocuments();

      List<Plans> plans = [];

      if (plansSnap.documents.isNotEmpty) {
        plansSnap.documents.forEach((p) {
          Plans plan = Plans.fromJson(p.data);
          if (plan.planID != 0 && plan.planID != 100)
            plans.add(Plans.fromJson(p.data));
        });
      }

      return plans;
    } catch (err) {
      print(err.toString());
      throw err;
    }
  }
}
