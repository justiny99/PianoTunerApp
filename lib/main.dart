import 'package:device_preview/device_preview.dart';
import 'package:device_preview/presets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_ui/cupertino_ui.dart';

void main() {
  DevicePreview.enable();
  runApp(const PianoTunerApp());
}


class PianoTunerApp extends StatelessWidget {
  /// Creates the example app.
  const PianoTunerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Cupertino UI App'),
        ),
        child: Center(
          child: HomeShell(),
        ),
      )

    );
  }
}


class HomeShell extends StatefulWidget {
  /// Creates the shell.
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {

  @override
  Widget build(BuildContext context) {

    final Widget page = const CharacteristicsPage();

    return Scaffold(
      body: page,
    );
  }
}


class CharacteristicsPage extends StatelessWidget {
  /// Creates the page.
  const CharacteristicsPage({super.key});

  String _edgeInsets(EdgeInsets insets) =>
      'L ${insets.left.toStringAsFixed(1)} · '
      'T ${insets.top.toStringAsFixed(1)} · '
      'R ${insets.right.toStringAsFixed(1)} · '
      'B ${insets.bottom.toStringAsFixed(1)}';

  @override
  Widget build(BuildContext context) {
    // Everything below is plain framework API — no device_preview imports
    // needed to *observe* a simulation. MediaQuery.of registers this widget
    // for rebuilds, which is what makes the readout live.
    final MediaQueryData media = MediaQuery.of(context);
    final Locale locale = Localizations.localeOf(context);
    final List<Locale> platformLocales =
        View.of(context).platformDispatcher.locales;

    // A 16px reference reading makes the effect of non-trivial TextScaler
    // implementations visible as a single number.
    final double effectiveScale = media.textScaler.scale(16) / 16;

    return CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar.large(title: Text('Device characteristics')),
        SliverList(
          delegate: SliverChildListDelegate(<Widget>[
            _Section(
              title: 'Screen',
              children: <Widget>[
                _ValueRow(
                  'MediaQuery.size',
                  '${media.size.width.toStringAsFixed(1)} × '
                      '${media.size.height.toStringAsFixed(1)} logical px',
                ),
                _ValueRow(
                  'devicePixelRatio',
                  media.devicePixelRatio.toStringAsFixed(2),
                ),
                _ValueRow('orientation', media.orientation.name),
                _ValueRow(
                  'displayFeatures',
                  media.displayFeatures.isEmpty
                      ? 'none'
                      : media.displayFeatures
                            .map((ui) => ui.type.name)
                            .join(', '),
                ),
              ],
            ),
            _Section(
              title: 'Insets (logical px)',
              children: <Widget>[
                _ValueRow('padding', _edgeInsets(media.padding)),
                _ValueRow('viewPadding', _edgeInsets(media.viewPadding)),
                _ValueRow(
                  'viewInsets (keyboard)',
                  _edgeInsets(media.viewInsets),
                ),
                _ValueRow(
                  'systemGestureInsets',
                  _edgeInsets(media.systemGestureInsets),
                ),
              ],
            ),
            _Section(
              title: 'Appearance & text',
              children: <Widget>[
                _ValueRow('platformBrightness', media.platformBrightness.name),
                _ValueRow(
                  'textScaler',
                  '×${effectiveScale.toStringAsFixed(2)}',
                ),
                _ValueRow(
                  'alwaysUse24HourFormat',
                  '${media.alwaysUse24HourFormat}',
                ),
              ],
            ),
            _Section(
              title: 'Locale & platform',
              children: <Widget>[
                _ValueRow('Localizations.localeOf', locale.toLanguageTag()),
                _ValueRow(
                  'PlatformDispatcher.locales',
                  platformLocales
                      .map((Locale l) => l.toLanguageTag())
                      .join(', '),
                ),
                _ValueRow('defaultTargetPlatform', defaultTargetPlatform.name),
              ],
            ),
            _Section(
              title: 'Accessibility',
              children: <Widget>[
                _FlagRow('accessibleNavigation', media.accessibleNavigation),
                _FlagRow('boldText', media.boldText),
                _FlagRow('disableAnimations', media.disableAnimations),
                _FlagRow('highContrast', media.highContrast),
                _FlagRow('invertColors', media.invertColors),
                _FlagRow('onOffSwitchLabels', media.onOffSwitchLabels),
              ],
            ),
            const SizedBox(height: 24),
          ]),
        ),
      ],
    );
  }
}

/// A titled group of value rows.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          ...children,
        ],
      ),
    );
  }
}

/// A single "label: value" line, tabular-styled.
class _ValueRow extends StatelessWidget {
  const _ValueRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(child: Text(label, style: text.bodyMedium)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: text.bodyMedium?.copyWith(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}

/// A boolean accessibility flag rendered as a small on/off chip.
class _FlagRow extends StatelessWidget {
  const _FlagRow(this.label, this.value);

  final String label;
  final bool value;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: value ? colors.primaryContainer : colors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value ? 'on' : 'off',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: value
                    ? colors.onPrimaryContainer
                    : colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
