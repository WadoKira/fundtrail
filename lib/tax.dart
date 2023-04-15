import 'package:flutter/material.dart';

class taxPage extends StatefulWidget {
  final double tax;
  const taxPage({Key? key,required this.tax}) : super(key: key);

  @override
  State<taxPage> createState() => _taxPage();
}

class _taxPage extends State<taxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 1,
          padding: const EdgeInsets.all(8),
          itemBuilder: (BuildContext context, int index) {
            return Container(

              height: 50,
              child: Center(child: Text('Tax is ${widget.tax}')),
            );
          }
      ),
      appBar: AppBar(
        title: Center(child: Text('Tax Page')),
      ),
    );
  }
}
