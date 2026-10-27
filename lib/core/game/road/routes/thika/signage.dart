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

// Numbered exits: the blue EXIT / KUTOKA board, only the number changes.
// They count down towards Nairobi.
const SignPanel exit17 = SignPanel.numbered('17');
const SignPanel exit16 = SignPanel.numbered('16');
const SignPanel exit15 = SignPanel.numbered('15');
const SignPanel exit14 = SignPanel.numbered('14');

// Named exits: the green destination board, one row per destination.
const SignPanel exitThika = SignPanel.named([
  SignRow('Thika', code: '(G 3203)'),
  SignRow('Garissa', code: 'A 3'),
]);
