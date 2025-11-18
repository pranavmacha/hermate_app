import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/symptom_entry.dart';
import '../storage/symptom_storage.dart';

class SymptomLogScreen extends StatefulWidget {
  const SymptomLogScreen({
    super.key,
    required this.selectedDate,
    required this.box,
  });

  final DateTime selectedDate;
  final Box box;

  @override
  State<SymptomLogScreen> createState() => _SymptomLogScreenState();
}

class _SymptomLogScreenState extends State<SymptomLogScreen> {
  late SymptomStorage storage;

  String _mood = 'normal';
  String _flow = 'none';
  double _crampsSlider = 0;
  bool _headache = false;
  bool _backPain = false;
  double _energySlider = 3;
  double _sleepHours = 7;
  final TextEditingController _notesController = TextEditingController();

  String? _aiAdvice;

  @override
  void initState() {
    super.initState();
    storage = SymptomStorage(widget.box);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  SymptomEntry _buildEntry() {
    return SymptomEntry(
      date: widget.selectedDate,
      mood: _mood,
      flow: _flow,
      crampsLevel: _crampsSlider.round(),
      headache: _headache,
      backPain: _backPain,
      energyLevel: _energySlider.round(),
      sleepHours: _sleepHours.round(),
      notes: _notesController.text.trim(),
    );
  }

  Future<void> _saveEntry() async {
    final entry = _buildEntry();
    await storage.addEntry(entry);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Symptoms saved ✅')),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final dateStr =
        "${widget.selectedDate.day}-${widget.selectedDate.month}-${widget.selectedDate.year}";

    return Scaffold(
      appBar: AppBar(
        title: Text('Log Symptoms – $dateStr'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mood',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: _mood,
              items: const [
                DropdownMenuItem(value: 'happy', child: Text('Happy 🙂')),
                DropdownMenuItem(value: 'normal', child: Text('Normal 😐')),
                DropdownMenuItem(value: 'sad', child: Text('Sad 😔')),
                DropdownMenuItem(value: 'irritable', child: Text('Irritable 😡')),
              ],
              onChanged: (val) {
                setState(() => _mood = val ?? 'normal');
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Flow',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: _flow,
              items: const [
                DropdownMenuItem(value: 'none', child: Text('None')),
                DropdownMenuItem(value: 'light', child: Text('Light')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'heavy', child: Text('Heavy')),
              ],
              onChanged: (val) {
                setState(() => _flow = val ?? 'none');
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Cramps (0 = none, 3 = severe)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Slider(
              min: 0,
              max: 3,
              divisions: 3,
              label: _crampsSlider.round().toString(),
              value: _crampsSlider,
              onChanged: (v) {
                setState(() => _crampsSlider = v);
              },
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Headache'),
              value: _headache,
              onChanged: (v) => setState(() => _headache = v),
            ),
            SwitchListTile(
              title: const Text('Back pain'),
              value: _backPain,
              onChanged: (v) => setState(() => _backPain = v),
            ),
            const SizedBox(height: 8),
            const Text(
              'Energy (1 = exhausted, 5 = super active)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Slider(
              min: 1,
              max: 5,
              divisions: 4,
              label: _energySlider.round().toString(),
              value: _energySlider,
              onChanged: (v) => setState(() => _energySlider = v),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sleep hours (approx)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Slider(
              min: 0,
              max: 12,
              divisions: 12,
              label: '${_sleepHours.round()} h',
              value: _sleepHours,
              onChanged: (v) => setState(() => _sleepHours = v),
            ),
            const SizedBox(height: 8),
            const Text(
              'Notes (optional)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Anything else you noticed today…',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveEntry,
                child: const Text('Save Symptoms'),
              ),
            ),
            const SizedBox(height: 16),
            if (_aiAdvice != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.pink.shade50,
                ),
                child: Text(
                  _aiAdvice!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
