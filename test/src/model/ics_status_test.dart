import 'package:icalendar_parser/src/model/ics_status.dart';
import 'package:test/test.dart';

void main() {
  group('IcsStatusModifier', () {
    test('string', () {
      expect(IcsStatus.cancelled.key, 'CANCELLED');
      expect(IcsStatus.completed.key, 'COMPLETED');
      expect(IcsStatus.confirmed.key, 'CONFIRMED');
      expect(IcsStatus.draft.key, 'DRAFT');
      expect(IcsStatus.inProcess.key, 'IN-PROCESS');
      expect(IcsStatus.isFinal.key, 'FINAL');
      expect(IcsStatus.needsAction.key, 'NEEDS-ACTION');
      expect(IcsStatus.tentative.key, 'TENTATIVE');
    });
  });
}
