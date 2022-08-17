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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SectionListWidget(
      sections: sections,
    )));
  }
}

class SectionListWidget extends StatelessWidget {
  final List<Section> sections;

  const SectionListWidget({Key? key, required this.sections}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
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
