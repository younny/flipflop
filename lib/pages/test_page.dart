import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Table(
        border: TableBorder.all(color: Colors.orange),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: [
              Text(
                  'Product'*10),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder(
                    verticalInside: BorderSide(color: Colors.orange),
                    horizontalInside: BorderSide(color: Colors.orange)),
                children: <TableRow>[
                  TableRow(
                    children: [
                      FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Text(
                          'Max',
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.none,
                        child: Text(
                          'Min',
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      FittedBox(
                        fit: BoxFit.none,
                        child: Container(
                          color: Colors.yellow,
                          child: Text(
                            '100',
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.none,
                        child: Text(
                          '20'
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
