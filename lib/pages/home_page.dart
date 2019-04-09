import 'package:flipflop/blocs/flipflop_bloc.dart';
import 'package:flipflop/constant/keys.dart';
import 'package:flipflop/models/category_view_model.dart';
import 'package:flipflop/models/language_view_model.dart';
import 'package:flipflop/models/level_view_model.dart';
import 'package:flipflop/pages/FlipFlopBlocState.dart';
import 'package:flipflop/pages/game_page.dart';
import 'package:flipflop/providers/base_provider.dart';
import 'package:flipflop/utils/shared_prefs_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends FlipFlopBlocState {

  SharedPrefHelper _sharedPrefHelper;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SharedPrefHelper.init()
        .then((instance) {
      _sharedPrefHelper = instance;

      _loadSavedLanguageAndLevelSet();
    });
  }

  @override
  void dispose() {
    bloc(context).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ffBloc = bloc(context);

    return StreamBuilder(
      stream: ffBloc.categories,
      builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.waiting:
            return _buildLoadingView();
          default:
            return _buildCategoriesView(snapshot);
        }
      },
    );
  }

  Widget _buildLoadingView() {
    return Center(
        child: CircularProgressIndicator()
    );
  }

  Widget _buildCategoriesView(AsyncSnapshot<List<Category>> snapshot) {
    final Size screenSize = MediaQuery.of(context).size;
    final int length = snapshot.data.length;
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: screenSize.height * 0.3,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.assignment),
                tooltip: "My Stack",
                onPressed: () {
                  Navigator.pushNamed(context, '/cardstack');
                }),
            IconButton(
                icon: Icon(Icons.settings),
                tooltip: "Settings",
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                }),
          ],
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Home'),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
        ),

        SliverPersistentHeader(
            delegate: _SliverHeaderDelegate(
                minHeight: 40,
                maxHeight: 40,
                text: "Categories"
            )
        ),

        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.5
          ),
          delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                Category category = snapshot.data[index];
                return _buildListItem(category, index);
              },
              childCount: length
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(Category category, int index) {
    return GestureDetector(
      key: Key("cat-$index"),
      onTap: () => _getCardsByCategory(category.name),
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 10.0 * ((index+1)%2), right: 10.0 * (index%2)),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.amber
          ),
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Text(
          category.name,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold
          )
        ),
      ),
    );
  }

  void _getCardsByCategory(String categoryName) {
    final flipFlopBloc = Provider.of<FlipFlopBloc>(context);

    flipFlopBloc.category.add(categoryName);

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            GamePage(cards: flipFlopBloc.cards))
    );
  }

  void _loadSavedLanguageAndLevelSet() async {
    String lang = await _sharedPrefHelper.get(Keys.SHARED_PREFS_LANG);
    String level = await _sharedPrefHelper.get(Keys.SHARED_PREFS_LEVEL);
    print("Stored language : $lang");
    print("Stored level : $level");
    _updateLanguageAndLevelToBloc(lang ?? "ko-Korean", level ?? "0");
  }

  void _updateLanguageAndLevelToBloc(String lang, String level) {
    final ffBloc = bloc(context);

    ffBloc.lang.add(Language.fromPrefs(lang.split('-')));
    ffBloc.level.add(Level.fromPrefs(level));
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {

  _SliverHeaderDelegate({
    @required this.text,
    @required this.maxHeight,
    @required this.minHeight
  });

  final String text;
  final double maxHeight;
  final double minHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500
          )
        ),
      ),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return minHeight != oldDelegate.minExtent || maxHeight != oldDelegate.maxExtent;
  }

}
