import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_serch/model.dart';
import 'package:flutter_serch/pages/add_page.dart';
import 'package:flutter_serch/pages/query.dart';
import 'package:flutter_serch/pages/riverpod/provider.dart';

class Home2 extends ConsumerWidget {
  const Home2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksList = ref.watch(booksProvider);
    final keyword = ref.watch(keywordProvider);
    final serchIndexListNotifier = ref.watch(serchIndexListProvider.notifier);
    final serchIndexList = ref.watch(serchIndexListProvider);
    CollectionReference<Book> bookRef =
        FirebaseFirestore.instance.collection('book').withConverter(
              fromFirestore: (snapshots, _) => Book.fromJson(snapshots.data()!),
              toFirestore: (bookModel, _) => bookModel.toJson(),
            );
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
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot<Book>>(
              stream: bookRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: data.docs.length,
                        itemBuilder: (context, index) {
                          return UserCard(bookModel: data.docs[index].data());
                        }),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddPage()));
      }),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({Key? key, required this.bookModel}) : super(key: key);

  final Book bookModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Text('名前:${bookModel.author}'),
      ),
    );
  }
}
