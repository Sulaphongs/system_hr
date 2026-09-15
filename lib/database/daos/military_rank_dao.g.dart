// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'military_rank_dao.dart';

// ignore_for_file: type=lint
mixin _$MilitaryRankDaoMixin on DatabaseAccessor<AppDatabase> {
  $MilitaryRanksTable get militaryRanks => attachedDatabase.militaryRanks;
  MilitaryRankDaoManager get managers => MilitaryRankDaoManager(this);
}

class MilitaryRankDaoManager {
  final _$MilitaryRankDaoMixin _db;
  MilitaryRankDaoManager(this._db);
  $$MilitaryRanksTableTableManager get militaryRanks =>
      $$MilitaryRanksTableTableManager(_db.attachedDatabase, _db.militaryRanks);
}
