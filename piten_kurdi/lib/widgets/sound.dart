import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../app_scope.dart';
import '../letters.dart';
import '../sounds.dart';
import '../theme.dart';

/// A big speaker button that plays the letter's sound from the YouTube video.
/// Greyed out until the letter's place in the video has been marked.
class PlaySoundButton extends StatelessWidget {
  const PlaySoundButton({super.key, required this.letter, this.size = 64});
  final KurdishLetter letter;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final sounds = AppScope.of(context).sounds;
    return ListenableBuilder(
      listenable: sounds,
      builder: (context, _) {
        final clip = sounds.clipFor(letter.char);
        final ready = clip != null;
        return Semantics(
          button: true,
          label: 'گوهـ بدە پیتا ${letter.char}',
          child: SizedBox.square(
            dimension: size,
            child: IconButton.filled(
              key: ValueKey('play-${letter.char}'),
              enableFeedback: false,
              iconSize: size * 0.5,
              style: IconButton.styleFrom(
                backgroundColor: ready ? p.sun : p.line,
                foregroundColor: ready ? const Color(0xFF2A1F00) : p.muted,
              ),
              onPressed: ready ? () => showSoundClip(context, letter, clip) : null,
              icon: Icon(ready ? Icons.volume_up_rounded : Icons.volume_off_rounded),
            ),
          ),
        );
      },
    );
  }
}

Future<void> showSoundClip(BuildContext context, KurdishLetter letter, SoundClip clip) {
  return showDialog<void>(
    context: context,
    builder: (_) => Directionality(
      textDirection: TextDirection.rtl,
      child: _SoundDialog(letter: letter, clip: clip),
    ),
  );
}

/// Plays one part of the YouTube video in a small visible player.
class _SoundDialog extends StatefulWidget {
  const _SoundDialog({required this.letter, required this.clip});
  final KurdishLetter letter;
  final SoundClip clip;

  @override
  State<_SoundDialog> createState() => _SoundDialogState();
}

class _SoundDialogState extends State<_SoundDialog> {
  late final YoutubePlayerController _yt = YoutubePlayerController.fromVideoId(
    videoId: soundVideoId,
    autoPlay: true,
    startSeconds: widget.clip.start,
    endSeconds: widget.clip.end,
    params: const YoutubePlayerParams(
      showControls: false,
      showFullscreenButton: false,
      strictRelatedVideos: true,
      enableKeyboard: false,
      showVideoAnnotations: false,
    ),
  );

  @override
  void dispose() {
    _yt.close();
    super.dispose();
  }

  void _replay() => _yt.loadVideoById(
        videoId: soundVideoId,
        startSeconds: widget.clip.start,
        endSeconds: widget.clip.end,
      );

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Dialog(
      backgroundColor: p.surface,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.letter.char, style: letterStyle(110, p.green).copyWith(height: 1.3)),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: YoutubePlayer(controller: _yt, autoFullScreen: false, enableFullScreenOnVerticalDrag: false),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RoundAction(icon: Icons.replay_rounded, color: p.sun, onTap: _replay, label: 'دووبارە'),
                const SizedBox(width: 24),
                _RoundAction(
                  icon: Icons.close_rounded,
                  color: p.line,
                  onTap: () => Navigator.of(context).pop(),
                  label: 'گرتن',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({required this.icon, required this.color, required this.onTap, required this.label});
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
        label: label,
        button: true,
        child: SizedBox.square(
          dimension: 72,
          child: IconButton.filled(
            enableFeedback: false,
            iconSize: 38,
            style: IconButton.styleFrom(backgroundColor: color, foregroundColor: context.palette.ink),
            onPressed: onTap,
            icon: Icon(icon),
          ),
        ),
      );
}
