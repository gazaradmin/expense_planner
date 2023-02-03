import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  const NewTransaction(this.addTx, {super.key});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? _selectedDate;

  void _onSubmit() {
    if (titleController.text.isEmpty ||
        amountController.text.isEmpty ||
        _selectedDate == null) {
      return;
    }
    widget.addTx(
      titleController.text,
      double.parse(amountController.text),
      _selectedDate,
    );
    Navigator.of(context).pop();
  }

  void _persentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((value) => {
          setState(
            () {
              _selectedDate = value!;
            },
          )
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          margin: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  label: Text("Title"),
                ),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text("Amount"),
                ),
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Text(
                      _selectedDate == null
                          ? "No Date Chosen!"
                          : DateFormat.yMd().format(_selectedDate!),
                    ),
                    AdaptiveFlatButton("Choose Date", _persentDatePicker)
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _onSubmit,
                child: const Text(
                  "Add Transaction",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
