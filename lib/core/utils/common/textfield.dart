// lib/widgets/input_field.dart
import 'package:bettersplitapp/core/utils/constants/constants.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatefulWidget {
  final String? title;
  final String hintText;
  final FocusNode? focusNode;
  final Function(String currency)? onCurrencyChange;
  final String? selectedCurrency;
  final TextCapitalization textCapitalization;
  final Widget? suffixIcon;
  final Function(String value)? onChanged;
  final Widget? prefixIcon;
  final EdgeInsets padding;
  final TextInputType textInputType;
  final List<TextInputFormatter>? formatters;
  final TextEditingController controller;
  final int? maxLength;

  const InputField({
    super.key,
    this.onChanged,
    this.title,
    this.hintText = "Samael",
    this.focusNode,
    this.suffixIcon,
    this.maxLength,
    this.textCapitalization = TextCapitalization.sentences,
    this.prefixIcon,
    this.onCurrencyChange,
    this.formatters,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.selectedCurrency,
    this.textInputType = TextInputType.text,
    required this.controller,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> with TickerProviderStateMixin {
  bool showPicker = false;
  late FixedExtentScrollController currencyController;

  @override
  void initState() {
    super.initState();
    currencyController = FixedExtentScrollController(
      initialItem: widget.selectedCurrency != null
          ? currencies.indexWhere((c) => c.$2 == widget.selectedCurrency!)
          : 0,
    );
  }

  void _togglePicker() {
    setState(() {
      showPicker = !showPicker;

      if (showPicker && widget.selectedCurrency != null) {
        final index = currencies.indexWhere(
          (c) => c.$2 == widget.selectedCurrency!,
        );
        currencyController.jumpToItem(index);
      }
    });
  }

  @override
  void dispose() {
    currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color defaultWhite = ColorsConstants.defaultWhite;
    final Color onSurfaceBlack = ColorsConstants.onSurfaceBlack;
    final Color accentGreen = ColorsConstants.accentGreen;

    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Text(
              widget.title!,
              style: TextStyles.fustatExtraBold.copyWith(
                fontSize: 12,
                letterSpacing: -0.5,
                color: defaultWhite,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              if (widget.onCurrencyChange != null) ...[
                InkWell(
                  onTap: _togglePicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: onSurfaceBlack,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.selectedCurrency ?? '',
                      style: TextStyles.fustatBold.copyWith(
                        fontSize: 12,
                        letterSpacing: -0.5,
                        color: defaultWhite,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: TextField(
                  onChanged: widget.onChanged,
                  focusNode: widget.focusNode,
                  textCapitalization: widget.textCapitalization,
                  keyboardType: widget.textInputType,
                  controller: widget.controller,
                  inputFormatters: widget.formatters,
                  maxLength: widget.maxLength,
                  cursorColor: accentGreen,
                  buildCounter:
                      (
                        BuildContext context, {
                        required int currentLength,
                        required bool isFocused,
                        required int? maxLength,
                      }) {
                        // Hide completely
                        if (maxLength == null) {
                          return null;
                        }

                        // Or fully customise
                        return Text(
                          '$currentLength/$maxLength',
                          style: TextStyles.fustatRegular.copyWith(
                            color: ColorsConstants.defaultWhite.withValues(
                              alpha: 0.5,
                            ),
                            fontSize: 10,
                            letterSpacing: -0.5,
                          ),
                        );
                      },
                  style: TextStyles.fustatBold.copyWith(
                    fontSize: 10,
                    color: defaultWhite,
                    letterSpacing: -0.5,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: widget.hintText,
                    suffixIcon: widget.suffixIcon,
                    prefixIcon: widget.prefixIcon,
                    suffixIconConstraints: BoxConstraints(maxWidth: 20),
                    prefixIconConstraints: BoxConstraints(maxWidth: 24),
                    hintStyle: TextStyles.fustatBold.copyWith(
                      fontSize: 10,
                      color: defaultWhite.withValues(alpha: 0.5),
                      letterSpacing: -0.5,
                    ),
                    filled: true,
                    fillColor: onSurfaceBlack,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Currency Picker - always mounted, animated height
          if (widget.onCurrencyChange != null)
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: SizedBox(
                height: showPicker ? 120 : 0,
                child: Stack(
                  children: [
                    Positioned(
                      top: 40,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: ColorsConstants.surfaceBlack,
                        ),
                      ),
                    ),
                    ListWheelScrollView.useDelegate(
                      controller: currencyController,
                      itemExtent: 40,
                      perspective: 0.01,
                      diameterRatio: 1.2,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) =>
                          widget.onCurrencyChange!(currencies[index].$2),
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          final currency = currencies[index].$2;
                          return Center(
                            child: Text(
                              currency,
                              style: TextStyles.fustatBold.copyWith(
                                fontSize: 12,
                                letterSpacing: -0.5,
                                color: widget.selectedCurrency == currency
                                    ? defaultWhite
                                    : defaultWhite.withValues(alpha: 0.5),
                              ),
                            ),
                          );
                        },
                        childCount: currencies.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
