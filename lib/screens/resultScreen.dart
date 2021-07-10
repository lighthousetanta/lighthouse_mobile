import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_lighthouse/providers/poi_provider.dart';
import '../widgets/result_card.dart';

class ResultScreen extends StatelessWidget {
  static const routeName = '/resultScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
      ),
      body: SafeArea(
        child: Consumer<PoiProvider>(builder: (context, provider, _) {
          return provider.searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 70,
                      ),
                      SizedBox(height: 30),
                      Text(
                        "No matches were found",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: provider.searchResults.length,
                  itemBuilder: (context, idx) {
                    return ResultCard(provider.searchResults[idx]);
                  });
        }),
      ),
    );
  }
}

// Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 height: MediaQuery.of(context).size.height / 2,
//                 width: MediaQuery.of(context).size.width,
//                 child: Image.network(
//                   poi.image,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               SizedBox(height: 50),
//               Text(
//                 poi.name,
//                 style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Raleway'),
//               ),
//             ],
//           ),
//         )
