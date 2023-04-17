import './channels_table.dart' as channels_table;

const tableName = 'messages';
//const viewName = 'msg_view';
// Column Names
const colId = 'id';
const colType = 'type';
const colFrom = 'from_id';
const colChannelName = 'channel_fk';
const colLocalPath = 'local_path';
const colTimestamp = 'time_millis';
const colBody = 'body';
const colUrl = 'url';
const colFileName = 'file_name';
const colFileSize = 'file_size';

const vColChannelName = 'channel_name';

const columns = [
    colId,
    colType,
    colFrom,
    colChannelName,
    colTimestamp,
    colBody,
    colUrl,
    colFileName,
    colFileSize,
    colLocalPath,
];

/*const viewColumns = [
    colId,
    colType,
    colFrom,
    vColChannelName,
    colTimestamp,
    colBody,
    colUrl,
    colFileName,
    colFileSize,
    colLocalPath,
];*/

// Queries
const createQuery = '''
create table if not exists $tableName (
    $colId integer primary key autoincrement,
    $colType smallint not null,
    $colFrom text not null,
    $colChannelName text not null references ${channels_table.tableName}(${channels_table.colName}),
    $colTimestamp integer not null,
    $colBody text,
    $colUrl text,
    $colFileName text,
    $colFileSize integer,
    $colLocalPath text
)
''';
//     check (($colType = 0 and $colBody is not null) or ($colUrl is not null and $colFileName is not null, $colFileSize is not null))
/*
const createViewQuery = '''
create view if not exists $viewName
as
select
    $colId,
    $colType,
    $colFrom,
    $colTimestamp,
    $colBody,
    $colUrl,
    $colFileName,
    $colFileSize,
    $colLocalPath,
    ch.name as $vColChannelName
from
    $tableName
inner join (
    select
       ${channels_table.tableName}.${channels_table.colId} as id,
       ${channels_table.tableName}.${channels_table.colName} as name
    from
        ${channels_table.tableName}
    group by $tableName.$colId
) as ch on $tableName.$colChannelId = ch.id
order by $colTimestamp desc;
''';
*/
