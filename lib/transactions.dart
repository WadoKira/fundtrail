import 'package:flutter/material.dart';


class TransactionsPage extends StatefulWidget {
  final double tax;
  final List<double>? numbersSet;

  const TransactionsPage({Key? key,this.numbersSet,required this.tax}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPage();
}

class _TransactionsPage extends State<TransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: widget.numbersSet!.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  child: Center(
                    child: Text('Account numbers are ${widget.numbersSet![index]}'),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Tax: ${widget.tax}'),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text('Transactions Page'),
        centerTitle: true,
      ),
    );
  }
}