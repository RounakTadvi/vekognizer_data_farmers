// import 'package:flutter/material.dart';
// import '../../logic/models/property.dart';
// import '../components/app_bar.dart';

// import 'package:photo_view/photo_view.dart';
// import 'package:flutter_blurhash/flutter_blurhash.dart';

// class AllMedia extends StatelessWidget {
//   final _scrollController = ScrollController();
//   Property property;
//   var picUrls;

//   AllMedia(this.property)
//       : picUrls = [property.primaryPicUrl] +
//             property.featuredPicsUrls +
//             property.otherPicsUrls;

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//         appBar: getCustomAppBar(screenSize, context, null),
//         body: Scrollbar(
//           controller: _scrollController,
//           child: GridView.count(
//               crossAxisCount: 3,
//               physics: AlwaysScrollableScrollPhysics(),
//               controller: _scrollController,
//               children: List.generate(picUrls.length, (index) {
//                 return GestureDetector(
//                   onTap: () {
//                     showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return PhotoView(
//                               imageProvider: NetworkImage(picUrls[index]));
//                         });
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: AspectRatio(
//                       aspectRatio: 3 / 2,
//                       child: BlurHash(
//                         hash: picUrls[index].split("___")[1],
//                         image: picUrls[index].split("___")[0],
//                       ),
//                     ),
//                   ),
//                 );
//               })),
//         ));
//   }
// }