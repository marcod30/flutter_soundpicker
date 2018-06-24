import 'dart:math';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());
final String title = "Sound Picker";
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sound Picker',
      home: Home(),
    );
  }
}
class Home extends StatefulWidget {
  @override
  createState() => new MyHomePage(title: title);
}

class MyHomePage extends State<Home> {
  final String title;
  final possibleSounds = <WordPair>[];
  final silencedSounds = Set<WordPair>();
  final detectedSounds = Set<WordPair>();
  final selectedSounds = Set<WordPair>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MyHomePage({Key key, this.title});

  @override
  Widget build(BuildContext context){
    final drawer = new Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Sound Picker',
              textAlign: TextAlign.center,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Silenciar sonidos'),
            leading: new Icon(
              Icons.home,
            ),
            onTap: () {
              //ACCIONES
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Sonidos guardados'),
            leading: new Icon(
              Icons.save,
            ),
            onTap: () {
              //ACCIONES
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Asociar dispositivos'),
            leading: new Icon(
              Icons.sync,
            ),
            onTap: () {
              //ACCIONES
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Contactos'),
            leading: new Icon(
              Icons.contacts,
            ),
            onTap: () {
              //ACCIONES
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Ajustes'),
            leading: new Icon(
              Icons.settings,
            ),
            onTap: () {
              //ACCIONES
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
    return Scaffold (
      key: _scaffoldKey,
      appBar: new AppBar(
        title: selectedSounds.isNotEmpty ? Text("") : Text(this.title),
        backgroundColor: selectedSounds.isNotEmpty ? Colors.grey : Colors.blue,
        leading: selectedSounds.isNotEmpty ? new IconButton(
            icon: new Icon(Icons.close),
            onPressed: (){ setState(() {
              selectedSounds.clear();
            });}
        ) : new IconButton(icon: new Icon(Icons.menu), onPressed: (){_scaffoldKey.currentState.openDrawer();}),
        actions: <Widget>[
          selectedSounds.isNotEmpty ? new IconButton(
              icon: new Icon(Icons.swap_horiz),
              onPressed: (){
                setState(() {
                  for(WordPair w in selectedSounds){
                    if(silencedSounds.contains(w)){
                      silencedSounds.remove(w);
                      detectedSounds.add(w);
                    }
                    else if(detectedSounds.contains(w)){
                      detectedSounds.remove(w);
                      silencedSounds.add(w);
                    }
                  }
                  selectedSounds.clear();
                });
              }
          ) : new Container(),
        ],
      ),
      drawer: drawer,
      body: _showSounds(),
    );
  }

  Widget _showSounds() {
    possibleSounds.addAll(generateWordPairs().take(100));
    return ListTileTheme (
    child: new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if(i.isOdd){
          return new Divider();
        }
        if(i ~/ 2 < 10){
          detectedSounds.add(possibleSounds[i ~/ 2]);
          return _createSoundRow(possibleSounds[i ~/ 2]);
        }
        else return null;
      },
    )
    );
  }
  Widget _createSoundRow(WordPair sound){
    final isSilenced = silencedSounds.contains(sound);
    return new ListTile(
      title: new Text(
        sound.asUpperCase,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: new Icon(
        isSilenced ? Icons.volume_off : Icons.volume_up,
        color: Colors.black,
      ),

      selected: selectedSounds.contains(sound),
      onTap: () {
        setState(() {
          if(selectedSounds.isEmpty){
            if (isSilenced){
              detectedSounds.add(sound);
              silencedSounds.remove(sound);
            } else {
              silencedSounds.add(sound);
              detectedSounds.remove(sound);
            }
          }
          else{
            if(selectedSounds.contains(sound))
              selectedSounds.remove(sound);
            else
              selectedSounds.add(sound);
          }
        });
      },
      onLongPress: (){
        setState(() {
          if(selectedSounds.isEmpty)
          selectedSounds.add(sound);
        });
      },
    );
  }
}
/*
class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords>{
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  void _pushSaved(){
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
                (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile
              .divideTiles(
            context: context,
            tiles: tiles,
          )
              .toList();
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.menu), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
  Widget _buildSuggestions(){
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // The itemBuilder callback is called once per suggested word pairing,
        // and places each suggestion into a ListTile row.
        // For even rows, the function adds a ListTile row for the word pairing.
        // For odd rows, the function adds a Divider widget to visually
        // separate the entries. Note that the divider may be difficult
        // to see on smaller devices.
        itemBuilder: (context, i) {
          // Add a one-pixel-high divider widget before each row in theListView.
          if (i.isOdd) return new Divider();

          // The syntax "i ~/ 2" divides i by 2 and returns an integer result.
          // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          // This calculates the actual number of word pairings in the ListView,
          // minus the divider widgets.
          final index = i ~/ 2;
          // If you've reached the end of the available word pairings...
          if (index >= _suggestions.length) {
            // ...then generate 10 more and add them to the suggestions list.
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        }
    );
  }
  Widget _buildRow(WordPair pair){
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved){
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}
*/