
class Option {
  String title;
  String size;
  String value ='10.0';

  Option({this.title, this.size, this.value});
}

final options = [
  Option(
    title: 'Loan Amount',
    size: '40',
    value: '50.0', 
      ),
  Option(
    title: 'Due Amount',
    size: '40',
    value: '50.0',
      ),
  Option(
    title: 'Closing Amount',
    size: '40',
    value: '50.0', 
      ),
  Option(
    title: 'Shortage Amount',
    size: '40',
    value: '50.0', 
      ),
  Option(
    title: 'Current Stock',
    size: '40',
    value: '50.0',
      ),
];