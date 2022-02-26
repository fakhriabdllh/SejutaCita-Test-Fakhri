//MGS. M. FAKHRI ABDILLAH
//082176619855
//mgsmfakhria@gmail.com
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserSearch extends StatefulWidget {
  const UserSearch({Key? key}) : super(key: key);

  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  List user = [];
  List userName = [];
  List userId = [];
  List foundUser = [];

  var searchController = TextEditingController();

  //GET user DATA
  fetchuser() async {
    userName.clear();
    foundUser.clear();

    var url = "https://api.github.com/search/users?q=doraemon";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['items'];
      setState(() {
        user = data;
        for (int i = 0; i < user.length; i++) {
          userName.add(user[i]['login']);
        }
      });
    } else {
      user = [];
      userName.clear();
    }
  }

  //SEARCH FUNC
  onSearch(search) {
    setState(() {
      foundUser.clear();
    });
    for (int i = 0; i < user.length; i++) {
      if (userName[i]
          .toString()
          .toLowerCase()
          .contains(search.toString().toLowerCase())) {
        setState(() {
          foundUser.add(user[i]);
        });
      }
    }
  }

  //DISPOSE
  @override
  void dispose() {
    super.dispose();
  }

  //INIT
  @override
  void initState() {
    super.initState();
    fetchuser();
  }

//-----------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    //user FOUNDED LIST
    var userFounded = Expanded(
        child: Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListView.builder(
        itemCount: foundUser.length,
        itemBuilder: (context, i) {
          //user WIDGET
          return (foundUser.isNotEmpty)
              ? Container(
                  width: width,
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        width: 60,
                        height: 60,
                        child: Image.network(
                            foundUser[i]['avatar_url'].toString()),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //User TITLE
                            Container(
                                height: 35,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  foundUser[i]['login'].toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                )),

                            //User UPDATE DATE
                            Container(
                                margin: const EdgeInsets.only(top: 5),
                                height: 15,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  foundUser[i]['type'].toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              //BLANK
              : const SizedBox();
        },
      ),
    ));

    //------------------------------------------------------------
    return Scaffold(
      body: Container(
        color: const Color(0xff1a1a1a),
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 5),
        child: Column(
          children: [
            //SEARCH BAR
            SizedBox(
              width: width,
              height: 40,
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                //BACK BUTTON
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  width: 40,
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.grey,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                //SEARCH FIELD
                Expanded(
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[800],
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.search,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                        ),
                        Expanded(
                            child: Container(
                                height: 30,
                                padding: const EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                child: TextField(
                                  cursorColor: Colors.grey[400],
                                  autofocus: true,
                                  onChanged: (value) => onSearch(value),
                                  controller: searchController,
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "User Search",
                                      hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 12)),
                                )))
                      ],
                    ),
                  ),
                ),
              ]),
            ),
            //BLANK
            Container(height: 20),
            //BUILD LIST
            (foundUser.isNotEmpty)
                ? userFounded
                : Expanded(
                    child: Center(
                      child: Text(
                        'No Result Found',
                        style: TextStyle(fontSize: 30, color: Colors.grey[800]),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
