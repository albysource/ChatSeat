import 'dart:async';

import 'package:onionchatflutter/model/chat_message.dart';
import 'package:onionchatflutter/repository/messages_table.dart' as messages_table;

import 'package:sqflite/sqflite.dart';

class MessageRepository {
  final Database database;

  MessageRepository.fromDatabase(this.database);

  Future<Message> insert(Message message) async {
    message.id = await database.insert(messages_table.tableName, message.toMap());
    return message;
  }

  Future<Message?> getMessage(int id) async {
    List<Map<String, Object?>> maps = await database.query(
        messages_table.tableName,
        columns: messages_table.columns,
        where: '${messages_table.colId} = ?',
        whereArgs: [id]
    );
    if (maps.isNotEmpty) {
      return Message.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Message>> getMessagesFromChannel({required String channelId, int? limit, int? offset}) async {
    List<Map<String, Object?>> maps = await database.query(
        messages_table.tableName,
        columns: messages_table.columns,
        where: '${messages_table.colChannelName} = ?',
        whereArgs: [channelId],
        limit: limit,
        offset: offset,
        orderBy: messages_table.colTimestamp + " DESC",
    );
    return maps.map((e) => Message.fromMap(e)).toList().reversed.toList();
  }

  Future<int> delete(int id) async {
    return await database.delete(
        messages_table.tableName,
        where: '${messages_table.colId} = ?',
        whereArgs: [id]
    );
  }

  Future<int> deleteFromChannel(int channelId) async {
    return await database.delete(
        messages_table.tableName,
        where: '${messages_table.colChannelName} = ?',
        whereArgs: [channelId]
    );
  }

  Future<int> update(Message message) async {
    return await database.update(messages_table.tableName, message.toMap());
  }

  Future close() async => database.close();
}