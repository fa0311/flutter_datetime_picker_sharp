library flutter_datetime_picker;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_sharp/src/custom_scroll_behavior.dart';
import 'package:flutter_datetime_picker_sharp/src/date_model.dart';
import 'package:flutter_datetime_picker_sharp/src/datetime_picker_theme.dart' as picker_theme;
import 'package:flutter_datetime_picker_sharp/src/i18n_model.dart';

export 'package:flutter_datetime_picker_sharp/src/date_model.dart';
export 'package:flutter_datetime_picker_sharp/src/datetime_picker_theme.dart';
export 'package:flutter_datetime_picker_sharp/src/i18n_model.dart';

typedef DateChangedCallback(DateTime time);
typedef DateCancelledCallback();
typedef String? StringAtIndexCallBack(int index);

class DatePicker {
  ///
  /// Display date picker bottom sheet.
  ///
  static Future<DateTime?> showDatePicker(
    BuildContext context, {
    bool showTitleActions = true,
    DateTime? minTime,
    DateTime? maxTime,
    DateChangedCallback? onChanged,
    DateChangedCallback? onConfirm,
    DateCancelledCallback? onCancel,
    locale = LocaleType.en,
    DateTime? currentTime,
    picker_theme.DatePickerTheme? theme,
  }) async {
    return await Navigator.push(
      context,
      _DatePickerRoute(
        showTitleActions: showTitleActions,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        locale: locale,
        theme: theme,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pickerModel: DatePickerModel(
          currentTime: currentTime,
          maxTime: maxTime,
          minTime: minTime,
          locale: locale,
        ),
      ),
    );
  }

  ///
  /// Display time picker bottom sheet.
  ///
  static Future<DateTime?> showTimePicker(
    BuildContext context, {
    bool showTitleActions = true,
    bool showSecondsColumn = true,
    DateChangedCallback? onChanged,
    DateChangedCallback? onConfirm,
    DateCancelledCallback? onCancel,
    locale = LocaleType.en,
    DateTime? currentTime,
    picker_theme.DatePickerTheme? theme,
  }) async {
    return await Navigator.push(
      context,
      _DatePickerRoute(
        showTitleActions: showTitleActions,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        locale: locale,
        theme: theme,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pickerModel: TimePickerModel(
          currentTime: currentTime,
          locale: locale,
          showSecondsColumn: showSecondsColumn,
        ),
      ),
    );
  }

  ///
  /// Display time picker bottom sheet with AM/PM.
  ///
  static Future<DateTime?> showTime12hPicker(
    BuildContext context, {
    bool showTitleActions = true,
    DateChangedCallback? onChanged,
    DateChangedCallback? onConfirm,
    DateCancelledCallback? onCancel,
    locale = LocaleType.en,
    DateTime? currentTime,
    picker_theme.DatePickerTheme? theme,
  }) async {
    return await Navigator.push(
      context,
      _DatePickerRoute(
        showTitleActions: showTitleActions,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        locale: locale,
        theme: theme,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pickerModel: Time12hPickerModel(
          currentTime: currentTime,
          locale: locale,
        ),
      ),
    );
  }

  ///
  /// Display date&time picker bottom sheet.
  ///
  static Future<DateTime?> showDateTimePicker(
    BuildContext context, {
    bool showTitleActions = true,
    DateTime? minTime,
    DateTime? maxTime,
    DateChangedCallback? onChanged,
    DateChangedCallback? onConfirm,
    DateCancelledCallback? onCancel,
    locale = LocaleType.en,
    DateTime? currentTime,
    picker_theme.DatePickerTheme? theme,
  }) async {
    return await Navigator.push(
      context,
      _DatePickerRoute(
        showTitleActions: showTitleActions,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        locale: locale,
        theme: theme,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pickerModel: DateTimePickerModel(
          currentTime: currentTime,
          minTime: minTime,
          maxTime: maxTime,
          locale: locale,
        ),
      ),
    );
  }

