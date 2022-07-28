import 'dart:io';

import 'package:costs_manager/models/transaction.dart';
import 'package:costs_manager/widgets/chart.dart';
import 'package:costs_manager/widgets/new_transaction.dart';
import 'package:costs_manager/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool _showChart = false;
  final List<Transaction> _transactions = [
    Transaction(
      id: 't1',
      title: 'new Shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Weekly banana',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't3',
      title: 'Weekly banana',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't4',
      title: 'Weekly banana',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't5',
      title: 'Weekly banana',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't6',
      title: 'Weekly banana',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't7',
      title: 'Weekly banana',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't8',
      title: 'Weekly banana',
      amount: 69.99,
      date: DateTime.now(),
    ),
  ];

  List<Transaction> get _recentTransactions {
    return _transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
    String txTitle,
    double txAmount,
    DateTime date,
  ) {
    final newTx = Transaction(
      id: DateTime.now().toUtc().toString(),
      title: txTitle,
      amount: txAmount,
      date: date,
    );

    setState(() {
      _transactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: NewTransaction(_addNewTransaction));
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tx) => tx.id == id);
    });
  }

  _buildAppBar(BuildContext context, bool isIos) {
    late final Widget appBar;
    if (isIos) {
      appBar = CupertinoNavigationBar(
        middle: const Text('Costs Manager'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(
                CupertinoIcons.add,
                size: 35,
              ),
              onPressed: () => _startAddNewTransaction(context),
            ),
          ],
        ),
      );
    } else {
      appBar = AppBar(
        title: const Text(
          'Costs Manager',
          style: TextStyle(fontFamily: "OpenSans"),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () => _startAddNewTransaction(context),
          )
        ],
      );
    }
    return appBar;
  }

  List<Widget> _buildLanscapeContent(
    MediaQueryData mediaQuery,
    appBar,
    Widget txListWidget,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.headline6,
          ),
          // adaptive for ios
          Switch.adaptive(
            value: _showChart,
            onChanged: (value) {
              setState(() {
                _showChart = value;
              });
            },
          ),
        ],
      ),
      _showChart
          ? SizedBox(
              child: Chart(_recentTransactions),
              // ? INFO: it's necessary for full screen height size, without scroll (height screen - appbar - statusbar)
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
            )
          : txListWidget,
    ];
  }

  List<Widget> _buildPortraitContent(
    MediaQueryData mediaQuery,
    appBar,
    Widget txListWidget,
  ) {
    return [
      SizedBox(
        child: Chart(_recentTransactions),

        // ? INFO: it's necessary for full screen height size, without scroll (height screen - appbar - statusbar)
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
      ),
      txListWidget
    ];
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    // app work after app closed (but launch in memory)
    WidgetsBinding.instance!.addObserver(this);
    
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // ? NOTE: best practices for most effective perfomance
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    //! CHANGE
    final bool isIos = Platform.isIOS;
    // final bool isIos = Platform.isAndroid;

    late final appBar = _buildAppBar(context, isIos);

    final txListWidget = SizedBox(
      child: TransactionList(_transactions, _deleteTransaction),
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          (isLandscape ? 1.0 : 0.7),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // only landscape
            if (isLandscape)
              ..._buildLanscapeContent(
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
          ],
        ),
      ),
    );

    return isIos
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                _startAddNewTransaction(context);
              },
            ),
          );
  }
}
