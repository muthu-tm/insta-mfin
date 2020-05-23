import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomRadioModel.dart';

class CollectionStatusRadioItem extends StatelessWidget {
  CollectionStatusRadioItem(this._item, this._boxColor, this._color);

  final CustomRadioModel _item;
  final Color _boxColor;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
      child: Container(
        height: 30.0,
        width: 50.0,
        child: new Center(
          child: new Text(
            _item.buttonText,
            style: new TextStyle(
                fontFamily: "Georgia",
                color: _item.isSelected
                    ? CustomColors.mfinWhite
                    : CustomColors.mfinBlue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
        ),
        decoration: new BoxDecoration(
          color: _item.isSelected ? _color : CustomColors.mfinLightGrey,
          border: new Border.all(width: 3.0, color: _boxColor),
          borderRadius: const BorderRadius.all(
            const Radius.circular(2.0),
          ),
        ),
      ),
    );
  }
}
