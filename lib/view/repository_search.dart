//MGS. M. FAKHRI ABDILLAH
//082176619855
//mgsmfakhria@gmail.com
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RepositorySearch extends StatefulWidget {
  const RepositorySearch({Key? key}) : super(key: key);

  @override
  _RepositorySearchState createState() => _RepositorySearchState();
}

class _RepositorySearchState extends State<RepositorySearch> {
  List repository = [];
  List repositoryName = [];
  List repositoryId = [];
  List foundRepository = [];

  var searchController = TextEditingController();

  //GET repository DATA
  fetchRepository() async {
    repositoryName.clear();
    foundRepository.clear();

    var url = "https://api.github.com/search/repositories?q=doraemon";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['items'];
      setState(() {
        repository = data;
        for (int i = 0; i < repository.length; i++) {
          repositoryName.add(repository[i]['name']);
        }
      });
    } else {
      repository = [];
      repositoryName.clear();
    }
  }

  //SEARCH FUNC
  onSearch(search) {
    setState(() {
      foundRepository.clear();
    });
    for (int i = 0; i < repository.length; i++) {
      if (repositoryName[i]
          .toString()
          .toLowerCase()
          .contains(search.toString().toLowerCase())) {
        setState(() {
          foundRepository.add(repository[i]);
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
    fetchRepository();
  }

//-----------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    //repository FOUNDED LIST
    var repositoryFounded = Expanded(
        child: Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListView.builder(
        itemCount: foundRepository.length,
        itemBuilder: (context, x) {
          //repository WIDGET
          return (foundRepository.isNotEmpty)
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
                        child: Image.network(foundRepository[x]['owner']
                                ['avatar_url']
                            .toString()),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //Repository TITLE
                            Container(
                                height: 35,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  foundRepository[x]['name'].toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                )),

                            //Repository UPDATE DATE
                            Container(
                                margin: const EdgeInsets.only(top: 5),
                                height: 15,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  foundRepository[x]['updated_at'].toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                )),
                          ],
                        ),
                      ),
                      //Repository achievement text
                      SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Watchers',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                            Text(
                              'Stars',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                            Text(
                              'Forks',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                      //Repository achievement
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        width: 40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ': ' +
                                  foundRepository[x]['watchers_count']
                                      .toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                            Text(
                              ': ' +
                                  foundRepository[x]['stargazers_count']
                                      .toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                            Text(
                              ': ' +
                                  foundRepository[x]['forks_count'].toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
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
                                      hintText: "Repository Search",
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
            (foundRepository.isNotEmpty)
                ? repositoryFounded
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
