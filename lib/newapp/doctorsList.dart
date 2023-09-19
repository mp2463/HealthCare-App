import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app/newapp/searchList.dart';
import '../Screens/disease_page.dart';

class DoctorsList extends StatefulWidget {
  @override
  _DoctorsListState createState() => _DoctorsListState();
}

class _DoctorsListState extends State<DoctorsList> {
  TextEditingController _textController = new TextEditingController();
  late String search;
  var _length = 0;

  @override
  void initState() {
    super.initState();
    search = _textController.text;
    _length = search.length;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Find Doctors'),
        actions: <Widget>[
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: 'Search Doctor',
                  hintStyle: TextStyle(
                    color: Colors.black26,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20,
                  ),
                  prefixStyle: TextStyle(
                    color: Colors.grey[300],
                  ),
                  suffixIcon: _textController.text.length != 0
                      ? TextButton(
                          onPressed: () {
                            setState(() {
                              _textController.clear();
                              _length = search.length;
                            });
                          },
                          child: Icon(
                            Icons.close_rounded,
                            size: 20,
                          ),
                        )
                      : SizedBox(),
                ),
                onChanged: (String _searchKey) {
                  setState(
                    () {
                      print('>>>' + _searchKey);
                      search = _searchKey;
                      _length = search.length;
                    },
                  );
                },
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textInputAction: TextInputAction.search,
                autofocus: false,
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: _length == 0
            ? Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Disease()),
                          );
                          setState(() {
                            _length = 1;
                          });
                        },
                        child: Text(
                          'Show All',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Image(image: AssetImage('assets/images/search-bg.png')),
                    ],
                  ),
                ),
              )
            : SearchList(
                searchKey: search,
              ),
      ),
    );
  }
}
