import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toilet_status_manager/model/toilet.dart';

class FirestoreServices {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _toiletsCollectionReference =
      FirebaseFirestore.instance.collection('toilets');

  Future<String> getToiletId(String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _usersCollectionReference.doc(uid).get()
            as DocumentSnapshot<Map<String, dynamic>>;
    return documentSnapshot.data()!['toilet_id'];
  }

  Future<Toilet?> getToilet(String uid) async {
    return await getToiletId(uid).then((toiletId) async {
      if (toiletId.isEmpty) {
        return null;
      }
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _toiletsCollectionReference.doc(toiletId).get()
              as DocumentSnapshot<Map<String, dynamic>>;
      return Toilet(
        uid: documentSnapshot.id,
        nickname: documentSnapshot.data()!['nickname'],
      );
    });
  }

  Future<void> createUser(String uid) async {
    await _usersCollectionReference.doc(uid).set({'toilet_id': ''});
  }

  Future<bool> checkIfUserExists(String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _usersCollectionReference.doc(uid).get()
            as DocumentSnapshot<Map<String, dynamic>>;
    return documentSnapshot.exists;
  }

  Future<void> createToilet(String uid, String nickname) async {
    final DocumentReference documentReference =
        await _toiletsCollectionReference
            .add({'nickname': nickname, 'status': false});
    await _usersCollectionReference.doc(uid).update({
      'toilet_id': documentReference.id,
    });
  }

  Stream<bool> getToiletStatus(String uid) async* {
    final String toiletId = await getToiletId(uid);
    yield* _toiletsCollectionReference
        .doc(toiletId)
        .snapshots()
        .map((event) => (event.data() as Map<String, dynamic>)['status']);
  }
}
