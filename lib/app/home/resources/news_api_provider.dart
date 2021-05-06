import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:tracker_app/app/home/models/item_model.dart';
import 'package:tracker_app/app/home/resources/repository.dart';

final _root = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider implements Source {
  Client client = Client();

  Future<List<int>> fetchTopIds() async {
    final response = await client.get('$_root/topstories.json');
    final ids = jsonDecode(response.body);
    return ids.cast<int>();
  }

  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get('$_root/$id.json');
    final parsedJson = jsonDecode(response.body);
    return ItemModel.fromJson(parsedJson);
  }
}
