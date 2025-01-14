import 'package:flutter/material.dart';
import 'package:robinhood/components/search_button.dart';
import 'package:robinhood/updater/updater.dart';
import 'package:robinhood/views/hidden_webview.dart';
import 'package:robinhood/views/search_view.dart';
import 'package:robinhood/views/section_view.dart';
import 'package:flutter/foundation.dart';
import 'package:robinhood/views/settings_view.dart';
import 'package:robinhood/views/video_card.dart';
import '../model/models.dart';
import '../service/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final sections = <Section>[];
  var scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  void initState() {
    super.initState();
    _loadData();

    if (defaultTargetPlatform == TargetPlatform.android) {
      checkAndUpdate(context);
    }
  }

  Future<void> _loadData({String id = ''}) async {
    Api.shared.getSectionList((p0) {
      final sectionList = p0 as SectionList;
      if (sectionList.sections.isNotEmpty) {
        final first = sectionList.sections.first;
        setState(() {
          sections.add(first);
        });
      }
      if (sectionList.next != null) {
        _loadData(id: sectionList.next ?? '');
      }
    }, id: id);
  }

  void _onSearchFocus(bool value) {
    print('_onSearchFocus');
    if (value) {
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 200), curve: Curves.linear);
    }
  }

  void _onSearchPressed() {
    print('_onSearchPressed');
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const SearchView();
    }));
  }

  @override
  Widget build(BuildContext context) {
    var main = SingleChildScrollView(
      controller: scrollController,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: SearchButton(
                onFocus: _onSearchFocus,
                onSearch: _onSearchPressed,
              ),
            ),
            SectionListWidget(
              openDrawer: () {
                _key.currentState?.openDrawer();
              },
              sections: sections,
            )
          ],
        ),
      ),
    );
    return Scaffold(
        key: _key,
        drawer: Drawer(
          child: SettingsView(),
        ),
        body: main);
  }
}

class SectionListWidget extends StatelessWidget {
  final OPEN_DRAWER openDrawer;
  final List<Section> sections;

  const SectionListWidget(
      {Key? key, required this.openDrawer, required this.sections})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (BuildContext content, int position) {
        final section = sections[position];
        return SectionWidget(
            openDrawer: openDrawer,
            category: section.title ?? '',
            movies: section.items,
            next: section.next);
      },
      separatorBuilder: (context, index) => const SizedBox.shrink(),
      itemCount: sections.length,
    );
  }
}
