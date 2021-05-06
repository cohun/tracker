import 'package:flutter/material.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top News'),
      ),
      body: Center(
        child: buildList(),
      ),
    );
  }

  Widget buildList() {
    return ListView.builder(
        itemCount: 1000,
        itemBuilder: (context, index) {
          return FutureBuilder(
            future: getFuture(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Card(child: ListTile(title: Text('Im visible')))
                  : Text('I havent fetched data yet');
            },
          );
        });
  }

  getFuture() {
    return Future.delayed(
      Duration(seconds: 2),
      () => 'hi',
    );
  }
}
