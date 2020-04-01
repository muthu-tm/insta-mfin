import 'package:cloud_firestore/cloud_firestore.dart';

class Model {
  static final Firestore db = Firestore.instance;

  static void attachCommonAttributes(data) {
    data['created_at'] = DateTime.now();
    data['updated_at'] = data['created_at'];
  }

  CollectionReference  getCollectionRef() {
    throw new Exception("Should be implemented by subclass");
  }

  DocumentReference getDocumentRef(id) {
    return this.getCollectionRef().document(id);
  }

  add(data) async {
    attachCommonAttributes(data);

    return await this.getCollectionRef().document(data['id']).setData(data);
  }

  /* merge fields in the document or create it if it doesn't exists */
  mergeOrInsert(id, data) async {
    attachCommonAttributes(data);

    await this.getDocumentRef(id).setData(data, merge: true);
    return data;
  }

  update(id, data) async {
    data['updated_at'] = DateTime.now();
    await this.getDocumentRef(id).updateData(data);

    return data;
  }

  delete(id) async {
    await this.getDocumentRef(id).delete();

    return true;
  }

  Future<Map<String, dynamic>> getByID(id) async {
    if (!id) {
      return null;
    }

    DocumentSnapshot _snap = await this.getDocumentRef(id).get();
    if (_snap.exists) {
      return _snap.data;
    }

    return null;
  }
}
