import 'package:flutter/material.dart';
import 'package:fyp_uiprototype/pages/screens/Explore.dart';
import 'package:fyp_uiprototype/pages/screens/News.dart';
import 'package:fyp_uiprototype/pages/screens/Nearby.dart';
import 'package:fyp_uiprototype/pages/screens/Tools.dart';
import 'package:fyp_uiprototype/pages/screens/Profile.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  PageController _pageController = PageController();
  List<Widget> _pageOptions = [Explore(), News(), Nearby(), Tools(), Profile()];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Text("BigDeal"),
      //   backgroundColor: Colors.white,
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(Icons.search_outlined),
      //       onPressed: () {
      //         showSearch(context: context, delegate: SearchBar());
      //       },
      //     ),
      //   ],
      // ),
      body: PageView(
        controller: _pageController,
        children: _pageOptions,
        onPageChanged: _onItemTapped,
        physics: FixedExtentScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        fixedColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey[600],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(_currentIndex);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search_rounded),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article_rounded),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore_rounded),
            label: 'Nearby',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_outlined),
            activeIcon: Icon(Icons.build_rounded),
            label: 'Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// class SearchBar extends SearchDelegate<String> {
//   String searchHint = 'Find your deals here';

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//           showSuggestions(context);
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: AnimatedIcon(
//           icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
//       onPressed: () {
//         if (query.isEmpty) {
//           close(context, null);
//         } else {
//           query = '';
//           showSuggestions(context);
//         }
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return null;
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return ListView(
//       children: <Widget>[
//         ListTile(
//           title: Text('Test01'),
//         ),
//         ListTile(
//           title: Text('Try01'),
//         ),
//         ListTile(
//           title: Text('Test01'),
//         ),
//         ListTile(
//           title: Text('Test01'),
//         ),
//         ListTile(
//           title: Text('Test01'),
//         ),
//       ],
//     );
//   }

//   @override
//   ThemeData appBarTheme(BuildContext context) {
//     assert(context != null);
//     final ThemeData theme = Theme.of(context);
//     assert(theme != null);
//     return theme.copyWith(
//       primaryColor: Colors.white,
//       primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
//       primaryColorBrightness: Brightness.light,
//       primaryTextTheme: theme.textTheme,
//     );
//   }
// }
