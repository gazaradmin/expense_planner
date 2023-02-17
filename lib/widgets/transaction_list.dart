import 'package:expense_planner/widgets/transaction_item.dart';

import '../models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  const TransactionList(
    this.transactions,
    this.deleteTx, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                const Text("Transaction is empty!"),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset("assets/images/waiting.png"),
                )
              ],
            );
          })
        : ListView(
            children: transactions
                .map((tx) => TransactionItem(
                      key: ValueKey(tx.id),
                      transaction: tx,
                      deleteTx: deleteTx,
                    ))
                .toList(),
          );
  }
}
