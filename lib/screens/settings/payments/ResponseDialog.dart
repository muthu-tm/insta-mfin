import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class ResponseDialog extends StatelessWidget {
  ResponseDialog({this.color, this.icon, this.id, this.message});
  final Color color;
  final IconData icon;
  final String id;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width * 0.55,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment(0, 1),
              child: Container(
                height: 160,
                width: MediaQuery.of(context).size.width * 0.55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  color: CustomColors.mfinWhite,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        message,
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: CustomColors.mfinBlue),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      id == null
                          ? Container()
                          : Text(
                              "ID: $id",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: CustomColors.mfinBlue),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, -1),
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: IconButton(
                    icon: Icon(
                      icon,
                      color: CustomColors.mfinWhite,
                      size: 40,
                    ),
                    onPressed: () => Navigator.pop(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
