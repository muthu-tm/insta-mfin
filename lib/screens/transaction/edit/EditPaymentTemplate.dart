import 'package:flutter/material.dart';
import 'package:instamfin/db/models/payment_template.dart';


class EditPaymentTemplate extends StatefulWidget {
  EditPaymentTemplate(this.template);
  final PaymentTemplate template;

  @override
  _EditPaymentTemplateState createState() => _EditPaymentTemplateState();
}

class _EditPaymentTemplateState extends State<EditPaymentTemplate> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
