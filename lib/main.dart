import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() {
  /*WidgetsFlutterBinding.ensureInitialized();
  //as default the app support landscape and portirate
  //for ios go to ios=> runner=>info.plist
  SystemChrome.setPreferredOrientations( //the app will apply these orientation 
      [DeviceOrientation.landscapeLeft,
       DeviceOrientation.landscapeRight]);*/

  runApp(MyApp());
}


//use capartino -widget- to use ios widget
//platform.ios or platform.android return boolean to check the platform

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Personal Expenses',
        theme: ThemeData(),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool switch_val = false;
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.53,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool is_landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    AppBar _appBar = AppBar(
      backgroundColor: Colors.pink,
      title: Text(
        'Personal Expenses',
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add)
            
            /* Icon(
            Platform.isAndroid?
            Icons.add
            :CupertinoIcons.add)*/
            ,
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );

    //bool switch_val = false; //wrong position brcause
    // rebuild will happen after tapping the swithch

    return Scaffold(
      appBar: _appBar,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            if(is_landscape==false)
            showChart(context, _appBar,0.3),
            if(is_landscape==false)
            showTransaction(context, _appBar,0.6),
            if(is_landscape==true)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('chart'),
                Switch(
                    value: switch_val,
                    onChanged: (newVal) {
                      setState(() {
                        switch_val = newVal;
                      });
                    }),
              ],
            ),
            if(is_landscape==true)//notice this
            switch_val == true
                ?
                 showChart(context, _appBar,0.7)
                : showTransaction(context, _appBar,0.7),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }

  Container showTransaction(BuildContext context, AppBar _appBar,double ratio) {
    return Container(
        height: (MediaQuery.of(context).size.height -
                _appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            ratio,
        child: TransactionList(_userTransactions, _deleteTransaction));
  }

  Container showChart(BuildContext context, AppBar _appBar,double ratio) {
    return Container(
        height: (MediaQuery.of(context).size.height -
                _appBar.preferredSize.height - //to get the height of appbar
                MediaQuery.of(context)
                    .padding
                    .top //to get the height of the bar at the most top
            ) *
            ratio,
        child: Chart(_recentTransactions));
  }
}
