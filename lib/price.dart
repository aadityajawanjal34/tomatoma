import 'package:flutter/material.dart';


class PricePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Date Price Picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DatePricePicker(),
    );
  }
}

class DatePricePicker extends StatefulWidget {
  @override
  _DatePricePickerState createState() => _DatePricePickerState();
}

class _DatePricePickerState extends State<DatePricePicker> {
  // Map of dates to predicted prices
  final Map<DateTime, double> priceMap = {
    DateTime(2024, 01, 01): 1881.25,
    DateTime(2024, 01, 02): 1904.166667,
    DateTime(2024, 01, 03): 2075,
    DateTime(2024, 01, 04): 2064.583333,
    DateTime(2024, 01, 05): 2114.583333,
    DateTime(2024, 01, 06): 2060.416667,
    DateTime(2024, 01, 07): 1995.833333,
    DateTime(2024, 01, 08): 1970.833333,
    DateTime(2024, 01, 09): 1835.416667,
    DateTime(2024, 01, 10): 1510.416667,
    DateTime(2024, 01, 11): 1385.416667,
    DateTime(2024, 01, 12): 1275,
    DateTime(2024, 01, 13): 1202.083333,
    DateTime(2024, 01, 14): 1127.083333,
    DateTime(2024, 01, 15): 1093.75,
    DateTime(2024, 01, 16): 1172.916667,
    DateTime(2024, 01, 17): 1231.25,
    DateTime(2024, 01, 18): 1260.416667,
    DateTime(2024, 01, 19): 1289.583333,
    DateTime(2024, 01, 20): 1327.083333,
    DateTime(2024, 01, 21): 1377.083333,
    DateTime(2024, 01, 22): 1433.333333,
    DateTime(2024, 01, 23): 1475,
    DateTime(2024, 01, 24): 1545.833333,
    DateTime(2024, 01, 25): 1575,
    DateTime(2024, 01, 26): 1610.416667,
    DateTime(2024, 01, 27): 1660.416667,
    DateTime(2024, 01, 28): 1704.166667,
    DateTime(2024, 01, 29): 1720.833333,
    DateTime(2024, 01, 30): 1743.75,
    DateTime(2024, 01, 31): 1768.75,
    DateTime(2024, 02, 01): 1825,
    DateTime(2024, 02, 02): 1829.166667,
    DateTime(2024, 02, 03): 1852.083333,
    DateTime(2024, 02, 04): 1887.5,
    DateTime(2024, 02, 05): 1875,
    DateTime(2024, 02, 06): 1887.5,
    DateTime(2024, 02, 07): 1895.833333,
    DateTime(2024, 02, 08): 1918.75,
    DateTime(2024, 02, 09): 1939.583333,
    DateTime(2024, 02, 10): 1950,
    DateTime(2024, 02, 11): 1977.083333,
    DateTime(2024, 02, 12): 1989.583333,
    DateTime(2024, 02, 13): 1895.833333,
    DateTime(2024, 02, 14): 1818.75,
    DateTime(2024, 02, 15): 1802.083333,
    DateTime(2024, 02, 16): 1735.416667,
    DateTime(2024, 02, 17): 1637.5,
    DateTime(2024, 02, 18): 1506.25,
    DateTime(2024, 02, 19): 1397.916667,
    DateTime(2024, 02, 20): 1397.916667,
    DateTime(2024, 02, 21): 1387.5,
    DateTime(2024, 02, 22): 1302.083333,
    DateTime(2024, 02, 23): 1245.833333,
    DateTime(2024, 02, 24): 1181.25,
    DateTime(2024, 02, 25): 1154.166667,
    DateTime(2024, 02, 26): 1158.333333,
    DateTime(2024, 02, 27): 1139.583333,
    DateTime(2024, 02, 28): 1100,
    DateTime(2024, 02, 29): 1107.142857,
    DateTime(2024, 03, 01): 1052.083333,
    DateTime(2024, 03, 02): 1033.333333,
    DateTime(2024, 03, 03): 1064.583333,
    DateTime(2024, 03, 04): 1060.416667,
    DateTime(2024, 03, 05): 993.75,
    DateTime(2024, 03, 06): 979.1666667,
    DateTime(2024, 03, 07): 875,
    DateTime(2024, 03, 08): 902.0833333,
    DateTime(2024, 03, 09): 885.4166667,
    DateTime(2024, 03, 10): 839.5833333,
    DateTime(2024, 03, 11): 837.5,
    DateTime(2024, 03, 12): 875,
    DateTime(2024, 03, 13): 895.8333333,
    DateTime(2024, 03, 14): 956.25,
    DateTime(2024, 03, 15): 945.8333333,
    DateTime(2024, 03, 16): 933.3333333,
    DateTime(2024, 03, 17): 920.8333333,
    DateTime(2024, 03, 18): 895.8333333,
    DateTime(2024, 03, 19): 883.3333333,
    DateTime(2024, 03, 20): 858.3333333,
    DateTime(2024, 03, 21): 810.4166667,
    DateTime(2024, 03, 22): 793.75,
    DateTime(2024, 03, 23): 781.25,
    DateTime(2024, 03, 24): 785.4166667,
    DateTime(2024, 03, 25): 783.3333333,
    DateTime(2024, 03, 26): 768.75,
    DateTime(2024, 03, 27): 787.5,
    DateTime(2024, 03, 28): 804.1666667,
    DateTime(2024, 03, 29): 818.75,
    DateTime(2024, 03, 30): 831.25,
    DateTime(2024, 03, 31): 845.8333333,
    DateTime(2024, 04, 01): 856.25,
    DateTime(2024, 04, 02): 864.5833333,
    DateTime(2024, 04, 03): 897.9166667,
    DateTime(2024, 04, 04): 897.9166667,
    DateTime(2024, 04, 05): 885.4166667,
    DateTime(2024, 04, 06): 872.9166667,
    DateTime(2024, 04, 07): 858.3333333,
    DateTime(2024, 04, 08): 850,
    DateTime(2024, 04, 09): 843.75,
    DateTime(2024, 04, 10): 854.1666667,
    DateTime(2024, 04, 11): 860.4166667,
    DateTime(2024, 04, 12): 887.5,
    DateTime(2024, 04, 13): 893.75,
    DateTime(2024, 04, 14): 908.3333333,
    DateTime(2024, 04, 15): 893.75,
    DateTime(2024, 04, 16): 875,
    DateTime(2024, 04, 17): 870.8333333,
    DateTime(2024, 04, 18): 854.1666667,
    DateTime(2024, 04, 19): 850,
    DateTime(2024, 04, 20): 829.1666667,
    DateTime(2024, 04, 21): 820.8333333,
    DateTime(2024, 04, 22): 856.25,
    DateTime(2024, 04, 23): 885.4166667,
    DateTime(2024, 04, 24): 891.6666667,
    DateTime(2024, 04, 25): 910.4166667,
    DateTime(2024, 04, 26): 908.3333333,
    DateTime(2024, 04, 27): 929.1666667,
    DateTime(2024, 04, 28): 1000,
    DateTime(2024, 04, 29): 1068.75,
    DateTime(2024, 04, 30): 1075,
    // Add other dates and corresponding prices here...
  };

  late DateTime? _selectedDate= DateTime(2024, 01, 01);
  late double _selectedPrice=1881.25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date Price Picker'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  _showDatePicker(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45.0),
                  ),
                ),
                child: Container(
                  width: 200, // Adjust width as needed
                  child: Center(
                    child: Text(
                      'Pick a Date',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                _selectedDate != null
                    ? 'Selected Date: ${_selectedDate!.toString().split(' ')[0]}'
                    : 'Select a Date',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.all(10.0),
                child: _selectedPrice != null
                    ? Text(
                  'Predicted Price: Rs.${_selectedPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20),
                )
                    : Text('Predicted Price:'),
              ),
            ],
          ),
        ),
      ),
    );
  }




  // Function to show date picker
  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2024, 12, 31),
    );
    if (pickedDate != null && priceMap.containsKey(pickedDate)) {
      setState(() {
        _selectedDate = pickedDate;
        _selectedPrice = priceMap[pickedDate]!;
      });
    } else {
      setState(() {
        _selectedDate = null; // Set _selectedDate to null if no date is picked
        _selectedPrice = 0;    // Reset _selectedPrice
      });
    }
  }

}
