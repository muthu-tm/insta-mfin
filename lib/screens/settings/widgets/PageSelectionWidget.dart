import 'package:flutter/material.dart';

class PageSelectionWidget extends StatelessWidget {
  final page;
  final idx;

  PageSelectionWidget({
    @required this.page,
    @required this.idx,
  });

  onTap() {
    print("${this.idx} selected.");
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: 200.0,
            child: new Card(
              child: new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  this.page,
                  new Material(
                    type: MaterialType.transparency,
                    child: new InkWell(onTap: this.onTap),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}