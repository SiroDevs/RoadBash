// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../common/app_router/route_names.dart';
import '../../common/widgets/retro/retro_style.dart';
import '../game/game_settings.dart';

/// Reception: the settings desk. Pick an item on the left, edit it on the
/// right. Changes save immediately.
class ReceptionScreen extends StatefulWidget {
  const ReceptionScreen({super.key});

  @override
  State<ReceptionScreen> createState() => ReceptionScreenState();
}

class ReceptionScreenState extends State<ReceptionScreen> {
  static const _items = ['Player Name', 'Sound Mix', 'Controls', 'Done'];
  final _settings = GameSettings.instance;
  late final _name = TextEditingController(text: _settings.playerName);
  int _sel = 0;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _pick(int i) {
    if (_items[i] == 'Done') {
      context.goNamed(RouteNames.menu);
    } else {
      setState(() => _sel = i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RetroBackdrop(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RetroTitle('Reception'),
                const SizedBox(height: 16),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _menu()),
                      const SizedBox(width: 16),
                      Expanded(flex: 3, child: _detail()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menu() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < _items.length; i++)
            InkWell(
              onTap: () => _pick(i),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Icon(Icons.arrow_forward,
                        size: 20,
                        color: i == _sel ? Retro.yellow : Colors.transparent),
                    const SizedBox(width: 6),
                    Text(_items[i],
                        style: retroBody(
                            size: 22, color: i == _sel ? Colors.white : Retro.dim)),
                  ],
                ),
              ),
            ),
        ],
      );

  Widget _detail() => Container(
        color: Retro.panel,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: switch (_sel) {
            0 => _nameEditor(),
            1 => _soundMix(),
            _ => _controls(),
          },
        ),
      );

  Widget _nameEditor() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pick the name shown on your dashboard and in the results.',
              style: retroBody()),
          const SizedBox(height: 12),
          TextField(
            controller: _name,
            maxLength: 12,
            style: const TextStyle(color: Colors.white, fontSize: 22),
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Retro.dim)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Retro.orange)),
              counterStyle: TextStyle(color: Retro.dim),
            ),
            onChanged: (v) {
              final name = v.trim();
              if (name.isNotEmpty) _settings.update(name: name);
            },
          ),
        ],
      );

  Widget _soundMix() => ListenableBuilder(
        listenable: _settings,
        builder: (context, _) => Column(
          children: [
            _slider('Master', _settings.master, (v) => _settings.update(master: v)),
            _slider('Engine', _settings.engine, (v) => _settings.update(engine: v)),
            _slider('Tyres', _settings.tyres, (v) => _settings.update(tyres: v)),
          ],
        ),
      );

  Widget _slider(String label, double value, ValueChanged<double> onChanged) =>
      Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: retroBody(size: 18))),
          Expanded(
            child: Slider(
              value: value,
              activeColor: Retro.orange,
              onChanged: onChanged,
            ),
          ),
        ],
      );

  Widget _controls() => Text(
        'Throttle is automatic.\n\n'
        'Keyboard: arrows or A / D steer, down / S / Space brakes.\n\n'
        'Touch: press the left or right side to steer, the middle strip to brake.',
        style: retroBody(),
      );
}