  ///
  /// Display date picker bottom sheet witch custom picker model.
  ///
  static Future<DateTime?> showPicker(
    BuildContext context, {
    bool showTitleActions = true,
    DateChangedCallback? onChanged,
    DateChangedCallback? onConfirm,
    DateCancelledCallback? onCancel,
    locale = LocaleType.en,
    BasePickerModel? pickerModel,
    picker_theme.DatePickerTheme? theme,
  }) async {
    return await Navigator.push(
      context,
      _DatePickerRoute(
        showTitleActions: showTitleActions,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        locale: locale,
        theme: theme,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pickerModel: pickerModel,
      ),
    );
  }
}

class _DatePickerRoute<T> extends PopupRoute<T> {
  _DatePickerRoute({
    this.showTitleActions,
    this.onChanged,
    this.onConfirm,
    this.onCancel,
    picker_theme.DatePickerTheme? theme,
    this.barrierLabel,
    this.locale,
    RouteSettings? settings,
    BasePickerModel? pickerModel,
  })  : this.pickerModel = pickerModel ?? DatePickerModel(),
        this.theme = theme ?? picker_theme.DatePickerTheme(),
        super(settings: settings);

  final bool? showTitleActions;
  final DateChangedCallback? onChanged;
  final DateChangedCallback? onConfirm;
  final DateCancelledCallback? onCancel;
  final LocaleType? locale;
  final picker_theme.DatePickerTheme theme;
  final BasePickerModel pickerModel;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = BottomSheet.createAnimationController(navigator!.overlay!);
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _DatePickerComponent(
        onChanged: onChanged,
        locale: this.locale,
        route: this,
        pickerModel: pickerModel,
      ),
    );
    return InheritedTheme.captureAll(context, bottomSheet);
  }
}

class _DatePickerComponent extends StatefulWidget {
  _DatePickerComponent({
    Key? key,
    required this.route,
    required this.pickerModel,
    this.onChanged,
    this.locale,
  }) : super(key: key);

  final DateChangedCallback? onChanged;

  final _DatePickerRoute route;

  final LocaleType? locale;

  final BasePickerModel pickerModel;

  @override
  State<StatefulWidget> createState() {
    return _DatePickerState();
  }
}

class _DatePickerState extends State<_DatePickerComponent> {
  late FixedExtentScrollController leftScrollCtrl, middleScrollCtrl, rightScrollCtrl;

  @override
  void initState() {
    super.initState();
    refreshScrollOffset();
  }

  void refreshScrollOffset() {
//    print('refreshScrollOffset ${widget.pickerModel.currentRightIndex()}');
    leftScrollCtrl = FixedExtentScrollController(initialItem: widget.pickerModel.currentLeftIndex());
    middleScrollCtrl = FixedExtentScrollController(initialItem: widget.pickerModel.currentMiddleIndex());
    rightScrollCtrl = FixedExtentScrollController(initialItem: widget.pickerModel.currentRightIndex());
  }

