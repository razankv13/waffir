import 'package:flutter/material.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/stores/presentation/widgets/catalog_search_field.dart';

class CatalogSearchFilterBar extends StatelessWidget {
  const CatalogSearchFilterBar({
    super.key,
    required this.controller,
    required this.onSearchChanged,
    this.searchPadding = EdgeInsets.zero,
    this.filters = const <Widget>[],
  });

  final TextEditingController controller;
  final ValueChanged<String> onSearchChanged;
  final EdgeInsets searchPadding;
  final List<Widget> filters;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: responsive.scalePadding(searchPadding),
          child: CatalogSearchField(
            controller: controller,
            onChanged: onSearchChanged,
          ),
        ),
        for (var i = 0; i < filters.length; i++) ...[
          SizedBox(height: responsive.scale(12)),
          filters[i],
        ],
      ],
    );
  }
}
