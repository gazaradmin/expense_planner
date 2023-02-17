import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  final Transaction transaction;
  final Function deleteTx;
  const TransactionItem(
      {super.key, required this.transaction, required this.deleteTx});

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color? _bgColor;

  List<Color> backgroundColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
  ];

  @override
  void initState() {
    _bgColor = backgroundColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: _bgColor,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text('\$${widget.transaction.amount}'),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? TextButton.icon(
                icon: const Icon(Icons.delete),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).errorColor,
                ),
                onPressed: () => widget.deleteTx(widget.transaction.id),
                label: const Text('Delete'),
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => widget.deleteTx(widget.transaction.id),
              ),
      ),
    );
    ;
  }
}
