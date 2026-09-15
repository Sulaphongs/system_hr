import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../database/daos/military_rank_dao.dart';
import '../database/app_database.dart';

class MilitaryRankProvider extends ChangeNotifier {
  final MilitaryRankDao _dao;

  List<MilitaryRank> _ranks = [];
  bool _isLoading = false;
  String? _error;

  MilitaryRankProvider(this._dao) {
    load();
  }

  String _search = '';

  List<MilitaryRank> get ranks => _ranks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<MilitaryRank> get filtered {
    if (_search.isEmpty) return _ranks;
    final q = _search.toLowerCase();
    return _ranks.where((r) =>
        r.name.toLowerCase().contains(q) ||
        r.code.toLowerCase().contains(q) ||
        (r.description?.toLowerCase().contains(q) ?? false)).toList();
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
      _ranks = await _dao.getAll();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(String name, String code, String? description, int level) async {
    await _dao.insertOne(MilitaryRanksCompanion(
      code: drift.Value(code),
      name: drift.Value(name),
      description: drift.Value(description),
      level: drift.Value(level),
    ));
    await load();
  }

  Future<void> edit(int id, String name, String code, String? description, int level) async {
    await _dao.updateOne(MilitaryRanksCompanion(
      id: drift.Value(id),
      name: drift.Value(name),
      code: drift.Value(code),
      description: drift.Value(description),
      level: drift.Value(level),
    ));
    await load();
  }

  Future<void> remove(int id) async {
    await _dao.deleteOne(id);
    await load();
  }
}
