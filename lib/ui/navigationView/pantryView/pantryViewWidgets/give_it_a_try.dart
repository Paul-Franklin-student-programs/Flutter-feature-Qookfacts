import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../models/checkditem.dart';
import '../../../../services/elastic/endpoints/users_service.dart';
import '../../../../services/services.dart';

class GiveItATry extends StatefulWidget {
  @override
  State<GiveItATry> createState() => _GiveItATryState();
}

class _GiveItATryState extends State<GiveItATry> {
  List<dynamic> apiitemlist = [];
  List<dynamic> ditemlist = [];
  Box ditembox;

  // CheckDitem hiverespons;

  @override
  // List<String> name= [];
  // var name;
  void initState() {
    // TODO: implement initState
    super.initState();
    showdata();
    // ditemlist();
    // var box = Hive.box('testbox');
    // if(box.isNotEmpty ) {
    // for (int i = 0; i <= box.length; i++) {
    //   name.add(box.get(i));
    //
    //
    // }
    // print("11111111111111111111111111112121111111111111");
    // print(name[0]);
    // print(box.get('dave')); // Dave
    // }
  }

  Future showdata() async {
    // setState(() {
    //   ditemlist = box.values.toList();
    // });
    // for (int i = 0; i < listEmployees.length; i++) {
    //   print("qqqqqqqqqqqqqqqqqqqqq......................qqqqqqqqqqqqqqqqqq");
    //   print(listEmployees[i]);
    //
    //   print("j11111111111111111");
    //   await UsersService.detectedItem();
    //
    // }
    ditembox = await Hive.openBox('DItem');
    // final apibox = await Hive.openBox('ApiItem');

    // apiitemlist =  apibox.values.toList();
    ditemlist = ditembox.values.toList();
    setState(() {});
    // print(
    //     "--------------------------------------0--------------------------------");
    // print(apiitemlist.length);
    //
    // for (int i = 0; i < apiitemlist.length; i++) {
    //   print(apiitemlist[i].name);
    //   print(apiitemlist[i].url);
    // }

    return;
  }

  // ditemlist() async {
  //   respons= await usersService.detectedItem();
  //   print("--------------------------------------respons--------------------------------");

  // for(int i = 0; i<respons.items.length; i++)
  //   {
  //
  //     print(respons.items[i].name);
  //     print(respons.items[i].imageUrl);
  //   }

  // }

  @override
  Widget build(BuildContext context) {
    return

        // apiitemlist.isNotEmpty? Container(
        //      height: 500.0,
        //
        //      width: double.infinity,
        //      child: ListView.builder(
        //          itemCount: apiitemlist.length,
        //          itemBuilder: (context, index) {
        //            return Container(
        //              child: Column(children: [
        //                Image.network(apiitemlist[index].url),
        //                Text(apiitemlist[index].name,style: TextStyle(fontSize: 30.0),)
        //
        //              ],),
        //
        //            );
        //          }
        //      ),
        //    ):

        ditemlist.isNotEmpty
            ? Container(
                height: 500.0,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: ditemlist.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Card(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                ditemlist[index].replaceFirst(
                                    ditemlist[index][0],
                                    ditemlist[index][0].toUpperCase()),
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'opensans',
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  ditembox.deleteAt(index);
                                  ditemlist.removeAt(index);
                                  setState(() {});
                                },
                                icon: Icon(Icons.clear))
                          ],
                        )),
                      );
                    }),
              )
            : Container(
                width: 70,
                height: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'Go ahead and try it out!',
                            style: GoogleFonts.openSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Icon(
                        Icons.tag_faces,
                        size: 36,
                      ),
                    )
                  ],
                ),
              );
  }
}
