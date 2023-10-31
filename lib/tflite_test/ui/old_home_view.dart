import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qookit/app/app_router.gr.dart';
import 'package:stacked/stacked.dart';
import '../../ui/navigationView/navigation_view_model.dart';
import '../tflite/recognition.dart';
import '../tflite/stats.dart';
import '../ui/box_widget.dart';
import 'camera_view.dart';
import 'package:auto_route/annotations.dart';

@RoutePage()
/// [OldHomeView] stacks [CameraView] and [BoxWidget]s with bottom sheet for stats
class OldHomeView extends StatefulWidget {
  @override
  _OldHomeViewState createState() => _OldHomeViewState();
}

class _OldHomeViewState extends State<OldHomeView> {
  /// Results to draw bounding boxes
  // List<dynamic> ditemlist = [];
  bool itemCheck = false;
  List<Recognition> results = [];
  List<dynamic> apiitemlist = [];
  List<String> lablestring = [
    'Dill',
    'Garden onion',
    'Leek',
    'Allium',
    'Angelica'
  ];

  // List<String> mylabel=[];
  // int i=0;
  /// Realtime stats
  Stats stats = Stats.empty();
  Box? box;

  /// Scaffold Key
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openBox();
    // detectedItem(
    //
    //     friends: results
    // );
  }

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('DItem');
    final apibox = await Hive.openBox('ApiItem');
    apiitemlist = apibox.values.toList();
    print(
        '--------------------------------------respons--------------------------------');
    for (int i = 0; i < apiitemlist.length; i++) {
      print(
          '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
      print(apiitemlist[i].name);
      // print(apiitemlist[i].url);

    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/images/qookit_full.svg',
          color: Colors.white,
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios_outlined),
        ),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
              icon: Icon(Icons.android),
              onPressed: () {

              })
        ],
      ),
      body: Stack(
        children: <Widget>[
          // Camera View
          CameraView(resultsCallback, statsCallback),

          // Bounding boxes
          boundingBoxes(results),

          // Bottom Sheet
          Align(
            // alignment: Alignment.bottomCenter,
            child: DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.1,
              maxChildSize: 0.7,
              builder: (_, ScrollController scrollController) => Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BORDER_RADIUS_BOTTOM_SHEET),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                topLeft: Radius.circular(8),
                              )),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 5,
                                width: 80,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(2)),
                              )
                            ],
                          ),
                        ),
                        (stats != null)
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    StatsRow('Inference time:',
                                        '${stats.inferenceTime} ms'),
                                    StatsRow('Total prediction time:',
                                        '${stats.totalElapsedTime} ms'),
                                    StatsRow('Pre-processing time:',
                                        '${stats.preProcessingTime} ms'),
                                    /*StatsRow('Frame',
                                  '${CameraViewSingleton.inputImageSize?.width} X ${CameraViewSingleton.inputImageSize?.height}'),*/
                                  ],
                                ),
                              )
                            : Container(),
                        Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            'Items Detected',
                            style: TextStyle(
                                fontFamily: 'opensans',
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Divider(
                          height: 2,
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            for (Recognition obj in results)
                              Card(
                                elevation: 4,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        obj.label.replaceFirst(obj.label[0],
                                            obj.label[0].toUpperCase()),
                                        style: TextStyle(
                                            fontFamily: 'opensans',
                                            fontWeight: FontWeight.w400),
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {}),
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          color: Colors.white30,
                          child: ElevatedButton(
                            onPressed: () {
                              //TODO: add ingredient
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 18,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Add Ingredient',
                                  style: TextStyle(
                                      fontFamily: 'opensans',
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Add Items To',
                                style: TextStyle(
                                    fontFamily: 'opensans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                              DropdownButton(
                                value: 'pantry',
                                style: TextStyle(
                                    fontFamily: 'opensans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black),
                                items: [
                                  DropdownMenuItem(
                                    child: Text('Pantry'),
                                    value: 'pantry',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Fridge'),
                                    value: 'fridge',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Freezer'),
                                    value: 'freezer',
                                  ),
                                ],
                                onChanged: (value) {
                                  //   model.destination = value;
                                  // model.notifyListeners();
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 24),
                          // color: Colors.amber,
                          child: ElevatedButton(
                            child: Text(
                              'ADD ITEMS',
                              style: TextStyle(
                                  fontFamily: 'opensans',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            // color: Colors.amber,
                            onPressed: () {

                              for (int i = 0; i < results.length; i++) {

                                box!.add(results[i].label.toString());
                                print(results[i]);
                              }

                              if (results.isNotEmpty) {
                                ExtendedNavigator.named('nestedNav')
                                    ?.push(NavigationViewRoutes.pantryView);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Container(
                          width: 100,
                          child: TextButton(
                              child: Text(
                                'Clear All',
                                style: TextStyle(fontFamily: 'opensans'),
                              ),
                              onPressed: () async {
                                // TODO: clear ingredients
                                //  model.detectedObjects = [];
                                // model.notifyListeners();
                                await box!.deleteFromDisk();
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns Stack of bounding boxes
  Widget boundingBoxes(List<Recognition> results) {
    if (results == null) {
      return Container();
    }
    return Stack(
      children: results
          .map((e) => BoxWidget(
                result: e,
              ))
          .toList(),
    );
  }

  /// Callback to get inference results from [CameraView]
  void resultsCallback(List<Recognition> results) {
    setState(() {
      this.results = results;
    });
  }

  /// Callback to get inference stats from [CameraView]
  void statsCallback(Stats stats) {
    setState(() {
      this.stats = stats;
    });
  }

  static const BOTTOM_SHEET_RADIUS = Radius.circular(24.0);
  static const BORDER_RADIUS_BOTTOM_SHEET = BorderRadius.only(
      topLeft: BOTTOM_SHEET_RADIUS, topRight: BOTTOM_SHEET_RADIUS);
}

/// Row for one Stats field
class StatsRow extends StatelessWidget {
  final String left;
  final String right;

  StatsRow(this.left, this.right);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style:
                TextStyle(fontFamily: 'opensans', fontWeight: FontWeight.w600),
          ),
          Text(
            right,
            style:
                TextStyle(fontFamily: 'opensans', fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
