import 'package:hive/hive.dart';

import '../models/symptom_entry.dart';

class SymptomStorage {
  SymptomStorage(this.box);

  final Box box;

  static const String _symptomKey = 'symptomLogs';

  List<SymptomEntry> getAllEntries() {
    final raw = box.get(_symptomKey, defaultValue: <dynamic>[]);
    final list = <SymptomEntry>[];

    if (raw is List) {
      for (final item in raw) {
        if (item is Map) {
          list.add(
            SymptomEntry.fromMap(
              Map<String, dynamic>.from(item as Map),
            ),
          );
        }
      }
    }

    return list;
  }

  Future<void> addEntry(SymptomEntry entry) async {
    final current = getAllEntries();
    current.add(entry);

    final toStore = current.map((e) => e.toMap()).toList();
    await box.put(_symptomKey, toStore);
  }

  List<SymptomEntry> getEntriesForDate(DateTime date) {
    final all = getAllEntries();
    return all
        .where(
          (e) =>
              e.date.year == date.year &&
              e.date.month == date.month &&
              e.date.day == date.day,
        )
        .toList();
  }
}
