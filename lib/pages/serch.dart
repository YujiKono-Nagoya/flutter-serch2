import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<String> genreList = <String>[
  '指定なし',
  '人文・思想',
  '歴史・地理',
  '科学・工学',
  '文学・評論',
  'アート・建築'
];

final genreProvider = StateProvider<String>((ref) => genreList.first);
final keywordProvider = StateProvider<String>((ref) => '');

class SearchScreen extends ConsumerWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genre = ref.watch(genreProvider.state);
    return Scaffold(
      appBar: AppBar(
        title: const Text('検索条件'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '検索条件',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('ジャンル'),
              DropdownButton<String>(
                value: genre.state,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                underline: Container(
                  height: 2,
                  color: Colors.green,
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  genre.state = value!;
                },
                items: genreList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                'フィルター',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.8,
                child: TextFormField(
                  initialValue: ref.read(keywordProvider),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'キーワード',
                  ),
                  onChanged: (value) =>
                      ref.read(keywordProvider.state).state = value,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
