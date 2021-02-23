import 'package:flutter/material.dart';
import 'package:fyp_uiprototype/pages/screens/Explore.dart';
import 'package:fyp_uiprototype/pages/screens/News.dart';
import 'package:fyp_uiprototype/pages/screens/Nearby_new.dart';
import 'package:fyp_uiprototype/pages/screens/Tools_new.dart';
import 'package:fyp_uiprototype/pages/screens/Profile.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  TabController _tabController;
  List<Widget> _pageOptions = [Explore(), News(), Nearby(), Tools(), Profile()];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<bool> onWillPop() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to leave?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    );
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
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
          body: TabBarView(
            controller: _tabController,
            children: _pageOptions,
            //onPageChanged: _onItemTapped,
            //physics: ClampingScrollPhysics(),
          ),
          bottomNavigationBar: Material(
            color: Colors.white,
            child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.blue,
                indicatorWeight: 3.0,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[600],
                tabs: <Widget>[
                  Tab(
                    icon: _tabController.index == 0 ? Icon(Icons.search_outlined) : Icon(Icons.search_rounded),
                  ),
                  Tab(
                    icon: _tabController.index == 1 ? Icon(Icons.article_outlined) : Icon(Icons.article_rounded),
                  ),
                  Tab(
                    icon: _tabController.index == 2 ? Icon(Icons.explore_outlined) : Icon(Icons.explore_rounded),
                  ),
                  Tab(
                    icon: _tabController.index == 3 ? Icon(Icons.build_outlined) : Icon(Icons.build_rounded),
                  ),
                  Tab(
                    icon: _tabController.index == 4
                        ? Icon(Icons.account_circle_outlined)
                        : Icon(Icons.account_circle_rounded),
                  ),
                ]),
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   currentIndex: _currentIndex,
          //   fixedColor: Colors.black,
          //   type: BottomNavigationBarType.fixed,
          //   unselectedItemColor: Colors.grey[600],
          //   onTap: (index) {
          //     setState(() {
          //       _currentIndex = index;
          //     });
          //   },
          //   items: [
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.search_outlined),
          //       activeIcon: Icon(Icons.search_rounded),
          //       label: 'Explore',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.article_outlined),
          //       activeIcon: Icon(Icons.article_rounded),
          //       label: 'News',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.explore_outlined),
          //       activeIcon: Icon(Icons.explore_rounded),
          //       label: 'Nearby',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.build_outlined),
          //       activeIcon: Icon(Icons.build_rounded),
          //       label: 'Tools',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.account_circle_outlined),
          //       activeIcon: Icon(Icons.account_circle_rounded),
          //       label: 'Profile',
          //     ),
          //   ],
          // ),
        ));
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
