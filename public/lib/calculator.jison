/*  Para que haga de calculadora e imprima el valor se debe comentar lo que se señala
    y descomentar lo que está comentado. Tb hay que hacerlo en calculator.l */

%{
var symbolTables = [{ name: 'GLOBAL', father: null, vars: {} }];
var scope = 0; 
var symbolTable = symbolTables[scope];

function getScope() {
  return scope;
}

function getFormerScope() {
   scope--;
   symbolTable = symbolTables[scope];
}

function makeNewScope(id) {
   scope++;
   symbolTable.vars[id].symbolTable = symbolTables[scope] =  { name: id, father: symbolTable, vars: {} };
   symbolTable = symbolTables[scope];
   return symbolTable;
}

function findSymbol(x) {
  var f;
  var s = scope;
  do {
    f = symbolTables[s].vars[x];
    s--;
  } while (s >= 0 && !f);
  s++;
  return [f, s];
}

%}

%token IF WHILE DO BEGIN END CALL CONST VAR PROCEDURE ODD ASSIGN ADDMINUS MULDIV LPAREN RPAREN DOT COMMA SEMICOLON COMPARISON ID NUMBER EOF

/* operator associations and precedence */

%right ASSIGN
%left ADDMINUS  // Comentar esto
%left MULDIV    // Comentar esto

%right THEN ELSE

%start program

%% /* language grammar */

// ***** PROGRAM
program
  : block DOT EOF
    { 
      $$ = $1;
      return [symbolTables, $$]
    }
  ;

// ***** BLOCK => (const_block)? (var_block)? (proc_block)* statement
block
  : const_block var_block proc_block statement
    { 
      $3 ? p = $3 : p = 'NULL'
                                            
      $$ = {
        typ: 'BLOCK',
        prc: p,
        sta: $4
      }; 
    }
  ;

// ***** CONST_QUESTION BLOCK => (const_block)?
const_block 
  : CONST assignment assigment_star SEMICOLON
    {
      $$ = [$2];
      if ($3 && $3.length > 0)
        $$ = $$.concat($3);
    }
  | /* empty */
  ;

// ***** VAR_BLOCK => (var_block)?
var_block
  : VAR ID id_star SEMICOLON
    {
      //if (symbolTable.vars[$ID]) 
      //  throw new Error("Function "+$ID+" defined twice");
      symbolTable.vars[$ID] = { type:  "VAR", initial_value: '' };
      $$ = [{
        typ: 'VAR',
        val: $2.val
      }];

      if ($3 && $3.length > 0)
        $$ = $$.concat($3);
    }
  | /* empty */
  ;

// ***** PROC_BLOCK => (proc_block)*
proc_block
  : PROCEDURE ID argument SEMICOLON block SEMICOLON proc_block
    {
      //if (symbolTable.vars[$ID]) 
      //  throw new Error("Function "+$ID+" defined twice");
      //symbolTable.vars[$ID] = { type:  "PROCEDURE", initial_value: '' };

      //makeNewScope($ID);

      $3 ? a = $3 : a = 'NULL'
      $$ = {
        typ: 'PROCEDURE',
        nam: $2.val,
        arg: a,
        blc: $5,
        syt: symbolTables
      }; 
    }
  | /* empty */
  ;

// ***** ASSIGNMENT => ID = NUMBER
assignment
  : ID ASSIGN number
    {
      //if (symbolTable.vars[$ID]) 
      //  throw new Error("Function "+$ID+" defined twice");
      symbolTable.vars[$ID] = { type:  "CONST", initial_value: $number };

      $$ = {
        typ: 'CONST',
        lft: $1.val,
        rgt: $3.val
      };
    }
  ;

// ***** ASSIGNMENT => (, assignment)* = (, ID = NUMBER)*
assigment_star
  : COMMA assignment assigment_star
    {
      $$ = [$2];
      if ($3 && $3.length > 0)
        $$ = $$.concat($3);
    }
  | /* empty */
  ;

// ***** ID
/*id: ID
  {
    // what if it is a FUNC or a LOCAL or a GLOBAL? or not defined?
    var info = findSymbol($ID);
    var s = info[1];
    info = info[0];

    if (info && info.type === 'PROCEDURE') {
      throw new Error("Symbol "+$ID+" refers to a function");
    } else if (info) {
      $$ = {
        //typ: 'ID',
        val: yytext,
        declared_in: symbolTables[s].name
      };
    }
    else {
      throw new Error("Symbol "+$ID+" not declared");
    }
  }
  ;*/

