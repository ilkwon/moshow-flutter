import 'package:flutter/material.dart';
import 'package:moshow/common/api_client.dart';
import 'package:moshow/common/define.dart';
import 'package:moshow/common/shared.dart';
import 'package:moshow/common/providers/app_provider.dart';
import 'package:moshow/shell/mo_bottom_nav.dart';
import 'package:moshow/shell/mo_top_bar.dart';
import 'package:provider/provider.dart';

import 'package:moshow/home/home_screen.dart';
import 'package:moshow/search/search_screen.dart';
import 'package:moshow/collect/collect_screen.dart';
import 'package:moshow/profile/profile_screen.dart';


class MoShell extends StatefulWidget {
  const MoShell({super.key});

  @override
  State<StatefulWidget> createState() => _MoShellState();

}

class _MoShellState extends State<MoShell> {

  var tabIndex = TabType.home;
  var feedStatus = FeedStatus.idle;

  var hasMore = true;
  dynamic homeData = [];
  dynamic collectData = [];
  final stateScroll = ScrollController(); 

  @override
  void initState() {
    // TODO: implement initState    
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<StoreProvider>().initUser();
    });

    stateScroll.addListener((){
      if (stateScroll.position.pixels >= stateScroll.position.maxScrollExtent - AppConfig.feedPreloadOffset){
        loadFeed();
      }      
    });

    loadFeed();
  }
  
  //-------------------------------------------------------
  Future<void> loadFeed() async {
    if (feedStatus == FeedStatus.loading || !hasMore) return;
    setState(() => feedStatus = FeedStatus.loading);

    try {
      final List<dynamic> result = await ApiClient.instance.get('/feed');
      setState(() {
        if (result.isEmpty){
          hasMore = false;
          feedStatus = FeedStatus.done;          
        } else {
          homeData = result;
          collectData = result;
          hasMore = result.length == AppConfig.pageSize;
          feedStatus = FeedStatus.done;
        }
      });
    } catch (error){
      Shared.log('피드 로딩 오류: $error');
      setState(() {
        hasMore = false;
        feedStatus = FeedStatus.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // upload는 모달이라 IndexedStack에서 제외
    // home=0, search=1, collect=2, profile=3
    final stackIndex = tabIndex.index > TabType.upload.index
        ? tabIndex.index - 1
        : tabIndex.index;

    return Center(
      child: SizedBox(
        width: 480,
        height: MediaQuery.of(context).size.height.clamp(0, 853),
        child: Scaffold(          
          extendBody: true,
          extendBodyBehindAppBar: true,

          appBar: MoTopBar(currentTab: tabIndex),
          body: IndexedStack(
            index: stackIndex,
            children: [
              HomeScreen(datas: homeData,),
              const SearchScreen(),
              CollectScreen(
                datas: collectData,
                scroll: stateScroll,
                loading: feedStatus == FeedStatus.loading,
                hasMore: hasMore,                
              ),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: MoBottomNav(
            currentTab: tabIndex,
            onTabSelected: (TabType tab){
              if (tab == TabType.upload){
                // 업로드 모달.
              } else {
                setState(() => tabIndex = tab);
              }
          }),
        ),
      ),
    );
  }
}