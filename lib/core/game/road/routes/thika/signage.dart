// Project imports:
import '../../props/sign_panel.dart';

const List<SignPanel> exit17Panels = [
  SignPanel(
    [
      SignRow('Thika', code: '(G3203)'),
      SignRow('Garissa', code: '(A3)'),
      SignRow('Mangu', code: '(C66)'),
      SignRow('Nakuru', code: '(A 104)'),
    ],
    side: [SignRow('Nairobi'), SignRow('(A2)')],
    tab: 'EXIT 17',
    footer: 'LANE 1',
    arrow: SignArrow.exit,
    weight: 1.3,
  ),
  SignPanel(
    [
      SignRow('Juja', tail: '11 km'),
      SignRow('Ruiru', tail: '19 km'),
      SignRow('Githurai', tail: '27 km'),
      SignRow('Nairobi', tail: '41 km'),
    ],
    tab: 'A2',
    footer: 'LANE 2',
    arrow: SignArrow.up,
  ),
];

const List<SignPanel> exit16Panels = [
  SignPanel(
    [
      SignRow('Vehicles over 3.5 tonnes'),
      SignRow('keep left'),
      SignRow('Weighbridge Ahead'),
    ],
    footer: 'LANE 1',
    arrow: SignArrow.exit,
    weight: 1.3,
  ),
  SignPanel(
    [
      SignRow('Ruiru', tail: '4 km'),
      SignRow('Kenyatta'),
      SignRow('University', tail: '9 km'),
      SignRow('Githurai', tail: '12 km'),
    ],
    tab: 'A2',
    footer: 'LANE 2',
    arrow: SignArrow.up,
  ),
  SignPanel(
    [
      SignRow('Kasarani', tail: '16 km'),
      SignRow('Muthaiga', tail: '23 km'),
      SignRow('Nairobi', code: "(A2)", tail: '27 km'),
    ],
    footer: 'LANE 3',
    arrow: SignArrow.up,
  ),
];

const List<SignPanel> exit11Panels = [
  SignPanel(
    [
      SignRow('Kiambu   (C63)'),
      SignRow('Embakasi (E1599)'),
      SignRow('J.K.I.A✈️', code: '(A104)'),
      SignRow('Mombasa', code: '(A109)'),
    ],
    side: [SignRow('Nairobi'), SignRow('(A2)')],
    tab: 'EXIT 11',
    footer: 'LANE 1',
    arrow: SignArrow.exit,
  ),
  SignPanel(
    [
      SignRow('Kenyatta'),
      SignRow('University', tail: '4 km'),
      SignRow('Kahawa', tail: '5 km'),
      SignRow('Githurai', tail: '7 km'),
    ],
    tab: 'A2',
    footer: 'LANE 2',
    arrow: SignArrow.up,
  ),
  SignPanel(
    [
      SignRow('Kasarani', tail: '11 km'),
      SignRow('Muthaiga', tail: '17 km'),
      SignRow('Nairobi', code: "(A2)", tail: '21 km'),
    ],
    footer: 'LANE 3',
    arrow: SignArrow.up,
  ),
];

const List<SignPanel> exit10Panels = [
  SignPanel(
    [
      SignRow('Kahawa Sukari'),
      SignRow('Kenyatta University'),
      SignRow('Kahawa Estate'),
    ],
    side: [SignRow('Nairobi'), SignRow('(A2)')],
    tab: 'EXIT 10',
    footer: 'LANE 1',
    arrow: SignArrow.exit,
  ),
  SignPanel(
    [
      SignRow('Nairobi', tail: '17 km'),
      SignRow('Nakuru', tail: '175 km'),
      SignRow('Namanga', tail: '181 km'),
    ],
    tab: 'A2',
    footer: 'LANE 2',
    arrow: SignArrow.up,
  ),
  SignPanel(
    [
      SignRow('Eldoret', code: 'A109', tail: '328 km'),
      SignRow('Mombasa', code: 'A109', tail: '504 km'),
      SignRow('Kisumu', code: '(A1)', tail: '362 km'),
    ],
    footer: 'LANE 3',
    arrow: SignArrow.up,
  ),
];

const List<SignPanel> exit8Panels = [
  SignPanel(
    [
      SignRow('Kasarani'),
      SignRow('Mwiki'),
      SignRow('Kamiti Road'),
      SignRow('Moi Intl Sports'),
      SignRow('Garden City'),
    ],
    side: [SignRow('Nairobi'), SignRow('(A2)')],
    tab: 'EXIT 8',
    footer: 'LANE 1',
    arrow: SignArrow.exit,
  ),
  SignPanel(
    [
      SignRow('Nairobi', tail: '11 km'),
      SignRow('Nakuru', tail: '169 km'),
      SignRow('Namanga', tail: '175 km'),
    ],
    tab: 'A2',
    footer: 'LANE 2',
    arrow: SignArrow.up,
  ),
  SignPanel(
    [
      SignRow('Eldoret', code: 'A109', tail: '322 km'),
      SignRow('Mombasa', code: 'A109', tail: '498 km'),
      SignRow('Kisumu', code: '(A1)', tail: '365 km'),
    ],
    footer: 'LANE 3',
    arrow: SignArrow.up,
  ),
];

const List<SignPanel> exit7Panels = [
  SignPanel(
    [
      SignRow('EABL'),
      SignRow('Garden Estate'),
      SignRow('Safari Park Hotel'),
      SignRow('USIU'),
      SignRow('Garden City'),
    ],
    side: [SignRow('Nairobi'), SignRow('(A2)')],
    tab: 'EXIT 7',
    footer: 'LANE 1',
    arrow: SignArrow.exit,
  ),
  SignPanel(
    [
      SignRow('Nairobi', code: '(A2)', tail: '9 km'),
      SignRow('Nakuru', code: '(A104)', tail: '167 km'),
    ],
    tab: 'A2',
    footer: 'LANE 2',
    arrow: SignArrow.up,
  ),
  SignPanel(
    [
      SignRow('Namanga', code: '(A104)', tail: '173 km'),
      SignRow('Eldoret', code: '(A104)', tail: '320 km'),
    ],
    tab: 'A2',
    footer: 'LANE 3',
    arrow: SignArrow.up,
  ),
  SignPanel(
    [
      SignRow('Mombasa', code: 'A109', tail: '496 km'),
      SignRow('Kisumu', code: '(A1)', tail: '354'),
    ],
    footer: 'LANE 4',
    arrow: SignArrow.up,
  ),
];
