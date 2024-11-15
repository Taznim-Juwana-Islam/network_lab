import 'package:flutter/material.dart';
import 'http_service.dart';
import 'chopper_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Networking Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<dynamic>> futurePostsHttp;
  late Future<List<dynamic>> futurePostsChopper;

  @override
  void initState() {
    super.initState();
    futurePostsHttp = fetchPostsUsingHttp();
    final postService = PostService.create();
    futurePostsChopper = fetchPostsUsingChopper(postService);
  }

  // Fetch posts using Chopper
  Future<List<dynamic>> fetchPostsUsingChopper(PostService service) async {
    final response = await service.getPosts();
    if (response.isSuccessful) {
      return response.body as List<dynamic>;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Networking Demo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HTTP Data Display
            FutureBuilder<List<dynamic>>(
              future: futurePostsHttp,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final posts = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(posts[index]['title']),
                        subtitle: Text(posts[index]['body']),
                      );
                    },
                  );
                }
                return Center(child: Text('No data available'));
              },
            ),
            Divider(),
            // Chopper Data Display
            FutureBuilder<List<dynamic>>(
              future: futurePostsChopper,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final posts = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(posts[index]['title']),
                        subtitle: Text(posts[index]['body']),
                      );
                    },
                  );
                }
                return Center(child: Text('No data available'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
