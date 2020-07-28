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
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
      child: Container(
        height: 30.0,
        width: 150.0,
        child: Center(
          child: Text(
            _item.buttonText,
            style: TextStyle(
                fontFamily: "Georgia",
                color: _item.isSelected
                    ? CustomColors.mfinWhite
                    : _boxColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
        ),
        decoration: BoxDecoration(
          color: _item.isSelected ? _color : CustomColors.mfinLightGrey,
          border: Border.all(width: 2.0, color: _boxColor),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
      ),
    );
  }
}
