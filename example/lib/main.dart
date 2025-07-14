import 'package:flutter/material.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/basic/dynamic_widget_json_exportor.dart';

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
  "type": "ListView",
  "children": [
    {
      "type": "Container",
      "height": 100,
      "child": {
        "type": "Stack",
        "alignment": "topLeft",
        "children": [
          {
            "type": "Positioned",
            "top": 0,
            "left": 0,
            "child": {
              "type": "Text",
              "data": "Item 1"
            }
          },
          {
            "type": "Positioned",
            "top": 20,
            "left": 0,
            "child": {
              "type": "Text",
              "data": "Item 2"
            }
          }
        ]
      }
    }
  ]
}

'''), // ← JSON hanya isi body
    );
  }
}

// ignore: must_be_immutable
class PreviewPage extends StatelessWidget {
  final String jsonString;
  DynamicWidgetJsonExportor? _exportor;

  PreviewPage(this.jsonString);

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

        return Scaffold(
          appBar: AppBar(
            title: const Text('Preview'),
            backgroundColor: Colors.blue,
          ),
          body: _exportor,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            onTap: (index) {
              // Ganti tab di sini
            },
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        );
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
