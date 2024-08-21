import 'package:flutter/material.dart';

const List<Color> defaultColors = [
  Color.fromRGBO(0, 0, 0, 0.1),
  Color(0x44CCCCCC),
  Color.fromRGBO(0, 0, 0, 0.1)
];

Decoration customBoxDecoration({
  required Animation animation,
  bool isRectBox = false,
  bool isDarkMode = false,
  bool isPurplishMode = false,
  bool hasCustomColors = false,
  List<Color> colors = defaultColors,
  AlignmentGeometry beginAlign = Alignment.topLeft,
  AlignmentGeometry endAlign = Alignment.bottomRight,
}) {
  return BoxDecoration(
      shape: isRectBox ? BoxShape.rectangle : BoxShape.circle,
      gradient: LinearGradient(
          begin: beginAlign,
          end: endAlign,
          colors: hasCustomColors
              ? colors.map((color) {
                  return color;
                }).toList()
              : [
                  isPurplishMode
                      ? const Color(0xFF8D71A9)
                      : isDarkMode
                          ? const Color(0xFF1D1D1D)
                          : const Color.fromRGBO(0, 0, 0, 0.1),
                  isPurplishMode
                      ? const Color(0xFF36265A)
                      : isDarkMode
                          ? const Color(0XFF3C4042)
                          : const Color(0x44CCCCCC),
                  isPurplishMode
                      ? const Color(0xFF8D71A9)
                      : isDarkMode
                          ? const Color(0xFF1D1D1D)
                          : const Color.fromRGBO(0, 0, 0, 0.1),
                ],
          stops: [animation.value - 2, animation.value, animation.value + 1]));
}

Widget buildButtomBox(Animation animation,
    {required double width,
    required double height,
    required bool isDarkMode,
    required bool isRectBox,
    required bool isPurplishMode,
    required AlignmentGeometry beginAlign,
    required AlignmentGeometry endAlign,
    required bool hasCustomColors,
    required List<Color> colors,
    bool isVideoShimmer = false}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 2),
    height: isVideoShimmer ? height : width * 0.2,
    width: isVideoShimmer ? width : width * 0.2,
    decoration: customBoxDecoration(
        animation: animation,
        isDarkMode: isDarkMode,
        isPurplishMode: isPurplishMode,
        isRectBox: isRectBox,
        beginAlign: beginAlign,
        endAlign: endAlign,
        hasCustomColors: hasCustomColors,
        colors: colors.length == 3 ? colors : defaultColors),
  );
}

Decoration radiusBoxDecoration(
    {required Animation animation,
    bool isDarkMode = false,
    bool isPurplishMode = false,
    bool hasCustomColors = false,
    AlignmentGeometry beginAlign = Alignment.topLeft,
    AlignmentGeometry endAlign = Alignment.bottomRight,
    List<Color> colors = defaultColors,
    double radius = 10.0}) {
  return BoxDecoration(
      // borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
      gradient: LinearGradient(
          begin: beginAlign,
          end: endAlign,
          colors: hasCustomColors
              ? colors.map((color) {
                  return color;
                }).toList()
              : [
                  isPurplishMode
                      ? const Color(0xFF8D71A9)
                      : isDarkMode
                          ? const Color(0xFF1D1D1D)
                          : const Color.fromRGBO(0, 0, 0, 0.1),
                  isPurplishMode
                      ? const Color(0xFF36265A)
                      : isDarkMode
                          ? const Color(0XFF3C4042)
                          : const Color(0x44CCCCCC),
                  isPurplishMode
                      ? const Color(0xFF8D71A9)
                      : isDarkMode
                          ? const Color(0xFF1D1D1D)
                          : const Color.fromRGBO(0, 0, 0, 0.1),
                ],
          stops: [animation.value - 2, animation.value, animation.value + 1]));
}

class VideoShimmer extends StatefulWidget {
  final bool isRectBox;
  final bool isDarkMode;
  final bool isPurplishMode;
  final AlignmentGeometry beginAlign;
  final AlignmentGeometry endAlign;
  final bool hasBottomBox;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool hasCustomColors;
  final List<Color> colors;

  const VideoShimmer({
    super.key,
    this.isRectBox = false,
    this.isDarkMode = false,
    this.beginAlign = Alignment.topLeft,
    this.endAlign = Alignment.bottomRight,
    this.hasBottomBox = false,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.all(16.0),
    this.isPurplishMode = false,
    this.hasCustomColors = false,
    this.colors = defaultColors,
  });

  @override
  _VideoShimmerState createState() => _VideoShimmerState();
}

class _VideoShimmerState extends State<VideoShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  // ****************************init*************************
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(CurvedAnimation(
        curve: Curves.easeInOutSine, parent: _animationController));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Container(
          margin: widget.margin,
          padding: widget.padding,
          color: widget.isDarkMode ? const Color(0xFF0B0B0B) : Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 16 / 9,
                child: buildButtomBox(_animation,
                    height: width,
                    width: width,
                    isPurplishMode: widget.isPurplishMode,
                    isDarkMode: widget.isDarkMode,
                    isRectBox: true,
                    beginAlign: widget.beginAlign,
                    endAlign: widget.endAlign,
                    isVideoShimmer: true,
                    hasCustomColors: widget.hasCustomColors,
                    colors: widget.colors.length == 3
                        ? widget.colors
                        : defaultColors),
              ),
              Container(
                height: height / 9,
                width: width * 0.2,
                decoration: radiusBoxDecoration(
                    animation: _animation,
                    isPurplishMode: widget.isPurplishMode,
                    isDarkMode: widget.isDarkMode,
                    hasCustomColors: widget.hasCustomColors,
                    colors: widget.colors.length == 3
                        ? widget.colors
                        : defaultColors),
              ),
            ],
          ),
        );
      },
    );
  }
}
