import '../../props/sign_panel.dart';

const List<SignBoard> pelicanBoards = [
  SignBoard(['SPEED THRILLS', 'BUT KILLS']),
  SignBoard(['SLOW TRAFFIC', 'KEEP LEFT']),
];

const List<SignBoard> pelicanBoards1 = [
  SignBoard(['NO TEXTING', 'WHILE DRIVING']),
  SignBoard(['', '']),
];

const List<SignBoard> pelicanBoards2 = [
  SignBoard(['CHECK TYRES', 'REGULARLY']),
  SignBoard(['JUST OBEY', 'TRAFFIC RULES']),
];

const SignPanel exitThika = SignPanel.named([
  SignRow('Thika', code: '(G 3203)'),
  SignRow('Garissa', code: 'A 3'),
]);

const SignPanel exitJuja = SignPanel.named([
  SignRow('Nairobi', code: 'A2'),
  SignRow('Juja', code: 'E490'),
]);

const SignPanel exitRuiru = SignPanel.named([
  SignRow('Kiambu', tail: 'C 63'),
  SignRow('Embakasi', tail:'E 1599'),
]);

const SignPanel exitKroad = SignPanel.named([
  SignRow('Gatundu', code: 'D397'),
]);

const SignPanel exitGithurai = SignPanel.named([
  SignRow('Githurai'),
  SignRow('Kimbo'),
  SignRow('Kamiti'),
  SignRow('Kahawa Barracks'),
  SignRow('',tail: 'EXIT 500 m'),
]);
