import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'common/shared.dart';
import './profile.dart';

class Collect extends StatefulWidget {
  Collect({super.key
    , this.datas
    , this.scroll
    , this.loading
    , this.hasMore
  });

  final datas;
  final scroll;
  final bool? loading;
  final bool? hasMore;

  @override
  State<Collect> createState() => _CollectState();
}

class _CollectState extends State<Collect> {

  //-------------------------------------------------------------------------
  @override  
  Widget build(BuildContext context) 
  {
    if (Shared.hasValue(widget.datas)){
      return ListView.builder(itemCount: widget.datas.length + 1
      , controller: widget.scroll
      , itemBuilder:(context, i){
        if (i == widget.datas.length){ 
          if (true == widget.loading && true == widget.hasMore){
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            return const SizedBox.shrink(); // 더이상 로딩할게 없으면 아무것도 표시 안함.
          }
        }

        // 일반 데이터 아이템
        return Padding(
          padding: const EdgeInsets.all(12.0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.datas[i]['image']),
              SizedBox(height: 8),
              Text('❤️ ${ widget.datas[i]['likes'] }개'),
              GestureDetector(
                child:Text('@${widget.datas[i]['user']}'),
                onTap:(){
                  Navigator.push(context, CupertinoPageRoute(builder: (c) => Profile()));
                },                               
              ),
                
              Text(widget.datas[i]['content']),
            ],  
          ),
        );
      });
    } else {
      return const Center(child: Text('Now Loading...'));
    }
  }
}

