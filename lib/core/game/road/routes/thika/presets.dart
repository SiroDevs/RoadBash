// Project imports:
import '../../track/road_section.dart';
import '../route_stretch.dart';

const Section atGrade = Section();
const Section planted = Section(median: MedianKind.planted);
const Section bridged = Section(left: VergeKind.paved, median: MedianKind.planted, railLeft: true);
const Section elevated = Section(
  left: VergeKind.paved,
  right: VergeKind.paved,
  median: MedianKind.planted,
  railLeft: true,
);
const Section cutting = Section(left: VergeKind.paved, railLeft: true);
const Section trench = Section(
  left: VergeKind.paved,
  right: VergeKind.paved,
  median: MedianKind.none,
);
const Section urban = Section(
  left: VergeKind.paved,
  right: VergeKind.paved,
  median: MedianKind.barrier,
);

const (double, double) farRight = (3.9, 5.2);
const (double, double) farRightTrees = (3.8, 6.0);
const (double, double) serviceSide = (3.0, 3.2);
const (double, double) nearLeft = (1.6, 2.4);

const SideScenery noScenery = SideScenery();

const TreeMix bushy = TreeMix(0.2, 0.1, 0.4, 0.3);
