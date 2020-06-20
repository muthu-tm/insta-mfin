import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment_template.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/transaction/paymentTemp_controller.dart';

class PaymentTemplateListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: PaymentTemplateController().streamAllPaymentTemplates(),
      builder: (BuildContext context, AsyncSnapshot<List<PaymentTemplate>> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data.isNotEmpty) {
            children = <Widget>[
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.20,
                      closeOnScroll: true,
                      direction: Axis.horizontal,
                      actions: <Widget>[
                        IconSlideAction(
                            caption: 'Edit',
                            color: CustomColors.mfinBlue,
                            icon: Icons.edit,
                            onTap: () => {}),
                      ],
                      secondaryActions: <Widget>[
                        IconSlideAction(
                            caption: 'Remove',
                            color: CustomColors.mfinBlue,
                            icon: Icons.edit,
                            onTap: () => {}),
                      ],
                      child: _paymentList(context, index, snapshot.data[index]),
                    );
                  })
            ];
          }
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

  _paymentList(BuildContext context, int index, PaymentTemplate template) {
    return ListTile(
      title: Text(template.name.toString()),
    );
  }
}
