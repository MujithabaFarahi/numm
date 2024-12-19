import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addItem(Map<String, dynamic> itemInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Bags")
        .doc(id)
        .set(itemInfoMap);
  }

  Stream<QuerySnapshot> getAllItems() {
    return FirebaseFirestore.instance
        .collection("Bags")
        .snapshots(includeMetadataChanges: true);
  }

  Stream<QuerySnapshot> getItemsByGarment(String garment) {
    return FirebaseFirestore.instance
        .collection("Bags")
        .where("garment", isEqualTo: garment)
        .snapshots(includeMetadataChanges: true);
  }
}
