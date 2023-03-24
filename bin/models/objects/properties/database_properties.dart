import '../../postgres_properties/where_sql_helper.dart';

abstract class DatabaseProperties {
  static String makeQuery(final String table,
      {final WhereSqlHelper? where,
      final OrderBy? orderBy,
      final String? groupBy,
      final String? having,
      final int? limit,
      final int? offset}) {
    final List<String> whereContent = [];
    if (where?.clauses.isNotEmpty == true) {
      whereContent.addAll(where!.clauses);
    }

    final query = """
    SELECT * FROM $table
    ${(where?.clauses.isNotEmpty == true) ? where!.getClauses(withText: true) : ""}
    ${(orderBy != null) ? "ORDER BY ${orderBy.columnName} ${orderBy.order.name}" : ""}
    ${(groupBy != null) ? "GROUP BY $groupBy" : ""}
    ${(having != null) ? "HAVING $having" : ""}
    ${(limit != null) ? "LIMIT $limit" : ""}
    ${(offset != null) ? "OFFSET $offset" : ""}
    """
        .trim();
    return query;
  }
}
