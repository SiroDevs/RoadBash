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

const List<SignBoard> pelicanBoards = [
  SignBoard(['SPEED THRILLS', 'BUT KILLS']),
  SignBoard(['SLOW TRAFFIC', 'KEEP LEFT']),
];

const SignPanel exitThika = SignPanel.named([
  SignRow('Thika', code: '(G 3203)'),
  SignRow('Garissa', code: 'A 3'),
]);
const SignPanel exitJuja = SignPanel.named([
  SignRow('Nairobi', code: 'A2'),
  SignRow('Juja', code: 'E490'),
]);

const List<SignPanel> tollPanels = [
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
      SignRow('Kenyatta', tail: ''),
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
