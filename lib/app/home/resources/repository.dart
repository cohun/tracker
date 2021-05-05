import 'package:tracker_app/app/home/models/item_model.dart';
import 'package:tracker_app/app/home/resources/news_api_provider.dart';
import 'package:tracker_app/app/home/resources/news_db_provider.dart';

class Repository {
  List<Source> sources = <Source>[
    newsDbProvider,
    NewsApiProvider(),
  ];

  List<Cache> caches = <Cache>[
    newsDbProvider,
  ];

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    Source source;
    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }

    for (var cache in caches) {
      cache.addItem(item);
    }
    return item;
  }

  Future<List<int>> fetchTopIds() {
    return sources[1].fetchTopIds();
  }
}

abstract class Source {
  Future<ItemModel> fetchItem(int id);

  Future<List<int>> fetchTopIds();
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
}
