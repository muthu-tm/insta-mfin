import 'package:cloud_firestore/cloud_firestore.dart';

class Model {
  static final Firestore db = Firestore.instance;

  static void attachCommonAttributes(data) {
    data['created_at'] = DateTime.now().toString();
    data['updated_at'] = DateTime.now().toString();
  }

  CollectionReference  getCollectionRef() {
    throw new Exception("Should be implemented by subclass");
  }

  DocumentReference getDocumentRef(id) {
    return this.getCollectionRef().document(id);
  }

  add(data) async {
    attachCommonAttributes(data);
    
    return await this.getCollectionRef().document(data['email']).setData(data);
  }

  /* merge fields in the document or create it if it doesn't exists */
  mergeOrInsert(id, data) async {
    attachCommonAttributes(data);

    await this.getDocumentRef(id).setData(data, merge: true);
    return data;
  }

  update(id, data) async {
    data['updated_at'] = DateTime.now().toString();
    await this.getDocumentRef(id).updateData(data);

    return data;
  }

  delete(id) async {
    await this.getDocumentRef(id).delete();

    return true;
  }

  Future<Map<String, dynamic>> getByID(id) async {
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
