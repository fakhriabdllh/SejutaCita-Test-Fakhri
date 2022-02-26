//MGS. M. FAKHRI ABDILLAH
//082176619855
//mgsmfakhria@gmail.com
import 'package:flutter/material.dart';
import 'package:sejuta_cita_test/view/User.dart';
import 'package:sejuta_cita_test/view/issues.dart';
import 'package:sejuta_cita_test/view/repository.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedNavbar = 1;
  final List<Widget> _pages = [
    const User(),
    const Issues(),
    const Repository(),
  ];

  void _changeSelectedNavBar(int select) {
    setState(() {
      _selectedNavbar = select;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedNavbar],
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: const Color(0xff1a1a1a),
              splashColor: Colors.transparent),
          child: BottomNavigationBar(
            selectedFontSize: 10,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey[600],
            showUnselectedLabels: false,
            currentIndex: _selectedNavbar,
            onTap: _changeSelectedNavBar,
            items: const <BottomNavigationBarItem>[
              //user button
              BottomNavigationBarItem(
                icon: Icon(Icons.account_box),
                label: 'User',
                backgroundColor: Colors.white,
              ),
              //issues button
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Issues',
                backgroundColor: Colors.white,
              ),
              //repository button
              BottomNavigationBarItem(
                icon: Icon(Icons.account_tree),
                label: 'Repository',
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
