import 'package:flutter/material.dart';
import 'dart:convert';

typedef CustomUIConfigCallback = void Function(Map<String, dynamic> customUIConfig);

class CustomUIConfigWidget extends StatefulWidget {

  CustomUIConfigWidget({
    Key key,
    @required this.config,
    @required this.callback
  }):super(key: key);

  /// customUIConfig
  final Map<String, dynamic> config;

  ///confirm result callback
  final CustomUIConfigCallback callback;

  @override
  _CustomUIConfigState createState() => _CustomUIConfigState();

}

class _CustomUIConfigState extends State<CustomUIConfigWidget> {

  TextEditingController _customUIConfigController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _customUIConfigController.text = jsonEncode(widget.config).replaceAll(',', ',\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SetCustomUIConfig'),
      ),
      body: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: _customUIConfigController,
                  decoration: InputDecoration(
                    labelText: 'CustomUIConfig',
                    hintText: '请输入自定义配置'
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28.0, left: 15.0, right: 15.0, bottom: 28.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: RaisedButton(
                        child: Text('确认'),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          if (widget.callback != null) {
                            widget.callback(jsonDecode(_customUIConfigController.text));
                            Navigator.pop(context);
                          }
                        },
                      )),
                    ],
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}