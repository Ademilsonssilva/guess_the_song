import 'package:flutter/material.dart';
import 'package:guess_the_song/model/repository.dart';
import 'package:guess_the_song/tabs/new_game_choose_match_configs.dart';
import 'package:guess_the_song/utils/deezer.dart';
import 'package:guess_the_song/utils/session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:percent_indicator/percent_indicator.dart';

class NewGameChooseMusicRepositoryTab extends StatefulWidget {

  static final tabNumber = 2;
  final PageController controller;

  NewGameChooseMusicRepositoryTab(this.controller);


  @override
  _NewGameChooseMusicRepositoryTabState createState() => _NewGameChooseMusicRepositoryTabState();
}

class _NewGameChooseMusicRepositoryTabState extends State<NewGameChooseMusicRepositoryTab> {

  var _search_type_options = ['album', 'artist', 'playlist'];
  String _selected_search_type_option = 'album';

  static final String _deezer_api_base_path = "https://api.deezer.com/";
  static final String _deezer_api_search_path = _deezer_api_base_path + "search/";

  List<Repository> options;

  List _search_result;

  int selectedIndex;

  TextEditingController _search_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(Session.new_match);
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Center(
            child: Text(
              "Criando sua partida...",
              style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: LinearPercentIndicator(
              progressColor: Theme.of(context).primaryColor,
              percent: 0.66,
              padding: EdgeInsets.all(30),
              lineHeight: 20,
              center: Text("50%", style: TextStyle(color: Colors.black, fontSize: 20),),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _search_controller,
                onSubmitted: (submit) {
                  setState(() {
                    print('submitou');
                    search();
                  });
                },
                decoration: InputDecoration(
                    prefix: Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: getSearchTypeOptionsCombobox(),
                    ),
                    labelText: Text("Select artist, album or playlist").data,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.send,
                      ),
                      onPressed: () {
                        setState(() {
                          search();
                        });
                        //print("hello bitches");
                      },
                    )
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder(
            future: search(),
            builder: (context, snapshot) {
              switch(snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Container(
                    width: 200.0,
                    height: 200.0,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      strokeWidth: 5.0,
                    ),
                  );
                default:
                  if (snapshot.hasError) return Container();
                  else {
                    return _createListView(context, snapshot);
                  }
              }
            },
          ),
        )
      ],
    );
  }

  Widget _createListView(BuildContext context, AsyncSnapshot snapshot) {
    return ListView.builder(
        itemCount: _search_result.length,
        itemBuilder: (context, index) {
//          print(snapshot.data[index]);
          return GestureDetector(
            child: Card(
              color: selectedIndex == index ? Colors.greenAccent : Colors.white,
              child: snapshot.data[index].getListTile(context)
            ),
            onTap: () {

              if (selectedIndex == index) {
                Session.new_match.repository_type = _selected_search_type_option;
                Session.new_match.repository = options[index];

                Deezer.getTrackList(Session.new_match.repository_type, Session.new_match.repository.id.toString()).then((tracklist) {
                  Session.new_match.repository.track_count = tracklist.length;

                  Session.new_match.repository.tracklist = tracklist;

                  Session.new_match.track_count = tracklist.length;

                  widget.controller.jumpToPage(NewGameChooseMatchConfigs.tabNumber);

                });
              }
              else {
                print(options[index]);
                setState(() {
                  selectedIndex = index;
                });
              }
            },
          );

        }
    );
  }

  Widget getSearchTypeOptionsCombobox()
  {
    return DropdownButton<String> (
      items: _search_type_options.map((String dropDownStringItem) {
        return DropdownMenuItem<String> (
          value: dropDownStringItem,
          child: Text(dropDownStringItem),
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          _selected_search_type_option = val;
        });
      },
      value: _selected_search_type_option,
    );
  }

  Future<List> search() async {

    if (_search_controller.text == '') {
      _search_result = [];
      return Future.value([]);
    }

    String search = _deezer_api_search_path + _selected_search_type_option + '?q="' + _search_controller.text +'"';

    final response = await http.get(search);

    options = List<Repository>();

    if (response.statusCode == 200) {

      List<dynamic> raw_result = json.decode(response.body)["data"];

      raw_result.asMap().forEach((key, value) {

//        print(value);
        Repository option = Repository.create(_selected_search_type_option, value);
        options.add(option);
      });

      _search_result = options;

      return options;

    }
    else {
      throw Exception("Something went wrong");
    }
  }

}
