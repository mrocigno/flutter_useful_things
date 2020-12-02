// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' as Services;
// import 'package:flutter_useful_things/constants/Colors.dart' as Constants;
//
// import 'Background.dart';
// import 'BackgroundTheme.dart';
//
// class BackgroundSliver extends StatelessWidget{
//   BackgroundSliver({
//     Key key,
//     this.child,
//     this.title = "",
//     this.theme,
//     this.bottomNavigation,
//     this.flexibleSpaceBar,
//     this.expandedHeight,
//     this.actions,
//     this.onWillPop,
//     this.leading
//   }) : super(key: key);
//
//   final Widget child;
//   final Widget leading;
//   final String title;
//   final double expandedHeight;
//   final Widget bottomNavigation;
//   final BackgroundTheme theme;
//   final List<Widget> actions;
//   final Widget flexibleSpaceBar;
//   final WillPopCallback onWillPop;
//
//   @override
//   Widget build(BuildContext context) {
//     BackgroundTheme _theme = theme ?? BackgroundTheme.details;
//
//     return WillPopScope(
//       onWillPop: onWillPop,
//       child: Stack(
//         children: [
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: _theme.decoration,
//             clipBehavior: Clip.hardEdge,
//           ),
//           Scaffold(
//             resizeToAvoidBottomInset: false,
//             backgroundColor: Colors.transparent,
//             bottomNavigationBar: bottomNavigation,
//             body: CustomScrollView(
//               slivers: <Widget>[
//                 SliverAppBar(
//                   actions: actions,
//                   brightness: theme.statusBarBrightness,
//                   floating: false,
//                   pinned: _theme.pinned,
//                   snap: false,
//                   leading: leading,
//                   expandedHeight: expandedHeight,
//                   centerTitle: _theme.centralizeTitle,
//                   iconTheme: IconThemeData(color: _theme.titleColor),
//                   title: Text(title,
//                     style: TextStyle(
//                         color: _theme.titleColor
//                     ),
//                   ),
//                   backgroundColor: _theme.appBarColor,
//                   elevation: _theme.elevation,
//                   flexibleSpace: flexibleSpaceBar,
//                 ),
//                 child
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }