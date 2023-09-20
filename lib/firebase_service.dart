import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_serch/model.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Book>> getBooksStream(
      {Query Function(Query)? changeQuery}) {
    Query query = _firestore.collection('book');
    if (changeQuery != null) {
      query = changeQuery(query);
    }
    return query
        .withConverter<Book>(
          fromFirestore: (snapshots, _) => Book.fromJson(snapshots.data()!),
          toFirestore: (books, _) => books.toJson(),
        )
        .snapshots();
  }

  // このように取得するデータをQuerySnapShotからListに変換する方法もあります
  // Stream<List<Book>> getBooksStream(){
  //   final Stream<QuerySnapshot<Book>> snapshots = _firestore.collection('books').withConverter<Book>(
  //     fromFirestore: (snapshots, _) => Book.fromJson(snapshots.data()!),
  //     toFirestore: (book, _) => book.toJson(),
  //   ).snapshots();
  //
  //   return snapshots.map((snapshot){
  //     return snapshot.docs.map((data) => data.data()).toList();
  //   });
  // }

  void addBook(Book books) {
    _firestore
        .collection('books')
        .withConverter<Book>(
          fromFirestore: (snapshots, _) => Book.fromJson(snapshots.data()!),
          toFirestore: (books, _) => books.toJson(),
        )
        .add(books);
  }
}
