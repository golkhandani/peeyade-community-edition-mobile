import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    this.controller,
    this.onSearch,
  }) : super(key: key);

  final TextEditingController? controller;
  final void Function()? onSearch;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  OutlineInputBorder? _border;
  OutlineInputBorder lazyBorder() {
    if (_border == null) {
      _border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide(color: Colors.black, width: 2),
      );
    }
    return _border!;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: MouseRegion(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            height: 48,
            child: TextField(
              controller: widget.controller,
              enabled: true,
              autofocus: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                focusedBorder: lazyBorder(),
                enabledBorder: lazyBorder(),
                disabledBorder: lazyBorder(),
                border: lazyBorder(),
                labelText: 'What are you looking for?',
                labelStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.black,
                ),
                suffix: Container(
                  margin: EdgeInsets.only(bottom: 8),
                  width: 64,
                  child: RawMaterialButton(
                    constraints: BoxConstraints(minHeight: 48),
                    shape: StadiumBorder(),
                    child: Text("search"),
                    onPressed: widget.onSearch,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
