import 'dart:io';
import 'dart:async';

import 'dart:convert';

class Post {
  final int userId;

  final int id;

  final String title;

  final String body;

  Post({
    this.userId,
    this.id,
    this.title,
    this.body
  });

  static List<Post> fromJsonArray(String jsonArrayString){
    List data = JSON.decode(jsonArrayString);
    List<Post> result = [];
    for(var i=0; i<data.length; i++){
      result.add(new Post(
          userId: data[i]["userId"],
          id: data[i]["id"],
          title: data[i]["title"],
          body: data[i]["body"]
      ));
    }
    return result;
  }
}

class PostState{
  List<Post> posts;
  bool loading;
  bool error;

  PostState({
    this.posts = const [],
    this.loading = true,
    this.error = false,
  });

  void reset(){
    this.posts = [];
    this.loading = true;
    this.error = false;
  }

  Future<void> getFromApi() async{
    try {
      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        this.posts = Post.fromJsonArray(json);
        this.loading = false;
        this.error = false;
      }
      else{
        this.posts = [];
        this.loading = false;
        this.error = true;
      }
    } catch (exception) {
      this.posts = [];
      this.loading = false;
      this.error = true;
    }
  }
}