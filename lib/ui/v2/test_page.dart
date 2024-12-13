import 'package:flutter/material.dart';
import 'package:qookit/ui/v2/services/qookit_service.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: TestView(),
    );
  }
}

class TestView extends StatefulWidget {
  @override
  _TestViewState createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  String _result = '';

  void _fetchData() async {
    try {
      String result = "null";
      setState(() {
        _result = result;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _fetchData,
            child: Text('Fetch Data'),
          ),
          SizedBox(height: 20),
          Text(_result),
        ],
      ),
    );
  }
}
