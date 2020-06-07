import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomRadioModel.dart';

class SearchOptionsRadio extends StatelessWidget {
  SearchOptionsRadio(this._item, this._color);

  final CustomRadioModel _item;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Container(
        height: 40.0,
        width: MediaQuery.of(context).size.width * 0.33,
        child: new Center(
          child: new Text(_item.buttonText,
              style: new TextStyle(
                  fontFamily: "Georgia",
                  color: _item.isSelected
                      ? CustomColors.mfinWhite
                      : CustomColors.mfinBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0)),
        ),
        decoration: new BoxDecoration(
          color: _item.isSelected ? _color : CustomColors.mfinLightGrey,
          border: new Border.all(
              width: 1.0,
              color: _item.isSelected
                  ? CustomColors.mfinLightBlue
                  : CustomColors.mfinGrey),
          borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
        ),
      ),
    );
  }
}
