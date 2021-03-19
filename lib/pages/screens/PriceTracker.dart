import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fyp_uiprototype/auth_service/FirebaseAuthService.dart';
import 'package:get/get.dart';
import 'package:fyp_uiprototype/common_widget/dataController.dart';
import 'package:fyp_uiprototype/pages/screens/ProductPage.dart';

class PriceTracker extends StatefulWidget {
  final weekDays = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  final List<double> yValues = [1.3, 1, 1.8, 1.5, 2.2, 1.8, 3];

  @override
  State createState() => _PriceTrackerState();
}

class _PriceTrackerState extends State<PriceTracker> {
  double touchedValue;

  final userId = currentUserId();
  bool flag = false;
  //Deal with Display
  List<dynamic> arrList = [];
  //Deal with Chart
  List<dynamic> arrPrice = [];
  List<dynamic> yValuesPrice = [];
  List<dynamic> xValuesDate = [];
  //Snap pricehistory Collection
  QuerySnapshot snapshotprice;
  //User's TrackerList
  var arrData;

  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    touchedValue = -1;
    super.initState();

    void comparePrice() async {
      snapshotprice = await FirebaseFirestore.instance.collection('pricehistory').get();

      // for (var i = 0; i < snapshotprice.docs.length; i++) {
      //   print(snapshotprice.docs[i].data()['id']);
      //   print(snapshotprice.docs[i].data()['pricedate'][0]);
      // }

      //print(snapshotprice.docs[0].data()['id']);
    }

    void checkAndget() async {
      await userCheckPriceTracker(userId).then((value) {
        if (value == true) {
          setState(() {
            flag = true;
          });
          getPriceTracker(userId).then((value) {
            arrData = value;
            print("This is init $arrData");
          });
        } else if (value == false) {
          setState(() {
            flag = false;
          });
        }
      });
      comparePrice();
    }

