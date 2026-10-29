// Project imports:
import '../../props/sign_panel.dart';

const List<SignPanel> exit6Panels = [
  SignPanel(
    [
      SignRow('Police Logistics Center'),
      SignRow('Outer Ring Road'),
      SignRow('GSU'),
      SignRow('KSMS'),
      SignRow('Garden City'),
    ],
    side: [SignRow('Nairobi'), SignRow('(A2)')],
    tab: 'EXIT 6',
    footer: 'LANE 1',
    arrow: SignArrow.exit,
  ),
  SignPanel(
    [
      SignRow('Nairobi', code: '(A2)', tail: '8 km'),
      SignRow('Nakuru', code: '(A104)', tail: '166 km'),
      SignRow('Namanga', code: '(A104)', tail: '172 km'),
    ],
    tab: 'A2',
    footer: 'LANE 2',
    arrow: SignArrow.up,
  ),
  SignPanel(
    [
      SignRow('Eldoret', code: '(A104)', tail: '319 km'),
      SignRow('Mombasa', code: '(A104)', tail: '495 km'),
      SignRow('Kisumu', code: '(A1)', tail: '353 km'),
    ],
    tab: 'A2',
    footer: 'LANE 3',
    arrow: SignArrow.up,
  ),
];

const List<SignPanel> exit5Panels = [
  SignPanel(
    [
      SignRow('KCA University'),
      SignRow('Survey of Kenya'),
      SignRow('Traffic Police HQ'),
      SignRow('NYS'),
    ],
    side: [SignRow('Nairobi'), SignRow('(A2)')],
    tab: 'EXIT 5',
    footer: 'LANE 1',
    arrow: SignArrow.exit,
  ),
  SignPanel(
    [
      SignRow('Nairobi', code: '(A2)', tail: '6 km'),
      SignRow('Nakuru', code: '(A104)', tail: '194 km'),
    ],
    tab: 'A2',
    footer: 'LANE 2',
    arrow: SignArrow.up,
  ),
  SignPanel(
    [
      SignRow('Namanga', code: '(A104)', tail: '170 km'),
      SignRow('Eldoret', code: '(A104)', tail: '317 km'),
    ],
    tab: 'A2',
    footer: 'LANE 3',
    arrow: SignArrow.up,
  ),
  SignPanel(
    [
      SignRow('Mombasa', code: '(A104)', tail: '493 km'),
      SignRow('Kisumu', code: '(A1)', tail: '351 km'),
    ],
    footer: 'LANE 4',
    arrow: SignArrow.up,
  ),
];

const List<SignPanel> exit4Panels = [
  SignPanel(
    [
      SignRow('Ring Rd. Ngara'),
      SignRow('Eastleigh'),
      SignRow('Machakos Town', code: '(A104/A109)'),
    ],
    side: [SignRow('CBD')],
    tab: 'EXIT 4',
    footer: 'LANE 1',
    arrow: SignArrow.exit,
    weight: 1.3,
  ),
  SignPanel(
    [
      SignRow("Murang'a Rd"),
      SignRow("Kirinyaga Rd"),
      SignRow("Tom Mboya St"),
      SignRow("University Way"),
    ],
    footer: 'LANE 2',
    arrow: SignArrow.up,
  ),
  SignPanel(
    [
      SignRow('Forest Rd'),
      SignRow('Machakos 61 km'),
      SignRow('Namanga 168 km'),
      SignRow('Mombasa 491 km', code: '(A104/A109)'),
    ],
    tab: 'A2',
    footer: 'LANE 3',
    arrow: SignArrow.up,
  ),
  SignPanel(
    [
      SignRow('Forest Rd'),
      SignRow('Nakuru', tail: '162 km'),
      SignRow('Eldoret', tail: '316 km'),
      SignRow('Kisumu', tail: '350 km (B1)'),
      SignRow('Malaba', code: 'A104', tail: '482 km'),
    ],
    footer: 'LANE 4',
    arrow: SignArrow.up,
  ),
];

const List<SignPanel> panganiPanels = [
  SignPanel(
    [
      SignRow("Murang'a Rd"),
    ],
    footer: 'KEEP LEFT',
    arrow: SignArrow.up,
    weight: 1.3,
  ),
  SignPanel(
    [
      SignRow("Professor Wangari"),
      SignRow("Maathai Rd"),
    ],
    footer: 'KEEP RIGHT',
    arrow: SignArrow.upRight,
    weight: 1.3,
  ),
];

const List<SignPanel> exit2Panels = [
  SignPanel(
    [SignRow('Limuru', tail: '29km'), SignRow('Parklands')],
    tab: 'EXIT 2',
    footer: 'LANE 1',
    arrow: SignArrow.exit,
    weight: 1.3,
  ),
  SignPanel(
    [
      SignRow('Machakos', code: 'A109', tail: '58 km'),
      SignRow('Mombasa', code: 'A109', tail: '489 km'),
    ],
    tab: 'A2',
    footer: 'LANE 2',
    arrow: SignArrow.up,
  ),
  SignPanel(
    [
      SignRow('Naivasha', code: 'A104', tail: '104 km'),
      SignRow('Nakuru', code: 'A104', tail: '159 km'),
      SignRow('Eldoret', code: 'A104', tail: '313 km'),
      SignRow('Malaba', code: 'A104', tail: '479 km'),
    ],
    tab: 'A2',
    footer: 'LANE 2',
    arrow: SignArrow.up,
  ),
];
