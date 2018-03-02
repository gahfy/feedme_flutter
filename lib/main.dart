import 'package:flutter/material.dart';
import 'package:feedme/Post.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new PostPage()
    );
  }
}

class PostPage extends StatefulWidget {
  PostPage({Key key}) : super(key: key);

  @override
  _PostPageState createState() => new _PostPageState();
}

class _PostPageState extends State<PostPage>{
  final PostState postState = new PostState();
  BuildContext context;

  @override
  void initState() {
    super.initState();
    _getPosts();
  }

  _getPosts() async {
    if (!mounted) return;

    await postState.getFromApi();
    setState((){
      if(postState.error){
        _showError();
      }
    });
  }

  _retry(){
    Scaffold.of(context).removeCurrentSnackBar();
    postState.reset();
    setState((){});
    _getPosts();
  }

  void _showError(){
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("An unknown error occurred"),
        duration: new Duration(days: 1), // Make it permanent
        action: new SnackBarAction(
            label : "RETRY",
            onPressed : (){_retry();}
        )
    ));
  }

  Widget _getLoadingStateWidget(){
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

  Widget _getSuccessStateWidget(){
    return new ListView.builder(
        itemCount: postState.posts.length,
        itemBuilder: (context, index) {
          return new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(postState.posts[index].title,
                    style: new TextStyle(fontWeight: FontWeight.bold)),

                new Text(postState.posts[index].body),

                new Divider()
              ]
          );
        }
    );
  }

  Widget _getErrorState(){
    return new Center(
      child: new Row(),
    );
  }

  Widget getCurrentStateWidget(){
    Widget currentStateWidget;
    if(!postState.error && !postState.loading) {
      currentStateWidget = _getSuccessStateWidget();
    }
    else if(!postState.error){
      currentStateWidget = _getLoadingStateWidget();
    }
    else{
      currentStateWidget = _getErrorState();
    }
    return currentStateWidget;
  }

  @override
  Widget build(BuildContext context) {
    Widget currentWidget = getCurrentStateWidget();
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('FeedMe'),
        ),
        body: new Builder(builder: (BuildContext context) {
          this.context = context;
          return currentWidget;
        })
    );
  }
}