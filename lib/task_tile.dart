import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'task_data.dart';

class TaskTile extends StatelessWidget {
  final String taskTitle;
  final String taskMessage;
  final String taskPrice;
  final Function longPressCallback;

  TaskTile(
      {this.taskTitle,
      this.taskMessage,
      this.taskPrice,
      this.longPressCallback});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return Container(
          padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          height: 200,
          child: Card(
            color: Colors.white70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: (MediaQuery.of(context).size.width) / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.network(
                          'https://i.gyazo.com/c9ba1b20aa2689694a7314ddd06f1202.jpg'),
                    ],
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width - 100) / 1.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 1.0),
                            width: 150,
                            child: Text(
                              taskTitle,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 26,
                            ),
                            onPressed: () async {
                              var result = await showDialog<int>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                    title: Text("本当に削除しますか？"),
                                    children: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'キャンセル',
                                          style: TextStyle(
                                              color: Colors.redAccent),
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          longPressCallback();
                                        },
                                        child: Text('削除'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: Text(
                                taskMessage,
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      taskData.decrementCounter();
                                    },
                                  ),
                                  Text(
                                    Provider.of<TaskData>(context)
                                        .shoppingCartCount
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      taskData.incrementCounter();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: Text(
                                taskPrice,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
