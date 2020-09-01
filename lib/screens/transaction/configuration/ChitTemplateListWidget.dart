import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/chit_template.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:instamfin/screens/transaction/edit/EditChitTemplate.dart';
import 'package:instamfin/screens/transaction/view/ViewChitTemplate.dart';
import 'package:instamfin/screens/utils/AsyncWidgets.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/controllers/chit/chit_template_controller.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:instamfin/app_localizations.dart';

class ChitTemplateListWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  ChitTemplateListWidget(this._scaffoldKey);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ChitTemplate().streamChitTemplates(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.documents.length > 0) {
            children = <Widget>[
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    ChitTemplate temp = ChitTemplate.fromJson(
                        snapshot.data.documents[index].data);

                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.20,
                      closeOnScroll: true,
                      direction: Axis.horizontal,
                      actions: <Widget>[
                        IconSlideAction(
                          caption: 'Remove',
                          color: CustomColors.mfinAlertRed,
                          icon: Icons.delete_forever,
                          onTap: () async {
                            var state = Slidable.of(context);
                            var dismiss = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: new Text(
                                    "Confirm!",
                                    style: TextStyle(
                                        color: CustomColors.mfinAlertRed,
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                  content: Text(
                                      'Are you sure to remove ${temp.name} template?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      color: CustomColors.mfinButtonGreen,
                                      child: Text(
                                        "NO",
                                        style: TextStyle(
                                            color: CustomColors.mfinBlue,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    FlatButton(
                                      color: CustomColors.mfinAlertRed,
                                      child: Text(
                                        "YES",
                                        style: TextStyle(
                                            color: CustomColors.mfinLightGrey,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,
                                      ),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        ChitTemplateController _ctc =
                                            ChitTemplateController();
                                        var result = await _ctc
                                            .removeTemp(temp.getDocumentID());
                                        if (!result['is_success']) {
                                          _scaffoldKey.currentState
                                              .showSnackBar(
                                                  CustomSnackBar.errorSnackBar(
                                                      result['message'], 2));
                                          _scaffoldKey.currentState.showSnackBar(
                                              CustomSnackBar.errorSnackBar(
                                                  "Unable to remove Chit Template",
                                                  2));
                                        } else {
                                          _scaffoldKey.currentState.showSnackBar(
                                              CustomSnackBar.successSnackBar(
                                                  "Chit Template removed successfully",
                                                  2));
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );

                            if (dismiss != null && dismiss && state != null) {
                              state.dismiss();
                            }
                          },
                        ),
                      ],
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Edit',
                          color: CustomColors.mfinBlue,
                          icon: Icons.edit,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditChitTemplate(temp),
                              settings: RouteSettings(
                                  name: '/transactions/chit/template/edit'),
                            ),
                          ),
                        ),
                      ],
                      child: _chitTempList(context, index, temp),
                    );
                  })
            ];
          } else {
            // No Template added yet
            return Container(
              alignment: Alignment.center,
              height: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Text(
                    AppLocalizations.of(context).translate("no_chit_templates"),
                    style: TextStyle(
                      color: CustomColors.mfinAlertRed,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Text(
                    AppLocalizations.of(context).translate("add_chit_fund_template"),
                    style: TextStyle(
                      color: CustomColors.mfinBlue,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                ],
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AsyncWidgets.asyncError(),
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AsyncWidgets.asyncWaiting(),
            ),
          );
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }

  _chitTempList(BuildContext context, int index, ChitTemplate template) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          showMaterialModalBottomSheet(
              enableDrag: true,
              isDismissible: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              context: context,
              builder: (context, scrollController) {
                return ViewChitTemplate(template);
              });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Material(
              color: CustomColors.mfinBlue,
              elevation: 5.0,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                      child: Text(
                        template.chitAmount.toString(),
                        style: TextStyle(
                            color: CustomColors.mfinAlertRed,
                            fontFamily: 'Georgia',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                      color: CustomColors.mfinButtonGreen,
                    ),
                    SizedBox(
                      height: 30,
                      child: Text(
                        '${template.tenure}',
                        style: TextStyle(
                          color: CustomColors.mfinWhite,
                          fontFamily: 'Georgia',
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Material(
              color: CustomColors.mfinWhite,
              elevation: 5.0,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.55,
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      child: ListTile(
                        title: Text(
                          template.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Georgia',
                            color: CustomColors.mfinBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Chit Day: ${template.collectionDay}',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Georgia',
                            color: CustomColors.mfinBlue,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
