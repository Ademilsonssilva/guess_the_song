import 'package:flutter/material.dart';

class SearchField1 extends StatefulWidget {
  @override
  _SearchField1State createState() => _SearchField1State();
}

class _SearchField1State extends State<SearchField1> {

  var _search_type_options = ['Album', 'Artist', 'Playlist'];
  String _selected_search_type_option = 'Album';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: TextField(
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

                  },
                )
              ),
            ),
          ),
        ],
      ),
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
}
