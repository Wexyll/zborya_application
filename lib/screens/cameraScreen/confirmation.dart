import 'package:flutter/material.dart';

import '../../domain/weapon.dart';

class confirmWeapons extends StatelessWidget {
  List<Weapon> wpnList = [];
  confirmWeapons({Key? key, required this.wpnList}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    print(wpnList.length);
    print("==============================");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Items Scanned'),
      ),
        body: Center(
            child: Text("Hi"),
        ),
    );
  }
}
