/*  Para que haga de calculadora e imprima el valor se debe comentar lo que se señala
    y descomentar lo que está comentado. Tb hay que hacerlo en calculator.l */

%{
var symbol_table = {};

function fact (n) { 
  return n==0 ? 1 : fact(n-1) * n 
}

%}

%token IF WHILE DO BEGIN END CALL CONST VAR PROCEDURE ODD ASSIGN ADDMINUS MULDIV LPAREN RPAREN DOT COMMA SEMICOLON COMPARISON ID NUMBER EOF

/* operator associations and precedence */

%right ASSIGN
%left ADDMINUS  // Comentar esto
%left MULDIV    // Comentar esto

%right THEN ELSE
/*
%right '='
%left '+' '-'
%left '*' '/'
%left '^'
%right '%'
%left UMINUS
%left '!'
*/
%start program

%% /* language grammar */

// ***** PROGRAM
program
  : block DOT EOF
    { 
      return $1;
    }
  ;

// ***** BLOCK => (const_block)? (var_block)? (proc_block)* statement
block
  : const_block var_block proc_block statement
    { 
      $1 ? c = $1 : c = 'NULL'
      $2 ? v = $2 : v = 'NULL'
      $3 ? p = $3 : p = 'NULL'

      $$ = {
        typ: 'BLOCK',
        cte: c,
        var: v,
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
  : VAR id id_star SEMICOLON
    {
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
  : PROCEDURE id argument SEMICOLON block SEMICOLON proc_block
    {
      $3 ? a = $3 : a = 'NULL'
      $$ = {
        typ: 'PROCEDURE',
        nam: $2.val,
        arg: a,
        blc: $5
      }; 
    }
  | /* empty */
  ;

// ***** ASSIGNMENT => ID = NUMBER
assignment
  : id ASSIGN number
    {
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
id: ID
  {
    $$ = {
      typ: 'ID',
      val: yytext
    };
  }
  ;

// ***** ID_STAR => (, ID)*
id_star
  : COMMA id id_star
    {
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
  : LPAREN id argument_star RPAREN
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
  : COMMA id argument_star
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
    $$ = {
      typ: 'NUMBER',
      val: yytext
    };
  }
  ;

// ***** STATEMENT => ID = expression | CALL ID argument? | BEGIN statement * END | IFELSE | IF | WHILE
statement
  : id ASSIGN expression
    {
      $$ = {
        typ: '=',
        id_: $1.val,
        val: $3
      };
    }
  | CALL id argument
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
  | id 
  | LPAREN expression RPAREN
    {
      $$ = $2;
    }
  ;
  
// Hasta aquí

/*
expression
    : s  
        { $$ = (typeof $1 === 'undefined')? [] : [ $1 ]; }
    | expressions ';' s
        { $$ = $1;
          if ($3) $$.push($3); 
          console.log($$);
        }
    ;

s
    : 
    | e
    ;

e
    : ID '=' e
        { symbol_table[$1] = $$ = $3; }
    | PI '=' e 
        { throw new Error("Can't assign to constant 'π'"); }
    | E '=' e 
        { throw new Error("Can't assign to math constant 'e'"); }
    | e '+' e
        {$$ = $1+$3;}
    | e '-' e
        {$$ = $1-$3;}
    | e '*' e
        {$$ = $1*$3;}
    | e '/' e
        {
          if ($3 == 0) throw new Error("Division by zero, error!");
          $$ = $1/$3;
        }
    | e '^' e
        {$$ = Math.pow($1, $3);}
    | e '!'
        {
          if ($1 % 1 !== 0) 
             throw "Error! Attempt to compute the factorial of "+
                   "a floating point number "+$1;
          $$ = fact($1);
        }
    | e '%'
        {$$ = $1/100;}
    | '-' e %prec UMINUS
        {$$ = -$2;}
    | '(' e ')'
        {$$ = $2;}
    | NUMBER
        {$$ = Number(yytext);}
    | E
        {$$ = Math.E;}
    | PI
        {$$ = Math.PI;}
    | ID 
        { $$ = symbol_table[yytext] || 0; }
    ;
*/

%%