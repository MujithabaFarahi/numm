import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addItem(Map<String, dynamic> itemInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Bags")
        .doc(id)
        .set(itemInfoMap);
  }

  Future<bool> isNameUnique(String name) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("Bags")
        .where("name", isEqualTo: name)
        .get();

    return querySnapshot.docs.isEmpty;
  }

  Stream<QuerySnapshot> getAllItems() {
    return FirebaseFirestore.instance
        .collection("Bags")
        .orderBy('name')
        .snapshots(includeMetadataChanges: true);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getItemById(String id) {
    return FirebaseFirestore.instance
        .collection("Bags")
        .doc(id)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<QuerySnapshot> getItemsByGarment(String garment) {
    return FirebaseFirestore.instance
        .collection("Bags")
        .where("garment", isEqualTo: garment)
        .orderBy("createdAt", descending: true)
        .snapshots(includeMetadataChanges: true);
  }

  Future updateItem(Map<String, dynamic> updatedData, String id) async {
    return await FirebaseFirestore.instance
        .collection("Bags")
        .doc(id)
        .update(updatedData);
  }

  Future addOrder(Map<String, dynamic> orderInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .doc(id)
        .set(orderInfoMap);
  }

  Stream<QuerySnapshot> getAllOrders() {
    return FirebaseFirestore.instance
        .collection("Orders")
        .orderBy("createdAt", descending: true)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderById(String id) {
    return FirebaseFirestore.instance
        .collection("Orders")
        .doc(id)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<QuerySnapshot> getAllUsers() {
    return FirebaseFirestore.instance
        .collection("Users")
        .snapshots(includeMetadataChanges: true);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserById(String id) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .snapshots(includeMetadataChanges: true);
  }

  Future addReturn(Map<String, dynamic> returnInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .doc(id)
        .set(returnInfoMap);
  }

  Stream<QuerySnapshot> getAllReturns() {
    return FirebaseFirestore.instance
        .collection("Returns")
        .snapshots(includeMetadataChanges: true);
  }

  Stream<QuerySnapshot> getAllBuyings() {
    return FirebaseFirestore.instance
        .collection("Buyings")
        .snapshots(includeMetadataChanges: true);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getBuyingById(String id) {
    return FirebaseFirestore.instance
        .collection("Buyings")
        .doc(id)
        .snapshots(includeMetadataChanges: true);
  }
}
