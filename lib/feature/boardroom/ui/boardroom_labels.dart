// Project imports:
import '../../../l10n/gen/app_localizations.dart';
import '../cubit/boardroom_cubit.dart';

/// The localized text for a boardroom error.
String boardroomErrorText(AppLocalizations l10n, BoardroomError error) =>
    switch (error) {
      BoardroomError.tooShort => l10n.boardroomTooShort,
      BoardroomError.rateLimited => l10n.boardroomRateLimited,
      BoardroomError.signIn => l10n.boardroomSignIn,
      BoardroomError.forbidden => l10n.boardroomForbidden,
      BoardroomError.network => l10n.errNetwork,
    };

/// The hint under the strips; it depends on the strip and on admin or player.
String boardroomHint(AppLocalizations l10n, BoardroomState state) {
  final announcements = state.tab == BoardroomTab.announcements;
  return switch ((announcements, state.admin)) {
    (true, true) => l10n.boardroomAdminAnnounceHint,
    (true, false) => l10n.boardroomAnnouncementsHint,
    (false, true) => l10n.boardroomAdminHint,
    (false, false) => l10n.boardroomHint,
  };
}
