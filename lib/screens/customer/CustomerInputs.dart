
class AddCustomerInputs {
  String title;
  String size;
  String value ='10.0';

  AddCustomerInputs({this.title, this.size, this.value});
}

final addCustomerOptions = [
  AddCustomerInputs(
    title: 'Customer ID:',
    size: '10',
    value: null,
  ),
  AddCustomerInputs(
    title: 'Customer Name',
    size: '40',
    value: null,
    ),
  AddCustomerInputs(
    title: 'Customer'+'s Whatsapp Number',
    size: '40',
    value: null, 
      ),
  AddCustomerInputs(
    title: 'Customer Address',
    size: '70',
    value: null,
      ),
  AddCustomerInputs(
    title: 'Customer'+'s Age',
    size: '40',
    value: null, 
      ),
  AddCustomerInputs(
    title: 'Customer'+'s Profession',
    size: '40',
    value: null, 
      ),
  AddCustomerInputs(
    title: 'Security given by',
    size: '40',
    value: null,
      ),
  AddCustomerInputs(
    title: 'User Name',
    size: '40',
    value: null,
      ),
];