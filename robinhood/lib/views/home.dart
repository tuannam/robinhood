import 'package:flutter/material.dart';
import 'package:robinhood/views/section_view.dart';
import '../model/section.dart';
import '../service/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final sections = <Section>[];
  var isSearchFocus = false;

  @override
  void initState() {
    super.initState();
    _loadData();
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
    setState(() {
      isSearchFocus = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
                onPressed: () {},
                child: Container(
                  alignment: Alignment.bottomLeft,
                  margin: const EdgeInsets.fromLTRB(20, 40, 20, 00),
                  child: Container(
                      padding: EdgeInsets.all(isSearchFocus ? 20.0 : 15.0),
                      decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(1.0, 0.0),
                                blurRadius: 1)
                          ]),
                      child: Focus(
                        onFocusChange: _onSearchFocus,
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      )),
                )),
            SectionListWidget(
              sections: sections,
            )
          ],
        ),
      ),
    ));
  }
}

class SectionListWidget extends StatelessWidget {
  final List<Section> sections;

  const SectionListWidget({Key? key, required this.sections}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (BuildContext content, int position) {
        final section = sections[position];
        return SectionWidget(
            category: section.title ?? '',
            movies: section.items,
            next: section.next);
      },
      separatorBuilder: (context, index) => const SizedBox.shrink(),
      itemCount: sections.length,
    );
  }
}
