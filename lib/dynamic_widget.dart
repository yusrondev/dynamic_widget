library dynamic_widget;

import 'dart:convert';

import 'package:dynamic_widget/dynamic_widget/basic/align_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/appbar_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/aspectratio_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/baseline_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/bottom_navigation_bar_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/button_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/card_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/center_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/colored_box_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/container_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/divider_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/dropcaptext_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/dynamic_widget_json_exportor.dart';
import 'package:dynamic_widget/dynamic_widget/basic/expanded_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/fittedbox_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/flutter_svg_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/icon_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/image_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/indexedstack_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/limitedbox_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/listtile_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/offstage_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/opacity_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/padding_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/placeholder_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/repaint_boundary_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/row_column_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/safearea_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/scaffold_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/selectabletext_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/sizedbox_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/stack_positioned_widgets_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/text_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/basic/wrap_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/scrolling/gridview_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/scrolling/listview_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/scrolling/pageview_widget_parser.dart';
import 'package:dynamic_widget/dynamic_widget/scrolling/single_child_scroll_view_widget_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:jsf/jsf.dart';

import 'dynamic_widget/basic/cliprrect_widget_parser.dart';
import 'dynamic_widget/basic/overflowbox_widget_parser.dart';
import 'dynamic_widget/basic/rotatedbox_widget_parser.dart';

class DynamicWidgetBuilder {
  static final Logger log = Logger('DynamicWidget');

  static final _parsers = [
    ContainerWidgetParser(),
    TextWidgetParser(),
    SelectableTextWidgetParser(),
    RowWidgetParser(),
    ColumnWidgetParser(),
    AssetImageWidgetParser(),
    NetworkImageWidgetParser(),
    PlaceholderWidgetParser(),
    GridViewWidgetParser(),
    ListViewWidgetParser(),
    PageViewWidgetParser(),
    ExpandedWidgetParser(),
    PaddingWidgetParser(),
    CenterWidgetParser(),
    AlignWidgetParser(),
    AspectRatioWidgetParser(),
    FittedBoxWidgetParser(),
    BaselineWidgetParser(),
    StackWidgetParser(),
    PositionedWidgetParser(),
    IndexedStackWidgetParser(),
    ExpandedSizedBoxWidgetParser(),
    SizedBoxWidgetParser(),
    OpacityWidgetParser(),
    WrapWidgetParser(),
    DropCapTextParser(),
    IconWidgetParser(),
    ClipRRectWidgetParser(),
    SafeAreaWidgetParser(),
    ListTileWidgetParser(),
    ScaffoldWidgetParser(),
    AppBarWidgetParser(),
    BottomNavigationBarWidgetParser(),
    LimitedBoxWidgetParser(),
    OffstageWidgetParser(),
    OverflowBoxWidgetParser(),
    ElevatedButtonParser(),
    DividerWidgetParser(),
    TextButtonParser(),
    RotatedBoxWidgetParser(),
    CardParser(),
    SingleChildScrollViewParser(),
    ColoredBoxWidgetParser(),
    RepaintBoundaryWidgetParser(),
    SvgPictureWidgetParser(),
    NetworkSvgPictureWidgetParser(),
  ];

  static final _widgetNameParserMap = <String, WidgetParser>{};

  static bool _defaultParserInited = false;

  // use this method for adding your custom widget parser
  static void addParser(WidgetParser parser) {
    log.info(
        "add custom widget parser, make sure you don't overwirte the widget type.");
    _parsers.add(parser);
    _widgetNameParserMap[parser.widgetName] = parser;
  }

  static void initDefaultParsersIfNess() {
    if (!_defaultParserInited) {
      for (var parser in _parsers) {
        _widgetNameParserMap[parser.widgetName] = parser;
      }
      _defaultParserInited = true;
    }
  }

  static Widget? build(
      String json, BuildContext buildContext, ClickListener listener) {
    initDefaultParsersIfNess();
    var map = jsonDecode(json);
    ClickListener _listener = listener;
    var widget = buildFromMap(map, buildContext, _listener);
    return widget;
  }

  static Widget? buildFromMap(Map<String, dynamic>? map,
      BuildContext buildContext, ClickListener? listener) {
    initDefaultParsersIfNess();
    if (map == null) {
      return null;
    }
    String? widgetName = map['type'];
    if (widgetName == null) {
      return null;
    }
    var parser = _widgetNameParserMap[widgetName];
    if (parser != null) {
      return parser.parse(map, buildContext, listener);
    }
    log.warning("Not support parser type: $widgetName");
    if (kDebugMode) {
      throw UnimplementedError("Not support parser type: $widgetName");
    }
    return null;
  }

