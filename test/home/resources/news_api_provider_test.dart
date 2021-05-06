import 'package:tracker_app/app/home/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test('FetchTopIds return a list of ids', () async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      return Response(jsonEncode([1, 2, 3, 4]), 200);
    });
    final ids = await newsApi.fetchTopIds();
    expect(ids, [1, 2, 3, 4]);
  });
  test('FetchItem returns a item model', () async {
    final jsonMap = {'id': 123};
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      return Response(jsonEncode(jsonMap), 200);
    });
    final parsedJson = await newsApi.fetchItem(1);
    expect(parsedJson.id, 123);
  });
}
