import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_typography.dart';

/// Custom search bar widget for product search
///
/// Example usage:
/// ```dart
/// SearchBarWidget(
///   hintText: 'Search products...',
///   onSearch: (query) => performSearch(query),
///   onFilterTap: () => showFilterDialog(),
/// )
/// ```
class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onSearch,
    this.onChanged,
    this.onFilterTap,
    this.showFilterButton = false,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onSearch;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final bool showFilterButton;
  final bool autofocus;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleSearch() {
    final query = _controller.text.trim();
    if (query.isNotEmpty && widget.onSearch != null) {
      widget.onSearch!(query);
    }
  }

  void _clearSearch() {
    _controller.clear();
    if (widget.onChanged != null) {
      widget.onChanged!('');
    }
    if (widget.onSearch != null) {
      widget.onSearch!('');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Search Icon
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Icon(
              Icons.search,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          // Search TextField
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: widget.autofocus,
              style: AppTypography.bodyMedium.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: widget.onChanged,
              onSubmitted: (_) => _handleSearch(),
              textInputAction: TextInputAction.search,
            ),
          ),

          // Clear Button (shown when text is not empty)
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, value, child) {
              if (value.text.isEmpty) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: _clearSearch,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              );
            },
          ),

          // Filter Button (optional)
          if (widget.showFilterButton) ...[
            Container(
              width: 1,
              height: 24,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: colorScheme.outlineVariant,
            ),
            IconButton(
              icon: Icon(
                Icons.tune,
                size: 20,
                color: colorScheme.onSurface,
              ),
              onPressed: widget.onFilterTap,
              padding: const EdgeInsets.only(right: 16),
              constraints: const BoxConstraints(),
            ),
          ] else
            const SizedBox(width: 16),
        ],
      ),
    );
  }
}