  static List<Widget> buildWidgets(List<dynamic> values,
      BuildContext buildContext, ClickListener? listener) {
    initDefaultParsersIfNess();
    List<Widget> rt = [];
    for (var value in values) {
      var buildFromMap2 = buildFromMap(value, buildContext, listener);
      if (buildFromMap2 != null) {
        rt.add(buildFromMap2);
      }
    }
    return rt;
  }

  static Map<String, dynamic>? export(
      Widget? widget, BuildContext? buildContext) {
    initDefaultParsersIfNess();
    var parser = _findMatchedWidgetParserForExport(widget);
    if (parser != null) {
      return parser.export(widget, buildContext);
    }
    log.warning(
        "Can't find WidgetParser for Type ${widget.runtimeType} to export.");
    return null;
  }

  static List<Map<String, dynamic>?> exportWidgets(
      List<Widget?> widgets, BuildContext? buildContext) {
    initDefaultParsersIfNess();
    List<Map<String, dynamic>?> rt = [];
    for (var widget in widgets) {
      rt.add(export(widget, buildContext));
    }
    return rt;
  }

  static WidgetParser? _findMatchedWidgetParserForExport(Widget? widget) {
    for (var parser in _parsers) {
      if (parser.matchWidgetForExport(widget)) {
        return parser;
      }
    }
    return null;
  }
}

/// extends this class to make a Flutter widget parser.
abstract class WidgetParser {
  /// parse the json map into a flutter widget.
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener? listener);

  /// the widget type name for example:
  /// {"type" : "Text", "data" : "Denny"}
  /// if you want to make a flutter Text widget, you should implement this
  /// method return "Text", for more details, please see
  /// @TextWidgetParser
  String get widgetName;

  /// export the runtime widget to json
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext);

  /// match current widget
  Type get widgetType;

  bool matchWidgetForExport(Widget? widget) => widget.runtimeType == widgetType;
}

abstract class ClickListener {
  void onClicked(String? event);
}

class NonResponseWidgetClickListener implements ClickListener {
  static final Logger log = Logger('NonResponseWidgetClickListener');

  @override
  void onClicked(String? event) {
    log.info("receiver click event: " + event!);
    print("receiver click event: " + event);
  }
}

class DynamicWidget extends StatefulWidget {
  final String jsCode;

  const DynamicWidget(this.jsCode);

  @override
  DynamicWidgetState createState() => DynamicWidgetState();
}

class DynamicWidgetState extends State<DynamicWidget> {
  late JsRuntime _js;
  late String jsCode;
  late String jsonCode;

  int currentIndexBottomNav = 0;

  @override
  void initState() {
    super.initState();
    _js = JsRuntime();
    jsCode = widget.jsCode;
    jsonCode = _js.eval("var App;$jsCode;JSON.stringify(App)");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget?>(
      future: _buildWidget(context),
      builder: (BuildContext context, AsyncSnapshot<Widget?> snapshot) {
        return snapshot.hasData
            ? DynamicWidgetJsonExportor(child: snapshot.data)
            : SizedBox();
      },
    );
  }

  Future<Widget?> _buildWidget(BuildContext context) async {
    return DynamicWidgetBuilder.build(
      jsonCode,
      context,
      DefaultClickListener(onClick: _onClick),
    );
  }

  void _onClick(String? event) {
    if (event != null && event.startsWith("bottom_nav_tap_")) {
      int index = int.parse(event.replaceFirst("bottom_nav_tap_", ""));
      setState(() {
        currentIndexBottomNav = index;

        // Update jsonCode sesuai currentIndexBottomNav
        Map<String, dynamic> jsonMap = jsonDecode(jsonCode);

        // Asumsikan bottom nav ada di bagian "body"
        if (jsonMap['body'] != null &&
            jsonMap['body']['type'] == 'BottomNavigationBar') {
          jsonMap['body']['currentIndex'] = index;
        }

        jsonCode = jsonEncode(jsonMap);
      });
    }

    // Jika event lain yang ingin kamu handle dari JS
    else {
      _js.eval(event!);
      setState(() {
        jsonCode = _js.eval("JSON.stringify(App)");
      });
    }
  }
}

class DefaultClickListener implements ClickListener {
  final Function(String?) onClick;

  DefaultClickListener({required this.onClick});

  @override
  void onClicked(String? event) {
    onClick(event);
  }
}
