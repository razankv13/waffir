import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/constants/app_typography.dart';

/// Waffir-branded search bar with exact Figma specifications
///
/// Specifications from Figma:
/// - Height: 68px
/// - Border Radius: 16px (not 24px)
/// - Border: 1px #00C531 (bright green)
/// - Filter Button: 44x44px circular, #0F352D background
///
/// Example usage:
/// ```dart
/// WaffirSearchBar(
///   hintText: 'Search stores...',
///   onSearch: (query) => performSearch(query),
///   onFilterTap: () => showFilterDialog(),
/// )
/// ```
class WaffirSearchBar extends StatefulWidget {
  const WaffirSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onSearch,
    this.onChanged,
    this.onFilterTap,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onSearch;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final bool autofocus;

  @override
  State<WaffirSearchBar> createState() => _WaffirSearchBarState();
}

class _WaffirSearchBarState extends State<WaffirSearchBar> {
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
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16), // Exact: 16px per Figma
        border: Border.all(
          color: AppColors.waffirGreen03, // #00C531 bright green
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Search Icon (left)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Icon(
              Icons.search,
              size: 20,
              color: AppColors.gray03,
            ),
          ),

          // Search TextField
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: widget.autofocus,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.black,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.gray03,
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
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 18,
                    color: AppColors.gray03,
                  ),
                  onPressed: _clearSearch,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              );
            },
          ),

          // Vertical Divider
          Container(
            width: 1,
            height: 24,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: AppColors.gray01,
          ),

          // Filter Button (circular, 44x44px)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: widget.onFilterTap,
              borderRadius: BorderRadius.circular(1000),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.waffirGreen04, // #0F352D dark green
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/categories/arrow_filter_icon.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
