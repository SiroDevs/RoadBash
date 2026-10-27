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

const SignPanel exitThikaSign = SignPanel([
  SignRow('Thika', code: '(G3203)'),
  SignRow('Garissa', code: '(A3)'),
]);

const SignPanel exit17 = SignPanel([
  SignRow('EXIT', code: '17'),
  SignRow('KUTOKA'),
]);
