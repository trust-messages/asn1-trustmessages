grammar Query;

stat:   FIELD OP VALUE  # constraint
    |   '(' stat ')'    # parenthesis
    |   stat 'AND' stat # conjunction
    |   stat 'OR' stat  # disjunction
    ;

FIELD:  'source' | 'target' | 'service' | 'date' ;
OP:     '!=' | '<=' | '>=' | '<' | '>' | '=' ;
VALUE:  [a-zA-Z0-9@\\.]+ ; // not sure if completely ok..
WS:     [ \t\r\n]+ -> skip ;
