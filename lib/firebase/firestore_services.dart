import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:toilet_status_manager/model/toilet.dart';

class FirestoreServices {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _toiletsCollectionReference =
      FirebaseFirestore.instance.collection('toilets');
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

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
        id: documentSnapshot.id,
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
        await _toiletsCollectionReference.add({
      'nickname': nickname,
      'last_user_inside': '',
      'members': [uid]
    });
    await _usersCollectionReference.doc(uid).update({
      'toilet_id': documentReference.id,
    });
  }

  Stream<String> getLastUserInside(String toiletId) async* {
    yield* _toiletsCollectionReference.doc(toiletId).snapshots().map(
        (event) => (event.data() as Map<String, dynamic>)['last_user_inside']);
  }

  Future<void> bookToilet(String toiletId, String uid) async {
    await _toiletsCollectionReference
        .doc(toiletId)
        .update({'last_user_inside': uid});
  }

  Future<void> releaseToilet(String toiletId) async {
    await _toiletsCollectionReference
        .doc(toiletId)
        .update({'last_user_inside': ''});
  }

  Future<void> leaveToilet(String uid, String toiletId) async {
    await _usersCollectionReference.doc(uid).update({'toilet_id': ''});
    //check if last member
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _toiletsCollectionReference.doc(toiletId).get()
            as DocumentSnapshot<Map<String, dynamic>>;
    final List<dynamic> members = documentSnapshot.data()!['members'];
    if (members.length == 1) {
      await _toiletsCollectionReference.doc(toiletId).delete();
    } else {
      await _toiletsCollectionReference.doc(toiletId).update({
        'members': FieldValue.arrayRemove([uid]),
      });
    }
  }

  Future<void> joinToilet(String uid, String toiletId) async {
    await _usersCollectionReference.doc(uid).update({'toilet_id': toiletId});
    await _toiletsCollectionReference.doc(toiletId).update({
      'members': FieldValue.arrayUnion([uid]),
    });
    await _analytics.logEvent(name: 'join_toilet', parameters: {
      'uid': uid,
      'toilet_id': toiletId,
    });
  }

  Future<void> deleteUser(String uid) async {
    await _usersCollectionReference.doc(uid).delete();
  }
}
