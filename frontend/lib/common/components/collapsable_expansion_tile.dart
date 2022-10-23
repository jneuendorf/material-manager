import 'package:flutter/material.dart';
import 'package:get/get.dart';

// --- Copied and slightly modified version of the ExpansionTile.

const Duration _kExpand = Duration(milliseconds: 250);

class CollapsableExpansionTile extends StatefulWidget {
  const CollapsableExpansionTile({
    Key? key,
    this.leading,
    this.title,
    this.backgroundColor,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
  }) : super(key: key);

  final Widget? leading;
  final Widget? title;
  final ValueChanged<bool>? onExpansionChanged;
  final List<Widget> children;
  final Color? backgroundColor;
  final Widget? trailing;
  final bool initiallyExpanded;

  @override
  CollapsableExpansionTileState createState() => CollapsableExpansionTileState();
}

class CollapsableExpansionTileState extends State<CollapsableExpansionTile> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  CurvedAnimation? _easeOutAnimation;
  CurvedAnimation? _easeInAnimation;
  ColorTween? _borderColor;
  ColorTween? _headerColor;
  ColorTween? _iconColor;
  ColorTween? _backgroundColor;
  Animation<double>? _iconTurns;

  RxBool tileIsExpanded = false.obs;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _easeOutAnimation = CurvedAnimation(parent: _controller!, curve: Curves.easeOut);
    _easeInAnimation = CurvedAnimation(parent: _controller!, curve: Curves.easeIn);
    _borderColor = ColorTween();
    _headerColor = ColorTween();
    _iconColor = ColorTween();
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(_easeInAnimation!);
    _backgroundColor = ColorTween();

    tileIsExpanded.value = PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (tileIsExpanded.value) {
      _controller?.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void expand() {
    _setExpanded(true);
  }

  void collapse() {
    _setExpanded(false);
  }

  void toggle() {
    _setExpanded(!tileIsExpanded.value);
  }

  void _setExpanded(bool isExpanded) {
    if (tileIsExpanded.value != isExpanded) {
      setState(() {
        tileIsExpanded.value = isExpanded;
        if (tileIsExpanded.value) {
          _controller!.forward();
        } else {
          _controller!.reverse().then<void>((_) {
            setState(() {
              // Rebuild without widget.children.
            });
          });
        }
        PageStorage.of(context)?.writeState(context, tileIsExpanded);
      });
      if (widget.onExpansionChanged != null) {
        widget.onExpansionChanged!(tileIsExpanded.value);
      }
    }
  }

  Widget? _buildIcon(BuildContext context) {
    return RotationTransition(
      turns: _iconTurns!,
      child: const Icon(Icons.expand_more),
    );
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final Color borderSideColor = _borderColor!.evaluate(_easeOutAnimation!) ?? Colors.transparent;
    final Color? titleColor = _headerColor!.evaluate(_easeInAnimation!);

    return Container(
      decoration: BoxDecoration(
          color: _backgroundColor!.evaluate(_easeOutAnimation!) ?? Colors.transparent,
          border: Border(
            top: BorderSide(color: borderSideColor),
            bottom: BorderSide(color: borderSideColor),
          )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconTheme.merge(
            data: IconThemeData(color: _iconColor!.evaluate(_easeInAnimation!)),
            child: ListTile(
                onTap: toggle,
                leading: widget.leading,
                title: DefaultTextStyle(
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: titleColor),
                  child: widget.title!,
                ),
                trailing: widget.trailing ?? _buildIcon(context)
            ),
          ),
          ClipRect(
            child: Align(
              heightFactor: _easeInAnimation!.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    _borderColor!.end = theme.dividerColor;
    _headerColor!
      ..begin = theme.textTheme.subtitle1!.color
      ..end = theme.primaryColor;
    _iconColor!
      ..begin = theme.unselectedWidgetColor
      ..end = theme.primaryColor;
    _backgroundColor!.end = widget.backgroundColor;

    final bool closed = !tileIsExpanded.value && _controller!.isDismissed;
    return AnimatedBuilder(
      animation: _controller!.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
  }
}