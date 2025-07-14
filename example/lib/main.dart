import 'package:flutter/material.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/basic/dynamic_widget_json_exportor.dart';
import 'widget_json.dart'; // berisi listviewJson

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dynamic Widget',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PreviewPage('''
{
  "type": "Scaffold",
  "appBar": {
    "type": "AppBar",
    "centerTitle": true,
    "backgroundColor": "#e1e1e1",
    "title": {
      "type": "Text",
      "data": "Dynamic Title",
      "style": {
        "color": "61000000",
        "fontSize": 20,
        "fontWeight": "normal"
      }
    }
  },
  "body": {
    "type": "Text",
    "data": "Hello World",
    "style": {}
  },
  "bottomNavigationBar": {
    "type": "BottomNavigationBar",
    "backgroundColor": "#FFFFFF",
    "currentIndex": 0,
    "items": [
      {
        "type": "BottomNavigationBarItem",
        "label": "Item",
        "icon": {
          "type": "Icon",
          "codePoint": 59530,
          "fontFamily": "MaterialIcons"
        }
      }
    ]
  }
}
'''),
    );
  }
}

// ignore: must_be_immutable
class PreviewPage extends StatelessWidget {
  final String jsonString;

  PreviewPage(this.jsonString);

  DynamicWidgetJsonExportor? _exportor;

  Future<Widget?> _buildWidget(BuildContext context) async {
    return DynamicWidgetBuilder.build(
      jsonString,
      context,
      DefaultClickListener(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget?>(
      future: _buildWidget(context),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Material(
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        if (!snapshot.hasData) {
          return Material(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        _exportor = DynamicWidgetJsonExportor(child: snapshot.data!);
        return _exportor!;
      },
    );
  }
}
class DefaultClickListener implements ClickListener {
  @override
  void onClicked(String? event) {
    debugPrint("Receive click event: ${event ?? ''}");
  }
}
