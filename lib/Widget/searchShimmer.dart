import 'package:flutter/material.dart';

class SearchShimmer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context,index){
        return Container(
          width: 150,
          margin: EdgeInsets.only(left: 15,top: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
          child: SizedBox(
            height: 51,
          ),
        );
      },
    );
  }
}