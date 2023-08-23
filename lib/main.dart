import 'package:flutter/material.dart';
import 'package:flutter_api/apiprovider.dart';
import 'package:provider/provider.dart';

import 'album.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Provider<AlbumApiServices>(
          create: (context) => AlbumApiServices(),
          child: const MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Album>> listAlbum;
  int _counter = 0;
  late AlbumApiServices albumApiServices;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    listAlbum = context.read<AlbumApiServices>().fetchAlbum();
  }

  void _incrementCounter() {
    listAlbum = albumApiServices.fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FutureBuilder(
              future: listAlbum,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.connectionState == ConnectionState.active) {
                  return CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return Text("Click here to load data");
                } else {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Album album = snapshot.data![index];
                        return ListTile(
                          leading: Text(album.title),
                        );
                      },
                    );
                  } else {
                    return Text("Something wrong");
                  }
                }
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
