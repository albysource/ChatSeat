import 'dart:async';

import 'package:onionchatflutter/model/chat_channel.dart';
import 'package:onionchatflutter/repository/channels_table.dart' as channels_table;

import 'package:sqflite/sqflite.dart';

class ChannelRepository {
  final Database database;

  ChannelRepository.fromDatabase(this.database);

  Future<ChatChannel> insert(ChatChannel channel) async {
    await database.insert(channels_table.tableName, channel.toTableMap());
    return channel;
  }

  Future<List<ChatChannel>> fetchChannels(int offset, int limit) async {
    List<Map<String, Object?>> maps = await database.query(
        channels_table.viewName,
        columns: channels_table.viewColumns,
        limit: limit,
        offset: offset,
    );
    if (maps.isNotEmpty) {
      return maps.map((e) => ChatChannel.fromViewMap(e)).toList();
    }
    return [];
  }

  Future<ChatChannel?> getChannel(String name) async {
    List<Map<String, Object?>> maps = await database.query(
        channels_table.viewName,
        columns: channels_table.viewColumns,
        where: '${channels_table.colName} = ?',
        whereArgs: [name]
    );
    if (maps.isNotEmpty) {
      return ChatChannel.fromViewMap(maps.first);
    }
    return null;
  }

  Future<void> delete(String name) async {
    await database.delete(
        channels_table.tableName,
        where: '${channels_table.colName} = ?',
        whereArgs: [name]
    );
  }

  Future<void> update(ChatChannel channel) async {
    final map = channel.toTableMap();
    map.remove(channels_table.colName);
    await database.update(channels_table.tableName, map, where: "${channels_table.colName} = ?", whereArgs: [channel.name]);
  }

  Future close() async => database.close();
}