  @override
  Widget build(BuildContext context) {
    picker_theme.DatePickerTheme theme = widget.route.theme;
    bool isMobile = MediaQuery.of(context).size.width < 500;
    return GestureDetector(
      child: AnimatedBuilder(
        animation: widget.route.animation!,
        builder: (BuildContext context, Widget? child) {
          final double bottomPadding = MediaQuery.of(context).padding.bottom;
          return ClipRect(
            child: Opacity(
              opacity: isMobile ? 1 : widget.route.animation!.value,
              child: CustomSingleChildLayout(
                delegate: (isMobile ? _BottomPickerLayout.new : _CenterPickerLayout.new)(
                  widget.route.animation!.value,
                  theme,
                  showTitleActions: widget.route.showTitleActions!,
                  bottomPadding: bottomPadding,
                ),
                child: GestureDetector(
                  child: Material(
                    color: Colors.transparent,
                    child: _renderPickerView(theme, isMobile),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _notifyDateChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(widget.pickerModel.finalTime()!);
    }
  }

  Widget _renderPickerView(picker_theme.DatePickerTheme theme, bool isMobile) {
    Widget itemView = _renderItemView(theme);
    if (widget.route.showTitleActions == true) {
      return Container(
        decoration: BoxDecoration(
          color: theme.backgroundColor ?? Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0),
            bottom: Radius.circular(isMobile ? 0.0 : 10.0),
          ),
        ),
        child: Column(
          children: <Widget>[
            _renderTitleActionsView(theme),
            itemView,
          ],
        ),
      );
    }
    return itemView;
  }

  Widget _renderColumnView(
    ValueKey key,
    picker_theme.DatePickerTheme theme,
    StringAtIndexCallBack stringAtIndexCB,
    ScrollController scrollController,
    int layoutProportion,
    ValueChanged<int> selectedChangedWhenScrolling,
    ValueChanged<int> selectedChangedWhenScrollEnd,
  ) {
    final globalKey = GlobalKey();
    return Expanded(
      flex: layoutProportion,
      child: Container(
        padding: EdgeInsets.all(8.0),
        height: theme.containerHeight,
        decoration: BoxDecoration(color: theme.backgroundColor),
        child: NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (notification.depth == 0 && notification is ScrollEndNotification && notification.metrics is FixedExtentMetrics) {
              final FixedExtentMetrics metrics = notification.metrics as FixedExtentMetrics;
              final int currentItemIndex = metrics.itemIndex;
              selectedChangedWhenScrollEnd(currentItemIndex);
            }
            return false;
          },
          child: GestureDetector(
            key: globalKey,
            onTapDown: (tapDownDetails) {
              final box = globalKey.currentContext?.findRenderObject() as RenderBox;
              final centerPosition = box.size.height / 2 - tapDownDetails.localPosition.dy;

              if (centerPosition > 40) {
                scrollController.animateToItem(
                  scrollController.selectedItem - 2,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                );
              } else if (centerPosition > 20) {
                scrollController.animateToItem(
                  scrollController.selectedItem - 1,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                );
              } else if (centerPosition < -40) {
                scrollController.animateToItem(
                  scrollController.selectedItem + 2,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                );
              } else if (centerPosition < -20) {
                scrollController.animateToItem(
                  scrollController.selectedItem + 1,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                );
              }
            },
            child: ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: CupertinoPicker.builder(
                key: key,
                backgroundColor: theme.backgroundColor,
                scrollController: scrollController as FixedExtentScrollController,
                itemExtent: theme.itemHeight,
                onSelectedItemChanged: (int index) {
                  selectedChangedWhenScrolling(index);
                },
                useMagnifier: true,
                itemBuilder: (BuildContext context, int index) {
                  final content = stringAtIndexCB(index);
                  if (content == null) {
                    return null;
                  }
                  return Container(
                    height: theme.itemHeight,
                    alignment: Alignment.center,
                    child: Text(
                      content,
                      style: theme.itemStyle,
                      textAlign: TextAlign.start,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderItemView(picker_theme.DatePickerTheme theme) {
    return Container(
      color: theme.backgroundColor,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: widget.pickerModel.layoutProportions()[0] > 0
                  ? _renderColumnView(ValueKey(widget.pickerModel.currentLeftIndex()), theme, widget.pickerModel.leftStringAtIndex, leftScrollCtrl,
                      widget.pickerModel.layoutProportions()[0], (index) {
                      widget.pickerModel.setLeftIndex(index);
                    }, (index) {
                      setState(() {
                        refreshScrollOffset();
                        _notifyDateChanged();
                      });
                    })
                  : null,
            ),
            Text(
              widget.pickerModel.leftDivider(),
              style: theme.itemStyle,
            ),
            Container(
              child: widget.pickerModel.layoutProportions()[1] > 0
                  ? _renderColumnView(ValueKey(widget.pickerModel.currentLeftIndex()), theme, widget.pickerModel.middleStringAtIndex, middleScrollCtrl,
                      widget.pickerModel.layoutProportions()[1], (index) {
                      widget.pickerModel.setMiddleIndex(index);
                    }, (index) {
                      setState(() {
                        refreshScrollOffset();
                        _notifyDateChanged();
                      });
                    })
                  : null,
            ),
            Text(
              widget.pickerModel.rightDivider(),
              style: theme.itemStyle,
            ),
            Container(
              child: widget.pickerModel.layoutProportions()[2] > 0
                  ? _renderColumnView(ValueKey(widget.pickerModel.currentMiddleIndex() * 100 + widget.pickerModel.currentLeftIndex()), theme,
                      widget.pickerModel.rightStringAtIndex, rightScrollCtrl, widget.pickerModel.layoutProportions()[2], (index) {
                      widget.pickerModel.setRightIndex(index);
                    }, (index) {
                      setState(() {
                        refreshScrollOffset();
                        _notifyDateChanged();
                      });
                    })
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // Title View
  Widget _renderTitleActionsView(picker_theme.DatePickerTheme theme) {
    final done = _localeDone();
    final cancel = _localeCancel();

    return Container(
      height: theme.titleHeight,
      decoration: BoxDecoration(
        color: theme.headerColor ?? theme.backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: theme.titleHeight,
            child: CupertinoButton(
              pressedOpacity: 0.3,
              padding: EdgeInsetsDirectional.only(start: 16, top: 0),
              child: Text(
                '$cancel',
                style: theme.cancelStyle ?? Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: () {
                Navigator.pop(context);
                if (widget.route.onCancel != null) {
                  widget.route.onCancel!();
                }
              },
            ),
          ),
          Container(
            height: theme.titleHeight,
            child: CupertinoButton(
              pressedOpacity: 0.3,
              padding: EdgeInsetsDirectional.only(end: 16, top: 0),
              child: Text(
                '$done',
                style: theme.doneStyle,
              ),
              onPressed: () {
                Navigator.pop(context, widget.pickerModel.finalTime());
                if (widget.route.onConfirm != null) {
                  widget.route.onConfirm!(widget.pickerModel.finalTime()!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String _localeDone() {
    return i18nObjInLocale(widget.locale)['done'] as String;
  }

  String _localeCancel() {
    return i18nObjInLocale(widget.locale)['cancel'] as String;
  }
}

class _PickerLayoutBase extends SingleChildLayoutDelegate {
  _PickerLayoutBase(
    this.progress,
    this.theme, {
    this.showTitleActions = null,
    this.bottomPadding = 0,
  });
  final double progress;
  final bool? showTitleActions;
  final picker_theme.DatePickerTheme theme;
  final double bottomPadding;

  @override
  bool shouldRelayout(_PickerLayoutBase oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

class _BottomPickerLayout extends _PickerLayoutBase {
  _BottomPickerLayout(
    super.progress,
    super.theme, {
    super.showTitleActions = null,
    super.bottomPadding = 0,
  });

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = theme.containerHeight;
    if (showTitleActions == true) {
      maxHeight += theme.titleHeight;
    }

    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: maxHeight + bottomPadding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final height = size.height - childSize.height * progress;
    return Offset(0.0, height);
  }
}

class _CenterPickerLayout extends _PickerLayoutBase {
  _CenterPickerLayout(
    super.progress,
    super.theme, {
    super.showTitleActions = null,
    super.bottomPadding = 0,
  });

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = theme.containerHeight;
    if (showTitleActions == true) {
      maxHeight += theme.titleHeight;
    }

    return BoxConstraints(
      minWidth: 500,
      maxWidth: 500,
      minHeight: 0.0,
      maxHeight: maxHeight + bottomPadding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final centerX = (size.width - childSize.width) / 2;
    final centerY = (size.height - childSize.height) / 2;
    return Offset(centerX, centerY);
  }
}
