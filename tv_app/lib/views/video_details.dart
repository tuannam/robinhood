import 'package:flutter/material.dart';
import 'package:robinhood/components/loader_widget.dart';
import '../model/models.dart';
import '../service/api.dart';
import '../common.dart';
import 'player.dart';

class VideoDetailsWidget extends StatefulWidget {
  final String videoId;

  const VideoDetailsWidget({Key? key, required this.videoId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoDetailsState(videoId);
}

class _VideoDetailsState extends State<VideoDetailsWidget> {
  final _contentFont = const TextStyle(fontSize: 16.0, color: Colors.white);
  final String videoId;
  MovieDetails? details;
  var loading = true;

  _VideoDetailsState(this.videoId);

  @override
  void initState() {
    super.initState();

    Api.shared.getMovieDetails((p0) {
      if (p0 != null) {
        final movieDetails = p0 as MovieDetails;
        setState(() {
          loading = false;
          details = movieDetails;
        });
      }
    }, videoId);
  }

  @override
  Widget build(BuildContext context) {
    var iconButton = IconButton(
        onPressed: () => {print("iconBtn pressed.")},
        autofocus: true,
        icon: Image.network(
          details?.image ?? '',
          fit: BoxFit.contain,
        ));
    final row1 = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: 320,
              height: 480,
              child: AspectRatio(
                aspectRatio: 320 / 480,
                child: details?.image != null ? iconButton : Container(),
              ),
            ),
          ),
          Expanded(
              child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Opacity(
                  opacity: 0,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(' '),
                  ),
                ),
                Text(
                  details?.content ?? '',
                  style: _contentFont,
                )
              ],
            ),
          )),
        ]);
    final servers = ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (BuildContext content, int position) {
          final server = details!.servers[position];
          return ServerWidget(serverDetails: server);
        },
        separatorBuilder: (context, index) => const SizedBox.shrink(),
        itemCount: details?.servers.length ?? 0);

    final column = Column(
      children: [row1, servers],
    );

    return Scaffold(
        body: LoaderView(
            showLoader: loading,
            child: SingleChildScrollView(
              child: column,
            )));
  }
}

class ServerWidget extends StatelessWidget {
  final ServerDetails serverDetails;
  const ServerWidget({Key? key, required this.serverDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: Text(
                serverDetails.name,
                style: const TextStyle(color: Colors.orange),
              ),
            ),
            Wrap(
                spacing: 5,
                runSpacing: 5,
                children: (serverDetails.links)
                    .map((e) => ChapterButton(link: e))
                    .toList())
          ]),
    );
  }
}

class ChapterButton extends StatefulWidget {
  final MovieLink link;

  const ChapterButton({Key? key, required this.link}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChapterButtonState();
}

class _ChapterButtonState extends State<ChapterButton> {
  bool isFocus = false;

  void _onFocus(bool value) {
    setState(() {
      isFocus = value;
    });
  }

  void play(String link) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return PlayerWidget(link: widget.link.link);
    }));
  }

  void _onTap() {
    print('onTap');
    play(widget.link.link);
  }

  KeyEventResult _onKey(FocusNode node, RawKeyEvent event) {
    if (ACCEPT_KEYS.contains(event.logicalKey)) {
      _onTap();
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
        onFocusChange: _onFocus,
        onKey: _onKey,
        child: InkWell(
          onTap: _onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            color: isFocus ? Colors.yellow : Colors.transparent,
            child: Text(
              widget.link.name,
              style: TextStyle(
                  fontSize: 18.0, color: isFocus ? Colors.black : Colors.white),
            ),
          ),
        ));
  }
}
