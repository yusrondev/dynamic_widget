import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarWidgetParser extends WidgetParser {
  @override
  String get widgetName => "BottomNavigationBar";

  @override
  Type get widgetType => BottomNavigationBar;

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener? listener) {
    List<dynamic> itemsJson = map['items'] ?? [];
    List<BottomNavigationBarItem> items = itemsJson.map((itemMap) {
      // Parse icon dari itemMap
      IconData iconData = _parseIconData(itemMap['icon']);

      return BottomNavigationBarItem(
        icon: Icon(iconData),
        label: itemMap['label'] ?? '',
      );
    }).toList();

    int currentIndex = map['currentIndex'] ?? 0;
    Color? backgroundColor = map.containsKey('backgroundColor')
        ? parseHexColor(map['backgroundColor'])
        : null;

    return BottomNavigationBar(
      items: items,
      currentIndex: currentIndex,
      backgroundColor: backgroundColor,
      onTap: (index) {
        if (listener != null) listener.onClicked("bottom_nav_tap_$index");
      },
    );
  }

  // Helper function untuk mengkonversi JSON icon ke IconData
  IconData _parseIconData(dynamic iconMap) {
    if (iconMap is Map) {
      // Jika icon didefinisikan sebagai map dengan codePoint
      return IconData(
        iconMap['codePoint'] ?? Icons.home.codePoint,
        fontFamily: iconMap['fontFamily'] ?? 'MaterialIcons',
      );
    }
    // Fallback ke home jika tidak ada data icon
    return Icons.home;
  }

  @override
  @override
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    if (widget is! BottomNavigationBar) return null;

    return {
      "type": widgetName,
      "backgroundColor":
          widget.backgroundColor?.value.toRadixString(16) ?? "#FFFFFF",
      "currentIndex": widget.currentIndex,
      "items": widget.items.map((item) {
        // Default values
        int codePoint = Icons.home.codePoint;
        String fontFamily = 'MaterialIcons';

        // Extract icon data if available
        if (item.icon is Icon) {
          final icon = item.icon as Icon;
          if (icon.icon != null) {
            codePoint = icon.icon!.codePoint;
            fontFamily = icon.icon!.fontFamily ?? 'MaterialIcons';
          }
        }

        return {
          "label": item.label ?? '',
          "icon": {
            "type": "Icon", // Tambahkan type untuk konsistensi
            "codePoint": codePoint,
            "fontFamily": fontFamily
          }
        };
      }).toList(),
    };
  }
}
