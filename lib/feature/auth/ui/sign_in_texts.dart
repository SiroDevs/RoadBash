// Project imports:
import '../../../l10n/gen/app_localizations.dart';
import '../cubit/sign_in_cubit.dart';

/// Localized hint and error text for the sign-in flow.
extension SignInTexts on AppLocalizations {
  /// Returns the hint text for the current sign-in stage.
  String signInHint(SignInState st) => switch (st.stage) {
    SignInStage.name => signInNameHint,
    SignInStage.answer => signInAnswerHint(st.name),
    SignInStage.challenge => signInChallengeHint(st.name),
    SignInStage.create => signInNewHint(st.name),
  };

  /// Returns the error text for the current sign-in error, if any.
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
