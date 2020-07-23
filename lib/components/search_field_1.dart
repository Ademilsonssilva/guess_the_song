import 'dart:convert';
import 'package:guess_the_song/model/album.dart';
import 'package:guess_the_song/model/game_mode_option.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchField1 extends StatefulWidget {
  @override
  _SearchField1State createState() => _SearchField1State();
}

class _SearchField1State extends State<SearchField1> {

  var _search_type_options = ['album', 'artist', 'playlist'];
  String _selected_search_type_option = 'album';

  static final String _deezer_api_base_path = "https://api.deezer.com/";
  static final String _deezer_api_search_path = _deezer_api_base_path + "search/";

  List _search_result;

  TextEditingController _search_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _search_controller,
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
      )
    );
  }

  Widget _createListView(BuildContext context, AsyncSnapshot snapshot) {
    return ListView.builder(
        itemCount: _search_result.length,
        itemBuilder: (context, index) {
          print(snapshot.data[index]);
          return snapshot.data[index].getListTile();
//          return ListTile(
//            title: Text(snapshot.data[index].toString()),
//          );
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

    String search = _deezer_api_search_path + _selected_search_type_option + '?q="' + _search_controller.text +'"';

    final response = await http.get(search);

    List<GameModeOption> options = List<GameModeOption>();

    if (response.statusCode == 200) {

      List<dynamic> raw_result = json.decode(response.body)["data"];

      raw_result.asMap().forEach((key, value) {
        GameModeOption option = GameModeOption.create(_selected_search_type_option, value);
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
