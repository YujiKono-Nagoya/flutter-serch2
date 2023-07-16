import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_serch/model.dart';

// const List<book> bookList = [
//   book(
//     id: 0,
//     title: '概念記法',
//     content:
//         '本書は、アリストテレス以来の論理学を根本的に革新し、現代論理学と現代哲学への道を切り拓いた記念碑的著作である。フレーゲの目的は算術を基礎づけることにあり、そのために新しい論理学を作り出した。',
//     auther: 'ゴットローブ・フレーゲ',
//     genre: '人文・思想',
//   ),
//   book(
//     id: 1,
//     title: 'スレイマーンの冠',
//     content:
//         'フランスの宝石商が、17世紀ペルシアの王位継承の世紀末に関する宮廷史家の記録を、自らの見聞も支えて伝える。さまざまな思惑、渦巻く権謀を生き生きと描く、興味津津たる貴重史科。',
//     auther: 'ジャン・シャルダン',
//     genre: '歴史・地理',
//   ),
//   book(
//     id: 2,
//     title: '蝸牛考',
//     content:
//         '蝸牛を表す方言は、京都を中心としてデデムシ→ナメクジのように日本列島を同心円状に分布する。それはこの謎が歴史的に同心円の外側から内側に向かって順次変化してきたからだ、と柳田國男は推定した。',
//     auther: '柳田國男',
//     genre: '人文・思想',
//   ),
//   book(
//     id: 3,
//     title: '個と宇宙',
//     content:
//         '「省庁形式の哲学」や「人間」等で著名な20世紀哲学の巨匠が、「自然認識」問題を基礎に備えて個性的統一体としてのルネサンス哲学の全体像を描き出した名著。多様で複雑なルネサンス哲学の構造と展開が、時代の精神史的・文化史的文脈に位置付け浮き彫りにされている。',
//     auther: 'エルンスト・カッシーラー',
//     genre: '人文・思想',
//   )
// ];

final StateProvider<List<int>> serchIndexListProvider = StateProvider((ref) {
  return [];
});

final booksProvider = StreamProvider<List<Book>>((ref) {
  final selectedValue = ref.watch(selectedValueProvider);

  CollectionReference<Book> bookRef =
      FirebaseFirestore.instance.collection('book').withConverter<Book>(
            fromFirestore: (snapshots, _) {
              final data = snapshots.data();
              if (data != null) {
                return Book.fromJson(data);
              } else {
                // エラー処理
                throw Exception('Firestore data is null.');
              }
            },
            toFirestore: (bookmodel, _) => bookmodel.toJson(),
          );

  Stream<QuerySnapshot<Book>> stream;

  if (selectedValue != '指定なし') {
    stream = bookRef.where('genre', isEqualTo: selectedValue).snapshots();
  } else {
    stream = bookRef.snapshots();
  }

  return stream.map(
      (querySnapshot) => querySnapshot.docs.map((doc) => doc.data()).toList());
});

final selectedValueProvider = StateProvider<String?>((ref) {
  return '指定なし';
});

final keywordProvider = StateProvider<String?>((ref) {
  return '';
});
