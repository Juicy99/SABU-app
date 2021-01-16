import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'order.dart';
import 'order_notify.dart';

// ignore: must_be_immutable
class SchedulePage1 extends StatelessWidget {
  List<charts.Series<CartHistory2, String>> _seriesBarData;
  List<CartHistory2> mydata;
  _generateData(mydata) {
    _seriesBarData = List<charts.Series<CartHistory2, String>>();
    _seriesBarData.add(
      charts.Series(
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (CartHistory2 sales, _) =>
            DateFormat("dd日hh時mm分").format(sales.createAt.toDate()),
        measureFn: (CartHistory2 sales, _) => sales.total,
        id: 'Sales',
        data: mydata,
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final authService = Provider.of<AuthService>(context);
    final historyService = Provider.of<OrderNotify>(context);
    // firestoreのデータはuidごとに分けているので、データの取得前にcartServiceにuidを渡してあげる
    historyService.uid = authService.user.uid;
    // streamのデータ(firestore)のデータが変更される度に自動でリビルドしてくれる
    return StreamBuilder<QuerySnapshot>(
      // firestoreからデータを拾ってくる
      stream: historyService.dataPath
          .where('createAt',
              isGreaterThanOrEqualTo: new DateTime(
                DateTime.now().year,
                DateTime.now().month,
                1,
                0,
                DateTime.now().weekday,
                1,
                0,
              ))
          .orderBy("createAt")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: // データの取得まち
            return CircularProgressIndicator();
          default:
            // streamからデータを取得できたので、使いやすい形にかえてあげる
            historyService.init(snapshot.data.docs);
            List<CartHistory2> sales = snapshot.data.docs
                .map((documentSnapshot) =>
                    CartHistory2.fromMap(documentSnapshot.data))
                .toList();
            return _buildChart(context, sales);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<CartHistory2> saledata) {
    mydata = saledata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: charts.BarChart(
                  _seriesBarData,
                  animate: true,
                  domainAxis: new charts.OrdinalAxisSpec(
                      renderSpec: new charts.SmallTickRendererSpec(
                          minimumPaddingBetweenLabelsPx: 0,
                          // Tick and Label styling here.
                          labelStyle: new charts.TextStyleSpec(
                              fontSize: 10, // size in Pts.
                              color: charts.MaterialPalette.black),

                          // Change the line colors to match text color.
                          lineStyle: new charts.LineStyleSpec(
                              color: charts.MaterialPalette.black))),

                  /// Assign a custom style for the measure axis.
                  primaryMeasureAxis: new charts.NumericAxisSpec(
                      renderSpec: new charts.GridlineRendererSpec(

                          // Tick and Label styling here.
                          labelStyle: new charts.TextStyleSpec(
                              fontSize: 10, // size in Pts.
                              color: charts.MaterialPalette.black),

                          // Change the line colors to match text color.
                          lineStyle: new charts.LineStyleSpec(
                              color: charts.MaterialPalette.black))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SchedulePage2 extends StatelessWidget {
  List<charts.Series<CartHistory2, String>> _seriesBarData;
  List<CartHistory2> mydata;
  _generateData(mydata) {
    _seriesBarData = List<charts.Series<CartHistory2, String>>();
    _seriesBarData.add(
      charts.Series(
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (CartHistory2 sales, _) =>
            DateFormat("dd日").format(sales.createAt.toDate()),
        measureFn: (CartHistory2 sales, _) => sales.total,
        id: 'Sales',
        data: mydata,
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final authService = Provider.of<AuthService>(context);
    final historyService = Provider.of<OrderNotify>(context);
    // firestoreのデータはuidごとに分けているので、データの取得前にcartServiceにuidを渡してあげる
    historyService.uid = authService.user.uid;
    // streamのデータ(firestore)のデータが変更される度に自動でリビルドしてくれる
    return StreamBuilder<QuerySnapshot>(
      // firestoreからデータを拾ってくる
      stream: historyService.dataPath
          .where('createAt',
              isGreaterThanOrEqualTo:
                  new DateTime(DateTime.now().year, DateTime.now().month, 1, 0))
          .orderBy("createAt")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: // データの取得まち
            return CircularProgressIndicator();
          default:
            // streamからデータを取得できたので、使いやすい形にかえてあげる
            historyService.init(snapshot.data.docs);
            List<CartHistory2> sales = snapshot.data.docs
                .map((documentSnapshot) =>
                    CartHistory2.fromMap(documentSnapshot.data))
                .toList();
            return _buildChart(context, sales);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<CartHistory2> saledata) {
    mydata = saledata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: charts.BarChart(
                  _seriesBarData,
                  animate: true,
                  domainAxis: new charts.OrdinalAxisSpec(
                      renderSpec: new charts.SmallTickRendererSpec(
                          minimumPaddingBetweenLabelsPx: 0,
                          // Tick and Label styling here.
                          labelStyle: new charts.TextStyleSpec(
                              fontSize: 10, // size in Pts.
                              color: charts.MaterialPalette.black),

                          // Change the line colors to match text color.
                          lineStyle: new charts.LineStyleSpec(
                              color: charts.MaterialPalette.black))),

                  /// Assign a custom style for the measure axis.
                  primaryMeasureAxis: new charts.NumericAxisSpec(
                      renderSpec: new charts.GridlineRendererSpec(

                          // Tick and Label styling here.
                          labelStyle: new charts.TextStyleSpec(
                              fontSize: 10, // size in Pts.
                              color: charts.MaterialPalette.black),

                          // Change the line colors to match text color.
                          lineStyle: new charts.LineStyleSpec(
                              color: charts.MaterialPalette.black))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SchedulePage3 extends StatelessWidget {
  List<charts.Series<CartHistory2, String>> _seriesBarData;
  List<CartHistory2> mydata;
  _generateData(mydata) {
    _seriesBarData = List<charts.Series<CartHistory2, String>>();
    _seriesBarData.add(
      charts.Series(
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (CartHistory2 sales, _) =>
            DateFormat("yyyy日MM月").format(sales.createAt.toDate()),
        measureFn: (CartHistory2 sales, _) => sales.total,
        id: 'Sales',
        data: mydata,
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final authService = Provider.of<AuthService>(context);
    final historyService = Provider.of<OrderNotify>(context);
    // firestoreのデータはuidごとに分けているので、データの取得前にcartServiceにuidを渡してあげる
    historyService.uid = authService.user.uid;
    // streamのデータ(firestore)のデータが変更される度に自動でリビルドしてくれる
    return StreamBuilder<QuerySnapshot>(
      // firestoreからデータを拾ってくる
      stream: historyService.dataPath.orderBy("createAt").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: // データの取得まち
            return CircularProgressIndicator();
          default:
            // streamからデータを取得できたので、使いやすい形にかえてあげる
            historyService.init(snapshot.data.docs);
            List<CartHistory2> sales = snapshot.data.docs
                .map((documentSnapshot) =>
                    CartHistory2.fromMap(documentSnapshot.data))
                .toList();
            return _buildChart(context, sales);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<CartHistory2> saledata) {
    mydata = saledata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: charts.BarChart(
                  _seriesBarData,
                  animate: true,
                  domainAxis: new charts.OrdinalAxisSpec(
                      renderSpec: new charts.SmallTickRendererSpec(
                          labelRotation: 60,
                          minimumPaddingBetweenLabelsPx: 0,
                          // Tick and Label styling here.
                          labelStyle: new charts.TextStyleSpec(
                              fontSize: 18, // size in Pts.
                              color: charts.MaterialPalette.black),

                          // Change the line colors to match text color.
                          lineStyle: new charts.LineStyleSpec(
                              color: charts.MaterialPalette.black))),

                  /// Assign a custom style for the measure axis.
                  primaryMeasureAxis: new charts.NumericAxisSpec(
                      renderSpec: new charts.GridlineRendererSpec(

                          // Tick and Label styling here.
                          labelStyle: new charts.TextStyleSpec(
                              fontSize: 10, // size in Pts.
                              color: charts.MaterialPalette.black),

                          // Change the line colors to match text color.
                          lineStyle: new charts.LineStyleSpec(
                              color: charts.MaterialPalette.black))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SchedulePage extends StatelessWidget {
  void countDocuments() async {
    QuerySnapshot _myDoc =
        await Firestore.instance.collection('product').getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    print(_myDocCount.length); // Count of Documents in Collection
  }

  Widget _top() {
    return Container();
  }

  Widget _tabView() {
    return DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: TabBar(
                tabs: [
                  Tab(
                    text: "1週間（時間）",
                  ),
                  Tab(text: "1ヶ月（日）"),
                  Tab(text: "総て（月）"),
                ],
                labelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
            Expanded(
              child: TabBarView(children: [
                SchedulePage1(),
                SchedulePage2(),
                SchedulePage3(),
              ]),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[_top(), Expanded(child: _tabView())],
        ),
      ),
    );
  }
}
