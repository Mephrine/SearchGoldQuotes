import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_gold_quotes/app/presentation/pages/main/history/history_view.dart';
import 'package:search_gold_quotes/app/presentation/pages/main/home/home_view.dart';
import 'package:search_gold_quotes/app/presentation/pages/main/video/video_view.dart';
import 'package:search_gold_quotes/core/di/injection_container.dart';
import 'package:search_gold_quotes/core/presentation/routes/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:search_gold_quotes/core/theme/theme_notifier.dart';
import 'package:search_gold_quotes/core/values/dimens.dart';
import 'package:search_gold_quotes/core/values/strings.dart';

// StatelessWidget -> 상태가 없다! 즉, 한번 그려진 후 다시 그려지지 않는 위젯

// StatefulWidget -> 상태가 있는 위젯! 상태가 변하면 다시 그려진다!

// Cupertino -> 애플 스타일 디자인

// Material -> 구글 머터리얼 디자인

// Scaffold -> MerterialApp에서 사용ㅇ되며, AppBar, BottomNavigationBar, Drawer, FloatingActionButtion 등과 같은 많은 기본 기능을 제공.
// 즉, Material 디자인 앱의 뼈대가 되는 Widget
// Cupertino에서도 Scaffold가 사용은 가능하나, Cupertino~~로 시작하는 위젯들을 사용하면 될 듯?

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeService = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeService.getTheme(),
      home: MainView(),
    );
  }
}

class MainView extends StatefulWidget {
  @override
  State createState() => _MainView();
}

// class
class _MainView extends State<MainView> with SingleTickerProviderStateMixin {
  TabController _tabController;

  String _navigationTitle;
  final _tabTitleList = [
    Strings.titleHome,
    Strings.titleHistory,
    Strings.titleVideo
  ];
  final _pages = [HomeView(), HistoryView(), VideoView()];

  @override
  void initState() {
    super.initState();
    _navigationTitle = _tabTitleList[0];
    _tabController = TabController(vsync: this, length: _tabTitleList.length);
    _tabController.addListener(changeNavigationTitleByIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: _pages,
      ),
      bottomNavigationBar: ConvexAppBar(
        controller: _tabController,
        items: [
          TabItem(
              icon: Icons.account_balance_outlined, title: _tabTitleList[0]),
          TabItem(icon: Icons.history, title: _tabTitleList[1]),
          TabItem(icon: Icons.play_circle_outline, title: _tabTitleList[2]),
        ],
        height: Dimens.bottomTabHeight,
        style: TabStyle.react,
        initialActiveIndex: 0,
        onTap: (int i) => print('click index=$i'),
        color: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
    );
  }

  void changeNavigationTitleByIndex() {
    setState(() {
      _navigationTitle = _tabTitleList[_tabController.index];
    });
  }

  void reloadPage(int index) {}
}

class NavigationTitleWidget extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const NavigationTitleWidget({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding:
                EdgeInsets.fromLTRB(Dimens.navigationHorizontalMargin, 0, 0, 0),
            child: Align(
              widthFactor: 1.0,
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                    fontSize: Dimens.fontTextTitle,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          Expanded(child: Container()),
          MaterialButton(
            padding: EdgeInsets.all(0),
            child: Icon(
              Icons.settings,
              color: Theme.of(context).primaryColor,
              size: Dimens.iconSizeTitle,
            ),
            onPressed: () => presentToSettingPage(context),
          ),
        ],
      ),
    ));
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  void presentToSettingPage(BuildContext context) {
    context.router.push(SettingPage());
  }
}
