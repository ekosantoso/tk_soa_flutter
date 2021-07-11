
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tk_soa_flutter/widgets/air.dart';
import 'package:tk_soa_flutter/widgets/listrik.dart';
import 'package:tk_soa_flutter/widgets/tv.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen() : super();


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showNew = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Bayar Tagihan'),
            actions: [
              DropdownButton(
                underline: Container(),
                icon: Icon(
                  Icons.more_vert,
                  color: Theme
                      .of(context)
                      .primaryIconTheme
                      .color,
                ),
                items: [
                  DropdownMenuItem(
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app),
                          SizedBox(
                            width: 3,
                          ),
                          Text('logout'),
                        ],
                      ),
                    ),
                    value: 'logout',
                  ),
                ],
                onChanged: (itemIdentifier) {
                  if (itemIdentifier == 'logout') {
                    // FirebaseAuth.instance.signOut();
                  }
                },
              )
            ],
            bottom: TabBar(
              onTap: (value) {

              },
              tabs: [
                Text("LISTRIK"),
                Text("TV KABEL"),
                Text("AIR"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              listrik(),
              TV(),
              air(),
            ],
          ),


        ),
      ),);
  }
}
