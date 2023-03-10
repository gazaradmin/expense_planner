import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: "Quicksand",
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText2: const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: "OpenSans",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: '1',
      title: "Test 1",
      amount: 15.89,
      date: DateTime.now(),
    ),
    Transaction(
      id: '2',
      title: "Test 2",
      amount: 15.89,
      date: DateTime.now(),
    ),
    Transaction(
      id: '3',
      title: "Test 3",
      amount: 15.89,
      date: DateTime.now(),
    ),
    Transaction(
      id: '4',
      title: "Test 4",
      amount: 15.89,
      date: DateTime.now(),
    ),
    Transaction(
      id: '5',
      title: "Test 5",
      amount: 15.89,
      date: DateTime.now(),
    ),
    Transaction(
      id: '5',
      title: "Test 5",
      amount: 15.89,
      date: DateTime.now(),
    ),
    Transaction(
      id: '6',
      title: "Test 6",
      amount: 15.89,
      date: DateTime.now(),
    )
  ];
  bool _showChart = false;

  List<Transaction> get _recentTransaction {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransaction(
    String txTitle,
    double txAmount,
    DateTime chosenDate,
  ) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => NewTransaction(_addNewTransaction),
    );
  }

  List<Widget> _buildLandscapeContent(
    MediaQueryData mediaQuery,
    PreferredSizeWidget appBar,
    Widget txListWidget,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Show Chart",
          ),
          Switch.adaptive(
              activeColor: Theme.of(context).primaryColor,
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              }),
        ],
      ),
      _showChart
          ? SizedBox(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransaction),
            )
          : txListWidget,
    ];
  }

  List<Widget> _buildPortraitContent(
    MediaQueryData mediaQuery,
    PreferredSizeWidget appBar,
    Widget txListWidget,
  ) {
    return [
      SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransaction),
      ),
      txListWidget
    ];
  }

  PreferredSizeWidget _buildAppBar() {
    return (Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text(
              "Personal expenses",
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () => _startNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: const Text(
              "Personal expenses",
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
            actions: [
              IconButton(
                onPressed: () => _startNewTransaction(context),
                icon: const Icon(Icons.add),
              ),
            ],
          )) as PreferredSizeWidget;
  }

  @override
  Widget build(BuildContext context) {
    print("build() _MyHomePageState");
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = _buildAppBar();

    final txListWidget = SizedBox(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final appBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              ..._buildLandscapeContent(
                mediaQuery,
                appBar,
                txListWidget,
              ),
            if (!isLandscape)
              ..._buildPortraitContent(
                mediaQuery,
                appBar,
                txListWidget,
              ),
            // if (isLandscape)
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: appBody,
          )
        : Scaffold(
            appBar: appBar,
            body: appBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _startNewTransaction(context),
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.6),
                    child: const Icon(Icons.add),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