    checkAndget();
  }

  Widget deleteBgItem() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (flag) {
      return Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   title: Text('Tools'),
        //   backgroundColor: Colors.white,
        // ),
        body: GetBuilder<DataController>(
          init: DataController(),
          builder: (value) {
            return FutureBuilder(
              future: value.getData('restaurant'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.black,
                    ),
                  );
                } else {
                  return new ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: arrData.length,
                    // ignore: missing_return
                    itemBuilder: (BuildContext context, int index) {
                      for (var i = 0; i < snapshot.data.length; i++) {
                        for (var k = 0; k < arrData.length; k++) {
                          if (arrData[k] == snapshot.data[i].reference.id) {
                            if (arrList.length < arrData.length) {
                              arrList.add(i);
                            }
                          }
                          if (arrData[k] == snapshotprice.docs[i].data()['id']) {
                            if (arrPrice.length < arrData.length) {
                              arrPrice.add(i);
                            }
                          }
                        }
                      }
                      print('$arrList \n $arrPrice');
                      //Store double values
                      for (var i = 0; i < snapshotprice.docs[arrPrice[index]].data()['price'].length; i++) {
                        var tempArr;
                        tempArr = snapshotprice.docs[arrPrice[index]].data()['price'];
                        if (yValuesPrice.length < 3) {
                          yValuesPrice.add(double.parse(tempArr[i]));
                        } else if (yValuesPrice.length >= 3) {
                          print('this is good ${yValuesPrice[i]}');
                          yValuesPrice[i] = double.parse(tempArr[i]);
                        }
                        //print(yValuesPrice);
                      }
                      xValuesDate = snapshotprice.docs[arrPrice[index]].data()['pricedate'];
                      //yValuesPrice = snapshotprice.docs[arrPrice[index]].data()['price'];
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => ProductPage(
                              storesId: snapshot.data[arrList[index]].data()['id'],
                              storesName: snapshot.data[arrList[index]].data()['name'],
                              storesAddress: snapshot.data[arrList[index]].data()['address'],
                              latitude: snapshot.data[arrList[index]].data()['location'].latitude,
                              longitude: snapshot.data[arrList[index]].data()['location'].longitude,
                              gmap: snapshot.data[arrList[index]].data()['gmap'],
                              image: snapshot.data[arrList[index]].data()['image'],
                              link: snapshot.data[arrList[index]].data()['link'],
                              source: snapshot.data[arrList[index]].data()['source'],
                              rating: snapshot.data[arrList[index]].data()['rating'],
                            ),
                            transition: Transition.leftToRightWithFade,
                            arguments: snapshot.data[arrList[index]],
                          );
                        },
                        child: Dismissible(
                          key: Key(snapshot.data[arrList[index]].reference.id),
                          onDismissed: (_) {
                            deletefromPriceTracker(userId, snapshot.data[arrList[index]].reference.id);
                          },
                          background: deleteBgItem(),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Card(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                snapshot.data[arrPrice[index]].data()['name'],
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 18,
                                          ),
                                          SizedBox(
                                            width: 300,
                                            height: 140,
                                            child: LineChart(
                                              LineChartData(
                                                lineTouchData: LineTouchData(
                                                    getTouchedSpotIndicator:
                                                        (LineChartBarData barData, List<int> spotIndexes) {
                                                      return spotIndexes.map((spotIndex) {
                                                        //final FlSpot spot = barData.spots[spotIndex];
                                                        /*
                                                        if (spot.x == 0 || spot.x == 2) {
                                                          return null;
                                                        }
                                                        */
                                                        return TouchedSpotIndicatorData(
                                                          FlLine(color: Colors.blue, strokeWidth: 4),
                                                          FlDotData(
                                                            getDotPainter: (spot, percent, barData, index) {
                                                              if (index % 2 == 0) {
                                                                return FlDotCirclePainter(
                                                                    radius: 8,
                                                                    color: Colors.white,
                                                                    strokeWidth: 5,
                                                                    strokeColor: Colors.deepOrange);
                                                              } else {
                                                                return FlDotSquarePainter(
                                                                  size: 16,
                                                                  color: Colors.white,
                                                                  strokeWidth: 5,
                                                                  strokeColor: Colors.deepOrange,
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        );
                                                      }).toList();
                                                    },
                                                    touchTooltipData: LineTouchTooltipData(
                                                        tooltipBgColor: Colors.blueAccent,
                                                        getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                                          return touchedBarSpots.map((barSpot) {
                                                            final flSpot = barSpot;
                                                            /*
                                                            if (flSpot.x == 0 || flSpot.x == 2) {
                                                              return null;
                                                            }
                                                            */
                                                            return LineTooltipItem(
                                                              '${xValuesDate[flSpot.x.toInt()]} \n${flSpot.y}',
                                                              const TextStyle(color: Colors.white),
                                                            );
                                                          }).toList();
                                                        }),
                                                    touchCallback: (LineTouchResponse lineTouch) {
                                                      if (lineTouch.lineBarSpots.length == 1 &&
                                                          lineTouch.touchInput is! FlLongPressEnd &&
                                                          lineTouch.touchInput is! FlPanEnd) {
                                                        final value = lineTouch.lineBarSpots[0].x;

                                                        if (value == 0 || value == 2) {
                                                          setState(() {
                                                            touchedValue = -1;
                                                          });
                                                          return null;
                                                        }

                                                        setState(() {
                                                          touchedValue = value;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          touchedValue = -1;
                                                        });
                                                      }
                                                    }),
                                                extraLinesData: ExtraLinesData(horizontalLines: [
                                                  HorizontalLine(
                                                    y: 1.8,
                                                    color: Colors.green.withOpacity(0.8),
                                                    strokeWidth: 3,
                                                    dashArray: [20, 2],
                                                  ),
                                                ]),
                                                lineBarsData: [
                                                  LineChartBarData(
                                                    isStepLineChart: true,
                                                    spots: yValuesPrice.asMap().entries.map((e) {
                                                      return FlSpot(e.key.toDouble(), e.value);
                                                    }).toList(),
                                                    isCurved: false,
                                                    barWidth: 4,
                                                    colors: [
                                                      Colors.orange,
                                                    ],
                                                    belowBarData: BarAreaData(
                                                      show: true,
                                                      colors: [
                                                        Colors.orange.withOpacity(0.5),
                                                        Colors.orange.withOpacity(0.0),
                                                      ],
                                                      gradientColorStops: [0.5, 1.0],
                                                      gradientFrom: const Offset(0, 0),
                                                      gradientTo: const Offset(0, 1),
                                                      spotsLine: BarAreaSpotsLine(
                                                        show: true,
                                                        flLineStyle: FlLine(
                                                          color: Colors.blue,
                                                          strokeWidth: 2,
                                                        ),
                                                        checkToShowSpotLine: (spot) {
                                                          /*
                                                          if (spot.x == 0 || spot.x == 2) {
                                                            return false;
                                                          }
                                                          */
                                                          return true;
                                                        },
                                                      ),
                                                    ),
                                                    dotData: FlDotData(
                                                      show: true,
                                                      getDotPainter: (spot, percent, barData, index) {
                                                        if (index % 2 == 0) {
                                                          return FlDotCirclePainter(
                                                              radius: 6,
                                                              color: Colors.white,
                                                              strokeWidth: 3,
                                                              strokeColor: Colors.deepOrange);
                                                        } else {
                                                          return FlDotSquarePainter(
                                                            size: 12,
                                                            color: Colors.white,
                                                            strokeWidth: 3,
                                                            strokeColor: Colors.deepOrange,
                                                          );
                                                        }
                                                      },
                                                      /*
                                                        checkToShowDot: (spot, barData) {
                                                          return spot.x != 0 && spot.x != 2;
                                                        }*/
                                                    ),
                                                  ),
                                                ],
                                                minY: 0,
                                                gridData: FlGridData(
                                                  show: true,
                                                  drawHorizontalLine: true,
                                                  drawVerticalLine: true,
                                                  getDrawingHorizontalLine: (value) {
                                                    if (value == 0) {
                                                      return FlLine(
                                                        color: Colors.deepOrange,
                                                        strokeWidth: 2,
                                                      );
                                                    } else {
                                                      return FlLine(
                                                        color: Colors.grey,
                                                        strokeWidth: 0.5,
                                                      );
                                                    }
                                                  },
                                                  getDrawingVerticalLine: (value) {
                                                    if (value == 0) {
                                                      return FlLine(
                                                        color: Colors.black,
                                                        strokeWidth: 2,
                                                      );
                                                    } else {
                                                      return FlLine(
                                                        color: Colors.grey,
                                                        strokeWidth: 0.5,
                                                      );
                                                    }
                                                  },
                                                ),
                                                titlesData: FlTitlesData(
                                                  show: true,
                                                  leftTitles: SideTitles(
                                                    showTitles: true,
                                                    reservedSize: 30,
                                                    getTitles: (value) {
                                                      switch (value.toInt()) {
                                                        case 0:
                                                          return '';
                                                        case 100:
                                                          return '100';
                                                        case 200:
                                                          return '200';
                                                        case 300:
                                                          return '300';
                                                        case 400:
                                                          return '400';
                                                        case 600:
                                                          return '600';
                                                      }
                                                      return '';
                                                    },
                                                    getTextStyles: (value) =>
                                                        const TextStyle(color: Colors.black, fontSize: 10),
                                                  ),
                                                  bottomTitles: SideTitles(
                                                    showTitles: true,
                                                    getTitles: (value) {
                                                      return xValuesDate[value.toInt()];
                                                    },
                                                    getTextStyles: (value) {
                                                      final isTouched = value == touchedValue;
                                                      return TextStyle(
                                                        color: isTouched
                                                            ? Colors.deepOrange
                                                            : Colors.deepOrange.withOpacity(0.5),
                                                        fontWeight: FontWeight.bold,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            );
          },
        ),
      );
    } else if (!flag) {
      return Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   title: Text('Tools'),
        //   backgroundColor: Colors.white,
        // ),
        body: Center(
          child: Text('The PriceTracker is Empty'),
        ),
      );
    }
    return CircularProgressIndicator();
  }
}
