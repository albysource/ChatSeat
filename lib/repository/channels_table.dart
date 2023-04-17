import 'package:onionchatflutter/repository/messages_table.dart' as messages_table;

const tableName = 'channels';
const viewName = 'ch_view';

const columns = [
  colName,
  colAvatarFilePath,
  colLastViewedTimeStamp
];

const viewColumns = [
  colName,
  colAvatarFilePath,
  colLastViewedTimeStamp,
  vColLastMessage,
  vColUnreadCount
];

// Column Names
const colName = 'name';
const colAvatarFilePath = 'avatar_file';
const colLastViewedTimeStamp = 'last_viewed_time_millis';

const vColLastMessage = 'last_message';
const vColUnreadCount = 'unread_count';

// Queries
const createQuery = '''
create table if not exists $tableName (
    $colName text not null primary key,
    $colAvatarFilePath text,
    $colLastViewedTimeStamp integer not null
)
''';

// Create a view from tables channels and messages that joins unread messages and last message
const createViewQuery = '''
create view if not exists $viewName as
    select $colName, $colAvatarFilePath, $colLastViewedTimeStamp,
    (select ${messages_table.tableName}.${messages_table.colBody} from ${messages_table.tableName} where ${messages_table.tableName}.${messages_table.colChannelName} = $tableName.$colName order by ${messages_table.tableName}.${messages_table.colTimestamp} desc limit 1) as $vColLastMessage,
    (select count(*) from ${messages_table.tableName} where ${messages_table.tableName}.${messages_table.colChannelName} = $tableName.$colName and ${messages_table.tableName}.${messages_table.colTimestamp} > $tableName.$colLastViewedTimeStamp) as $vColUnreadCount
    from $tableName
''';

/**
 * inner join ${messages_table.tableName} on $tableName.$colName = ${messages_table.tableName}.${messages_table.colChannelName}
    inner join (
    select
    $tableName.$colName as channel,
    count(${messages_table.tableName}.${messages_table.colId}) as unread
    from
    ${messages_table.tableName}
    inner join $tableName on
    $tableName.$colName = ${messages_table.tableName}.${messages_table.colChannelName}
    where
    ${messages_table.tableName}.${messages_table.colTimestamp} > $tableName.$colLastViewedTimeStamp
    group by $tableName.$colName
    ) as unread_counter on $tableName.$colName = unread_counter.channel
*/