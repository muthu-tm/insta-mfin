import 'package:cloud_firestore/cloud_firestore.dart';

class Model {
  static final Firestore db = Firestore.instance;

  CollectionReference  getCollectionRef() {
    throw new Exception("Should be implemented by subclass");
  }

  String  getID() {
    throw new Exception("Should be implemented by subclass");
  }

  DocumentReference getDocumentRef(id) {
    return this.getCollectionRef().document(id);
  }

  add(data) async {
    return await this.getCollectionRef().document(this.getID()).setData(data);
  }

  upsert(data, createdAt) async {
    data['created_at'] = createdAt;
    data['updated_at'] = DateTime.now();

    return await this.getCollectionRef().document(this.getID()).setData(data);
  }

  update(data) async {
    data['updated_at'] = DateTime.now();
    await this.getDocumentRef(this.getID()).updateData(data);

    return data;
  }

  delete(id) async {
    await this.getDocumentRef(id).delete();

    return true;
  }

  Future<Map<String, dynamic>> getByID() async {
    String id = this.getID();
    if (id == "" || id == null) {
      return null;
    }

    DocumentSnapshot _snap = await this.getDocumentRef(id).get();
    if (_snap.exists) {
      return _snap.data;
    }

    return null;
  }
}
