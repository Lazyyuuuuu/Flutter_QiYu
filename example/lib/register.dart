import 'package:flutter/material.dart';

typedef RegisterCallback = void Function(String appkey, String appName);

class RegisterWidget extends StatefulWidget {

  RegisterWidget({
    Key key,
    @required this.appKey,
    @required this.appName,
    @required this.callback
}):super(key: key);

  /// AppID
  final String appKey;

  /// Your App Name
  final String appName;

  ///confirm result callback
  final RegisterCallback callback;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterWidget> {

  TextEditingController _appKeyController = TextEditingController();
  TextEditingController _appNameController = TextEditingController();



  @override
  void initState() {
    super.initState();

    _appKeyController.text = widget.appKey;
    _appNameController.text = widget.appName;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Page'),
      ),
      body: Column(
          children: <Widget>[
            TextFormField(
              controller: _appKeyController,
              decoration: InputDecoration(
                  labelText: 'AppKey',
                  hintText: '请输入七鱼AppKey',
                  icon: Icon(Icons.phone_android)
              ),
              validator: (value){
                return value.trim().length > 0 ? null : "AppKey不能为空";
              },
            ),
            TextFormField(
              controller: _appNameController,
              decoration: InputDecoration(
                  labelText: 'AppName',
                  hintText: '请输入APP名字',
                  icon: Icon(Icons.apps)
              ),
              validator: (value){
                return value.trim().length > 0 ? null : "AppName不能为空";
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28.0, left: 15.0, right: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(child: RaisedButton(
                    child: Text('确认'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if (widget.callback != null) {
                        widget.callback(_appKeyController.text, _appNameController.text);
                        Navigator.pop(context);
                      }
                    },
                  )),
                ],
              ),
            ),
        ]
      ),
    );
  }
}