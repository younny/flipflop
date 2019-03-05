import 'package:flipflop/blocs/flipflop_bloc.dart';
import 'package:flipflop/models/category_view_model.dart';
import 'package:flipflop/pages/game_page.dart';
import 'package:flipflop/providers/base_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void dispose() {
    Provider.of<FlipFlopBloc>(context).dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final ffBloc = Provider.of<FlipFlopBloc>(context);
    Size screenSize = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: ffBloc.categories,
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return Center(
            child: Container()
          );
        }
        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: screenSize.height * 0.3,
              flexibleSpace: FlexibleSpaceBar(
                  title: Text('Home')
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
            ),

            SliverPersistentHeader(
                delegate: _SliverHeaderDelegate(
                    minHeight: 40,
                    maxHeight: 40,
                    text: "Category"
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
                    final category = snapshot.data[index];
                    return _buildListItem(category, index);
                  },
                  childCount: snapshot.data.length
              ),
            ),
//        SliverFixedExtentList(
//          delegate: SliverChildBuilderDelegate(
//              (BuildContext context, int index) {
//                return _buildListItem(index);
//              },
//            childCount: mockCategories.length
//          ),
//          itemExtent: 70.0
//        )
          ],
        );
      },
    );


  }

  Widget _buildListItem(Category category, int index) {
    return GestureDetector(
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
        MaterialPageRoute(builder: (context) => GamePage(bloc: flipFlopBloc))
    );
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
