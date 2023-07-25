import 'package:cloud_firestore/cloud_firestore.dart';


class FossilService {

  final CollectionReference _fossilCollectionRef =
  FirebaseFirestore.instance.collection('Fossils');

  Future<List<QueryDocumentSnapshot>> getFossils() async {
    var value = await _fossilCollectionRef.get();
    return value.docs;
  }




}