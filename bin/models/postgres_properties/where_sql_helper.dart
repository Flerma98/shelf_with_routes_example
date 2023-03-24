enum WhereUnion { and, or }

class WhereSqlHelper {
  final List<String> clauses;
  final List<WhereValuesHelper> clausesValues;
  final WhereUnion whereUnion;

  WhereSqlHelper(this.clauses,
      {required this.clausesValues, this.whereUnion = WhereUnion.and});

  String? getClauses({final bool withText = false}) {
    if (clauses.isEmpty) return null;

    for (var i = 0; i < clauses.length; i++) {
      if (clauses[i].contains("()")) {
        clauses[i] = clauses[i].replaceAll("()", "(NULL)");
      }
    }

    return [if (withText) " WHERE ", clauses.join(" ${whereUnion.name} ")]
        .join(" ");
  }

  Map<String, dynamic> values() {
    final Map<String, dynamic> map = {};
    for (final value in clausesValues) {
      map[value.parameterName] = value.value;
    }
    return map;
  }
}

class WhereValuesHelper {
  final String parameterName;
  final dynamic value;

  WhereValuesHelper({required this.parameterName, required this.value});
}

enum WhereOrder { asc, desc }


class OrderBy {
  final String columnName;
  final WhereOrder order;

  OrderBy(this.columnName, {required this.order});

  String getClauses({final bool withText = false}) {
    return "${(withText) ? "ORDER BY" : ""} $columnName ${order.name}";
  }
}