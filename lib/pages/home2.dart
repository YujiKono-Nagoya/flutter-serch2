import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_serch/firebase_options.dart';
import 'package:flutter_serch/firebase_service.dart';
import 'package:flutter_serch/pages/home.dart';
import 'package:flutter_serch/pages/serch.dart';

final booksStreamProvider = StreamProvider((ref) {
  final genre = ref.watch(genreProvider);
  if (genre != '指定なし') {
    return FirestoreService().getBooksStream(changeQuery: (query) {
      return query.where('genre', isEqualTo: genre);
    });
  } else {
    return FirestoreService().getBooksStream();
  }
});

class Home2 extends ConsumerWidget {
  const Home2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('蔵書一覧'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchScreen()));
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer(
          builder: (context, ref, child) {
            final books = ref.watch(booksStreamProvider);
            final keyword = ref.watch(keywordProvider);
            return books.when(
                data: (data) {
                  final docs = data.docs
                      .where((element) =>
                          (element.data().content.contains(keyword)) ||
                          (element.data().title.contains(keyword)))
                      .toList();
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final book = docs[index].data();
                      return Card(
                          child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Text(
                                  '${book.title} - ${book.author}',
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                                //Icon(Icons.star_border, color: Colors.yellow,),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              book.content,
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                color: Color(0xff666666),
                              ),
                            ),
                          ],
                        ),
                      ));
                    },
                  );
                },
                error: (err, stack) => const Center(
                      child: Text('データを取得できませんでした'),
                    ),
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ));
          },
        ),
      ),
    );
  }
}
