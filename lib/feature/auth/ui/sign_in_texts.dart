// Project imports:
import '../../../l10n/gen/app_localizations.dart';
import '../cubit/sign_in_cubit.dart';

extension SignInTexts on AppLocalizations {
  String signInHint(SignInState st) => switch (st.stage) {
    SignInStage.name => signInNameHint,
    SignInStage.answer => signInAnswerHint(st.name),
    SignInStage.challenge => signInChallengeHint(st.name),
    SignInStage.create => signInNewHint(st.name),
  };

  String? signInErrorText(SignInState st) => switch (st.error) {
    null => null,
    SignInError.invalidName => errInvalidName,
    SignInError.wrongAnswer => errWrongAnswer(st.number),
    SignInError.locked => errLocked(st.number),
    SignInError.network => errNetwork,
    SignInError.notConfigured => errNotConfigured,
    SignInError.nameTaken => errNameTaken,
    SignInError.wrongChallenge => errWrongChallenge(st.number),
    SignInError.invalidQuestion => errInvalidQuestion,
    SignInError.invalidAnswer => errInvalidAnswer,
    SignInError.mismatch => errMismatch,
    SignInError.generic => errGeneric,
  };
}
