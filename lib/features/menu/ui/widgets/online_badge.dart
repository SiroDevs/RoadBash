// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';

// Project imports:
import '../../../../common/l10n/l10n_extension.dart';
import '../../../../common/layout/retro_sizes.dart';
import '../../../../common/widgets/retro/retro_style.dart';
import '../../../../core/di/injectable.dart';
import '../../cubit/online_cubit.dart';

/// Shows how many players are online.
class OnlineBadge extends StatelessWidget {
  const OnlineBadge({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<OnlineCubit>()..start(),
    child: BlocBuilder<OnlineCubit, int?>(
      builder: (context, count) {
        if (count == null) return const SizedBox.shrink();
        final sizes = context.sizes;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox.square(dimension: 10)
                .decorated(color: Colors.lightGreenAccent, shape: BoxShape.circle),
            SizedBox(width: sizes.gapSmall),
            Text(
              context.l10n.menuOnline(count),
              style: retroBody(size: sizes.body, color: Colors.lightGreenAccent),
            ),
          ],
        );
      },
    ),
  );
}
