import 'package:icalendar_parser/src/model/ics_status.dart';
import 'package:test/test.dart';

void main() {
  group('IcsStatusModifier', () {
    test('string', () {
      expect(IcsStatus.cancelled.value, 'CANCELLED');
      expect(IcsStatus.completed.value, 'COMPLETED');
      expect(IcsStatus.confirmed.value, 'CONFIRMED');
      expect(IcsStatus.draft.value, 'DRAFT');
      expect(IcsStatus.inProcess.value, 'IN-PROCESS');
      expect(IcsStatus.isFinal.value, 'FINAL');
      expect(IcsStatus.needsAction.value, 'NEEDS-ACTION');
      expect(IcsStatus.tentative.value, 'TENTATIVE');
    });
  });
}
