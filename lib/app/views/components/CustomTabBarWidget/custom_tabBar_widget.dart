import 'package:flutter/material.dart';

class CustomTabWidget extends StatefulWidget {
  final List<String> tabTitles;
  final List<Widget> tabViews;
  final double? height;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;

  const CustomTabWidget({
    Key? key,
    required this.tabTitles,
    required this.tabViews,
    this.height = 50,
    this.backgroundColor = Colors.black,
    this.indicatorColor = Colors.white,
    this.selectedTextColor = Colors.black,
    this.unselectedTextColor = Colors.white,
    required TextStyle tabTextStyle,
  }) : assert(
         tabTitles.length == tabViews.length,
         'Tab titles and views must have the same length',
       ),
       super(key: key);

  @override
  State<CustomTabWidget> createState() => _CustomTabWidgetState();
}

class _CustomTabWidgetState extends State<CustomTabWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabTitles.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Custom TabBar
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.height! / 2),
          ),
          child: TabBar(
            padding: const EdgeInsets.all(4),
            controller: _tabController,
            indicator: BoxDecoration(
              color: widget.indicatorColor,
              borderRadius: BorderRadius.circular((widget.height! / 2) - 4),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: widget.selectedTextColor,
            unselectedLabelColor: widget.unselectedTextColor,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            tabs: widget.tabTitles.map((title) => Tab(text: title)).toList(),
          ),
        ),

        const SizedBox(height: 16),

        // Custom TabBarView
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabViews,
          ),
        ),
      ],
    );
  }
}
