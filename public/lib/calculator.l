/* lexical grammar */
%{
var reserved_words ={ 
	IF			: 'IF', 
	THEN 		: 'THEN',
	ELSE 		: 'ELSE', 
	WHILE  		: 'WHILE', 
	DO       	: 'DO',  
	BEGIN     	: 'BEGIN',
	END        	: 'END',
	CALL        : 'CALL',
	CONST       : 'CONST',
	VAR        	: 'VAR',
	PROCEDURE  	: 'PROCEDURE',
	ODD        	: 'ODD'
}

function idORrw(x) {
  return (x.toUpperCase() in reserved_words)? x.toUpperCase() : 'ID'
}

%}
%%

/***** CONST *****/

\s+|\#.*                /* skip whitespace and comments */

'=' 					return 'ASSIGN'
[+-] 					return 'ADDMINUS'	// Comentar esto
[*/] 					return 'MULDIV'		// Comentar esto
'(' 					return 'LPAREN'
')' 					return 'RPAREN'
'.' 					return 'DOT'
',' 					return 'COMMA'
';' 					return 'SEMICOLON'
[<>=!][=] 				return 'COMPARISON'
[<>] 					return 'COMPARISON'
\b[A-Za-z_]\w*\b        return idORrw(yytext)
\b[0-9]+\b				return 'NUMBER'
//[-*/+^!%=();]           return yytext;		// Descomentar esto

<<EOF>>                 return 'EOF'
.                       return 'INVALID'