// ***** ID_STAR => (, ID)*
id_star
  : COMMA ID id_star
    {
      //if (symbolTable.vars[$ID]) 
      //  throw new Error("Function "+$ID+" defined twice");
      symbolTable.vars[$ID] = { type:  "VAR", initial_value: '' };
      $$ = [{
        typ: 'VAR',
        val: $2.val
      }];

      if ($3 && $3.length > 0)
        $$ = $$.concat($3);
    }
  | /* empty */
  ;

// ***** ARGUMENT => (ID argument_star)?
argument 
  : LPAREN ID argument_star RPAREN
    {
      $$ = [{
        typ: 'ARG',
        id_: $2.val
      }];

      if ($3 && $3.length > 0)
        $$ = $$.concat($3);
    }
  | /* empty */
  ;

// ***** ARGUMENT_STAR => (, ID)*
argument_star
  : COMMA ID argument_star
    {
      $$ = [{
        typ: 'ARG',
        id_: $2.val
      }];

      if ($3 && $3.length > 0)
        $$ = $$.concat($3);
    }
  | /* empty */
  ;

// ***** NUMBER
number: NUMBER
  {
    //$$ = {
    //  typ: 'NUMBER',
    //  val: yytext
    //};
    $$ = $1
  }
  ;

// ***** STATEMENT => ID = expression | CALL ID argument? | BEGIN statement * END | IFELSE | IF | WHILE
statement
  : ID ASSIGN expression
    {
      $$ = {
        typ: '=',
        id_: $1.val,
        val: $3
      };
    }
  | CALL ID argument
    {
      $3 ? a = $3 : a = 'NULL'
      $$ = {
        typ: 'CALL',
        prc: $2.val,
        arg: a
      };
    }
  | BEGIN statement statement_plus END
    {
      s = [$2];
      if ($3 && $3.length > 0)
        s = s.concat($3);
      $$ = [{
        typ: 'BEGIN',
        val: s
      }]; 
    }  
  | IF condition THEN statement ELSE statement
    {
      $$ = {
        typ: 'IFELSE',
        con: $2,
        tru: $4,
        fal: $6
      };
    }
  | IF condition THEN statement
    {
      $$ = {
        typ: 'IF',
        con: $2,
        sta: $4,
      };
    }
  | WHILE condition DO statement
    {
      $$ = {
        typ: 'WHILE',
        con: $2,
        sta: $4
      };
    }
  ; 

// ***** STATEMENT_PLUS => (statement)*
statement_plus
  : SEMICOLON statement statement_plus
    {
      $$ = [$2];
      if ($3 && $3.length > 0)
        $$ = $$.concat($3);
    }
  | /* empty */
  ;

// ***** CONDITION => (condition_) | condition_ // condition_ => OD expr | expr COMP expr
condition
  : condition_
    { $$ = $1 }
  | LPAREN condition_ RPAREN
    { $$ = $2 }
  ;

condition_
  : ODD expression
    {
      $$ = {
        typ: 'ODD',
        val: $2.val
      };
    }
  | expression COMPARISON expression
    {
      $$ = {
        typ: $2,
        lft: $1.val,
        rgt: $3.val
      };
    }
  ;

// Comentar desde aquí
// ***** EXPRESSION => term (ADDMINUS term)*
expression
  : term 
  | term ADDMINUS expression
    {
      $$ = {
        typ: $2,
        lft: $1,
        rgt: $3
      };
    }
  ;

// ***** TERM => factor (MULDIV factor)* 
term
  : factor
  | factor MULDIV term
    {
      $$ = {
        typ: $2,
        lft: $1,
        rgt: $3
      };
    }
  ;

// ***** FACTOR => NUMBER|ID|(expresioo)
factor
  : number
  | ID 
    {
      // what if it is a FUNC or a LOCAL or a GLOBAL? or not defined?
      var info = findSymbol($ID);
      var s = info[1];
      info = info[0];

      if (info && info.type === 'PROCEDURE') {
        throw new Error("Symbol "+$ID+" refers to a function");
      } else if (info) {
        $$ = {
          //typ: 'ID',
          val: yytext,
          declared_in: symbolTables[s].name
        };
      }
      else {
        throw new Error("Symbol "+$ID+" not declared");
      }
    }
  | LPAREN expression RPAREN
    {
      $$ = $2;
    }
  ;

%%