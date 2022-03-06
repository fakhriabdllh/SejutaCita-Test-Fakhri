//MGS. M. FAKHRI ABDILLAH
//082176619855
//mgsmfakhria@gmail.com
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:http/http.dart' as http;
import 'package:sejuta_cita_test/view/repository_search.dart';

import '../bloc/Repository_bloc.dart';

class Repository extends StatefulWidget {
  const Repository({Key? key}) : super(key: key);

  @override
  _RepositoryState createState() => _RepositoryState();
}

class _RepositoryState extends State<Repository> {
  RepositoryBloc blocRepository = RepositoryBloc();

  bool statusSwitch = true;
  bool isLoading = false;
  bool getLoading = false;
  List repository = [];
  List lazyRepository = [];
  List jump = [];

  int currentMax = 0;

  // ignore: prefer_typing_uninitialized_variables
  var data;

  final jumpController = ItemScrollController();
  final ScrollController _jumpController = ScrollController();
  final ScrollController _scrollController = ScrollController();

  //GET Repository DATA
  fetchRepository() async {
    setState(() {
      isLoading = true;
    });
    var url = "https://api.github.com/search/repositories?q=doraemon";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      data = json.decode(response.body)['items'];
      setState(() {
        repository = data;
        for (int x = currentMax; x < currentMax + 10; x++) {
          lazyRepository.add(data[x]);
        }
        isLoading = false;
      });
    } else {
      repository = [];
      lazyRepository = [];
      isLoading = false;
    }
  }

  //LOADING ANIMATION
  loadData(x, a, b) {
    jump = List.generate(repository.length ~/ 5, (i) => "${i + 1}");

    if (x == 0) {
      if (isLoading || lazyRepository.isEmpty) {
        return const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
      } else {
        return a;
      }
    } else {
      if (isLoading || repository.isEmpty) {
        return const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
      } else {
        return b;
      }
    }
  }

  //JUMP Repository
  Future scrollToRepository(x) async {
    if (x > 0) {
      jumpController.jumpTo(index: (x * 5) - 1);
    } else {
      jumpController.jumpTo(index: x);
    }
  }

  _getMoreData(a, b) {
    currentMax = currentMax + 10;
    setState(() {
      getLoading = true;
    });
    if (currentMax < repository.length) {
      for (int i = currentMax; i < currentMax + 10; i++) {
        a.add(b[i]);
      }
      setState(() {
        getLoading = false;
      });
    } else {
      a = [];
      getLoading = false;
    }
    setState(() {
      getLoading = false;
    });
  }

  //DISPOSE
  @override
  void dispose() {
    blocRepository.dispose();
    super.dispose();
  }

  //INIT
  @override
  void initState() {
    super.initState();
    fetchRepository();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData(lazyRepository, data);
      }
    });
  }

//-----------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    //Repository LAZY LIST
    var repositorylazy = Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemExtent: 80,
        itemCount: lazyRepository.length + 1,
        itemBuilder: (context, i) {
          return (i == lazyRepository.length)
              //ISSUES WIDGET
              ? (getLoading == true)
                  ? const CupertinoActivityIndicator()
                  : SizedBox(
                      child: Center(
                      child: Text(
                        'End Of Data',
                        style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                      ),
                    ))
              : Container(
                  width: width,
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        width: 60,
                        height: 60,
                        child: Image.network(lazyRepository[i]['owner']
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
                                  lazyRepository[i]['name'].toString(),
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
                                  lazyRepository[i]['updated_at'].toString(),
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
                                  lazyRepository[i]['watchers_count']
                                      .toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                            Text(
                              ': ' +
                                  lazyRepository[i]['stargazers_count']
                                      .toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                            Text(
                              ': ' +
                                  lazyRepository[i]['forks_count'].toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );

    //Repository INDEX LIST
    var repositoryindex = Column(children: [
      SizedBox(
        height: height - 245,
        width: width,
        child: ScrollablePositionedList.builder(
          shrinkWrap: true,
          itemScrollController: jumpController,
          itemCount: repository.length,
          itemBuilder: (context, j) {
            return (j != repository.length)
                //Repository WIDGET
                ? Container(
                    height: 75,
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
                              repository[j]['owner']['avatar_url'].toString()),
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
                                    repository[j]['name'].toString(),
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
                                    repository[j]['updated_at'].toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: Text(
                            (j + 1).toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                              Text(
                                'Stars',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                              Text(
                                'Forks',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
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
                                    repository[j]['watchers_count'].toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                              Text(
                                ': ' +
                                    repository[j]['stargazers_count']
                                        .toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                              Text(
                                ': ' + repository[j]['forks_count'].toString(),
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
      ),

      //PAGE BUTTON
      Container(
        width: width,
        height: 35,
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //JUMP TEXT
            Container(
              margin: const EdgeInsets.only(right: 5),
              child: const Text(
                'Jump to number:',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),

            //JUMP NUMBER
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _jumpController,
                  itemExtent: 50,
                  itemCount: jump.length,
                  itemBuilder: (context, j) {
                    return (j != jump.length)
                        //JUMP BUTTON
                        ? Container(
                            width: 15,
                            color: Colors.grey[800],
                            margin: const EdgeInsets.only(right: 5),
                            child: TextButton(
                              onPressed: () {
                                scrollToRepository(j);
                              },
                              style: TextButton.styleFrom(
                                primary: Colors.grey,
                                minimumSize: const Size(20, 20),
                                maximumSize: const Size(20, 20),
                              ),
                              child: Text(
                                (j > 0) ? (j * 5).toString() : "1",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          )
                        //BLANK
                        : Container();
                  }),
            ),
          ],
        ),
      )
    ]);

    //------------------------------------------------------------
    return Scaffold(
      body: Container(
        color: const Color(0xff1a1a1a),
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 5),
        child: Column(
          children: [
            //TOPBAR
            SizedBox(
              width: width,
              height: 40,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //LAZY MODE BUTTON
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 80,
                      height: 40,
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        'Lazy Mode',
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ),
                    ),
                    //SWITCH BUTTON
                    Switch.adaptive(
                        activeColor: Colors.white,
                        inactiveTrackColor: Colors.grey[600],
                        activeTrackColor: Colors.grey[100],
                        inactiveThumbColor: Colors.grey[400],
                        value: statusSwitch,
                        onChanged: (value) {
                          setState(() {
                            statusSwitch = value;
                            if (value == true) {
                              setState(() {
                                blocRepository.eventSink
                                    .add(RepositoryEvent.toLazy);
                              });
                            } else {
                              setState(() {
                                blocRepository.eventSink
                                    .add(RepositoryEvent.toIndex);
                              });
                            }
                          });
                        }),

                    //BLANK
                    const Expanded(child: SizedBox()),

                    //SEARCH BUTTON
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: TextButton(
                        onPressed: () {
                          Get.to(() => const RepositorySearch(),
                              transition: Transition.rightToLeft);
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.grey,
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ]),
            ),
            //BLANK
            Container(height: 20),
            //BUILD LIST
            StreamBuilder(
              stream: blocRepository.stateStream,
              initialData: 0,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return loadData(
                    snapshot.data, repositorylazy, repositoryindex)!;
              },
            ),
          ],
        ),
      ),
    );
  }
}
