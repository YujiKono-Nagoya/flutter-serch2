import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_serch/model.dart';
import 'package:flutter_serch/pages/add_page.dart';
import 'package:flutter_serch/pages/query.dart';
import 'package:flutter_serch/pages/riverpod/provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksList = ref.watch(booksProvider);
    final keyword = ref.watch(keywordProvider);
    final serchIndexListNotifier = ref.watch(serchIndexListProvider.notifier);
    final serchIndexList = ref.watch(serchIndexListProvider);

    List<Book> filteredBooks = [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: false,
        title: Text('蔵書一覧'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SerchPage()));
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: keyword != ''
          ? booksList.when(
              data: (books) {
                filteredBooks = books
                    .where((element) => element['content'].contains(keyword))
                    .toList();
                return _searchBooks(ref, filteredBooks);
              },
              loading: () => CircularProgressIndicator(),
              error: (error, stackTrace) => Text('Error: $error'),
            )
          : _allbooks(booksList),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddPage()));
      }),
    );
  }

  Widget? _allbooks(AsyncValue<List<Book>> booksList) {
    return booksList.when(
      data: (books) {
        // データが正常に取得された場合の処理
        return ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, int index) {
            Book bookData = books[index];
            return Card(
              child: Column(
                children: [
                  Text(
                    '${bookData['title']}-${bookData['author']}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Text(
                    '${bookData['content']}',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            );
          },
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }

  Widget _searchBooks(
    WidgetRef ref,
    List<Book> filteredBooks,
  ) {
    return ListView.builder(
      itemCount: filteredBooks.length,
      itemBuilder: (context, int index) {
        Book bookData = filteredBooks[index];
        return Card(
          child: Column(
            children: [
              Text(
                '${bookData['title']}-${bookData['author']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Text(
                '${bookData['content']}',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        );
      },
    );
  }
}
