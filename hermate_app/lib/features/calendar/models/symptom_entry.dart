class SymptomEntry {
  final DateTime date;
  final String mood;
  final String flow;
  final int crampsLevel;
  final bool headache;
  final bool backPain;
  final int energyLevel;
  final int sleepHours;
  final String notes;

  SymptomEntry({
    required this.date,
    required this.mood,
    required this.flow,
    required this.crampsLevel,
    required this.headache,
    required this.backPain,
    required this.energyLevel,
    required this.sleepHours,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'mood': mood,
      'flow': flow,
      'crampsLevel': crampsLevel,
      'headache': headache,
      'backPain': backPain,
      'energyLevel': energyLevel,
      'sleepHours': sleepHours,
      'notes': notes,
    };
  }

  factory SymptomEntry.fromMap(Map<String, dynamic> map) {
    return SymptomEntry(
      date: DateTime.parse(map['date'] as String),
      mood: map['mood'] as String,
      flow: map['flow'] as String,
      crampsLevel: map['crampsLevel'] as int,
      headache: map['headache'] as bool,
      backPain: map['backPain'] as bool,
      energyLevel: map['energyLevel'] as int,
      sleepHours: map['sleepHours'] as int,
      notes: map['notes'] as String,
    );
  }
}
