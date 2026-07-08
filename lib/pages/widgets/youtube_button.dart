import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class YoutubeButton extends StatelessWidget {
  final String url;

  const YoutubeButton({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.play_circle_outline, size: 18),
        const SizedBox(width: 6),
        Text('Youtube'),
      ],
    );

    return FilledButton(
      onPressed: () async {
        print('youtubeUrl $url');
        final Uri youtubeUrl = Uri.parse(url);
        web.window.open(youtubeUrl.toString(), '_blank');
      },
      style: FilledButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
      ),
      child: child,
    );
  }
}
