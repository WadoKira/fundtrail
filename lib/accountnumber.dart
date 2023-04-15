import 'package:flutter/material.dart';


class AccountnumberPage extends StatefulWidget {
  final List<double>? numberset;
  const AccountnumberPage({Key? key,this.numberset}) : super(key: key);

  @override
  State<AccountnumberPage> createState() => _AccountnumberPage();
}

class _AccountnumberPage extends State<AccountnumberPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount:widget.numberset!.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,

              child: Center(child: Text('Account numbers are ${widget.numberset![index]}')),
            );
          }
      ),
      appBar: AppBar(
        title: Center(child: Text('Account numbers Page')),

      ),
    );
  }






}
