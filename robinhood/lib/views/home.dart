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

  Future<void> _loadData() async {
    Api.shared.getSectionList((p0) {
      final sectionList = p0 as SectionList;
      if (sectionList.sections.isNotEmpty) {
        setState(() {
          sections.add(sectionList.sections.first);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: const <Widget>[
            SectionWidget(),
            SectionWidget(),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
