import 'package:flip/models/model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
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
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Category",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            childCount: 1
          ),
        ),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _buildListItem(index);
              },
            childCount: mockCategories.length
          ),
          itemExtent: 70.0
        )
      ],
    );
  }

  Widget _buildListItem(int index) {
    Category category = mockCategories[index];
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(4.0),
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
    );
  }
}
