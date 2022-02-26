//MGS. M. FAKHRI ABDILLAH
//082176619855
//mgsmfakhria@gmail.com
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sejuta_cita_test/view/issues_search.dart';
import 'package:http/http.dart' as http;
import '../bloc/issues_bloc.dart';

class Issues extends StatefulWidget {
  const Issues({Key? key}) : super(key: key);

  @override
  _IssuesState createState() => _IssuesState();
}

class _IssuesState extends State<Issues> {
  IssuesBloc blocIssues = IssuesBloc();

  bool statusSwitch = true;
  bool isLoading = false;
  List issues = [];
  List jump = [];

  final jumpController = ItemScrollController();
  final ScrollController _jumpController = ScrollController();
  final ScrollController _jumpController2 = ScrollController();

  //GET ISSUES DATA
  fetchIssues() async {
    setState(() {
      isLoading = true;
    });
    var url = "https://api.github.com/search/issues?q=doraemon";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['items'];
      setState(() {
        issues = data;
        isLoading = false;
      });
    } else {
      issues = [];
      isLoading = false;
    }
  }

  //LOADING ANIMATION
  loadData(x, a, b) {
    jump = List.generate(issues.length ~/ 5, (i) => "${i + 1}");

    if (x == 0) {
      if (isLoading || issues.isEmpty) {
        return const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
      } else {
        return a;
      }
    } else {
      if (isLoading || issues.isEmpty) {
        return const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
      } else {
        return b;
      }
    }
  }

  //JUMP ISSUES
  Future scrollToIssues(x) async {
    if (x > 0) {
      jumpController.jumpTo(index: (x * 5) - 1);
    } else {
      jumpController.jumpTo(index: x);
    }
  }

  //DISPOSE
  @override
  void dispose() {
    blocIssues.dispose();
    super.dispose();
  }

  //INIT
  @override
  void initState() {
    super.initState();
    fetchIssues();
  }

//-----------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    //ISSUES LAZY LIST
    var issueslazy = Expanded(
      child: ListView.builder(
        controller: _jumpController,
        itemExtent: 80,
        itemCount: issues.length,
        itemBuilder: (context, i) {
          return (i != issues.length)
              //ISSUES WIDGET
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
                            issues[i]['user']['avatar_url'].toString()),
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
                                  issues[i]['title'].toString(),
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
                                  issues[i]['updated_at'].toString(),
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
                        alignment: Alignment.center,
                        child: Text(
                          issues[i]['state'].toString(),
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
    );

    //ISSUES INDEX LIST
    var issuesindex = Column(children: [
      SizedBox(
        height: height - 245,
        width: width,
        child: ScrollablePositionedList.builder(
          shrinkWrap: true,
          itemScrollController: jumpController,
          itemCount: issues.length,
          itemBuilder: (context, x) {
            return (x != issues.length)
                //ISSUES WIDGET
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
                              issues[x]['user']['avatar_url'].toString()),
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
                                    issues[x]['title'].toString(),
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
                                    issues[x]['updated_at'].toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  )),
                            ],
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          width: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //ISSUES INDEX NUMBER
                              Text(
                                (x + 1).toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              //ISSUES STATE
                              Text(
                                issues[x]['state'].toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
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
                  controller: _jumpController2,
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
                                scrollToIssues(j);
                              },
                              style: TextButton.styleFrom(
                                primary: Colors.grey,
                                minimumSize: const Size(20, 20),
                                maximumSize: const Size(20, 20),
                              ),
                              child: Text(
                                (j > 0) ? (j * 5).toString() : "1",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 13),
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
                                blocIssues.eventSink.add(IssuesEvent.toLazy);
                              });
                            } else {
                              setState(() {
                                blocIssues.eventSink.add(IssuesEvent.toIndex);
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
                          Get.to(() => const IssuesSearch(),
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
              stream: blocIssues.stateStream,
              initialData: 0,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return loadData(snapshot.data, issueslazy, issuesindex)!;
              },
            ),
          ],
        ),
      ),
    );
  }
}
