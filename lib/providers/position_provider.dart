import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../database/daos/position_dao.dart';
import '../database/app_database.dart';

class PositionProvider extends ChangeNotifier {
  final PositionDao _dao;

  List<Position> _positions = [];
  bool _isLoading = false;
  String? _error;

  PositionProvider(this._dao) {
    load();
  }

  String _search = '';

  List<Position> get positions => _positions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Position> get filtered {
    if (_search.isEmpty) return _positions;
    final q = _search.toLowerCase();
    return _positions.where((p) =>
        p.name.toLowerCase().contains(q) ||
        (p.description?.toLowerCase().contains(q) ?? false)).toList();
  }

  void setSearch(String v) {
    _search = v;
    notifyListeners();
  }

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _positions = await _dao.getAll();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(String name, String? description) async {
    await _dao.insertOne(PositionsCompanion(
      name: drift.Value(name),
      description: drift.Value(description),
    ));
    await load();
  }

  Future<void> edit(int id, String name, String? description) async {
    await _dao.updateOne(PositionsCompanion(
      id: drift.Value(id),
      name: drift.Value(name),
      description: drift.Value(description),
    ));
    await load();
  }

  Future<void> remove(int id) async {
    await _dao.deleteOne(id);
    await load();
  }

  Future<int> count() => _dao.countAll();
}
