//MGS. M. FAKHRI ABDILLAH
//082176619855
//mgsmfakhria@gmail.com
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class IssuesSearch extends StatefulWidget {
  const IssuesSearch({Key? key}) : super(key: key);

  @override
  _IssuesSearchState createState() => _IssuesSearchState();
}

class _IssuesSearchState extends State<IssuesSearch> {
  List foundIssues = [];
  bool responseStatus = false;
  bool founded = false;

  var searchController = TextEditingController();

  //SEARCH FUNC
  onSearch(search) async {
    setState(() {
      foundIssues.clear();
      responseStatus = false;
    });
    var url = "https://api.github.com/search/issues?q=doraemon";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        responseStatus = true;
      });
      var foundedData = json.decode(response.body)['items'];
      for (int i = 0; i < foundedData.length; i++) {
        if (foundedData[i]['title']
            .toString()
            .toLowerCase()
            .contains(search.toString().toLowerCase())) {
          setState(() {
            foundIssues.add(foundedData[i]);
          });
        }
      }
      founded = true;
    } else {
      setState(() {
        responseStatus = false;
        founded = false;
      });
    }
  }

//-----------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    //ISSUES FOUNDED LIST
    var issuesFounded = Expanded(
        child: Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListView.builder(
        itemCount: foundIssues.length,
        itemBuilder: (context, x) {
          //ISSUES WIDGET
          return (foundIssues.isNotEmpty)
              ? Container(
                  width: width,
                  height: 75,
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //ISSUES AVATAR
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        width: 60,
                        height: 60,
                        child: Image.network(
                            foundIssues[x]['user']['avatar_url'].toString()),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //ISSUES TITLE
                            Container(
                                height: 35,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  foundIssues[x]['title'].toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                )),

                            //ISSUES UPDATE DATE
                            Container(
                                margin: const EdgeInsets.only(top: 5),
                                height: 15,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  foundIssues[x]['updated_at'].toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                )),
                          ],
                        ),
                      ),
                      //ISSUES STATE
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        width: 40,
                        child: Text(
                          foundIssues[x]['state'].toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
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
                                alignment: Alignment.centerLeft,
                                child: TextField(
                                  cursorColor: Colors.grey[400],
                                  autofocus: true,
                                  onChanged: (value) => onSearch(value),
                                  controller: searchController,
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Issues Search",
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
            (responseStatus == true)
                ? (founded == false)
                    ? Expanded(
                        child: Center(
                          child: Text(
                            'No Result Found',
                            style: TextStyle(
                                fontSize: 30, color: Colors.grey[800]),
                          ),
                        ),
                      )
                    : issuesFounded
                : (responseStatus == false)
                    ? Expanded(
                        child: Center(
                          child: Text(
                            'API not connected',
                            style: TextStyle(
                                fontSize: 30, color: Colors.grey[800]),
                          ),
                        ),
                      )
                    : const SizedBox()
          ],
        ),
      ),
    );
  }
}
