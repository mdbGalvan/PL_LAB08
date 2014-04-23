var assert = chai.assert;

suite('PRUEBAS PARA COMPROBAR LA ASOCIATIVIDAD A IZQUIERDAS', function() {
	test('a = 1 + 2 * 3 / 4 .', function() {
		var tree = calculator.parse('a = 1 + 2 * 3 / 4 .');
		assert.equal(tree.sta.typ, '=')
		assert.equal(tree.sta.val.typ, '+')
		assert.equal(tree.sta.val.rgt.typ, '*')
		assert.equal(tree.sta.val.rgt.rgt.typ, '/')

		assert.equal(tree.sta.val.lft.val, '1')
		assert.equal(tree.sta.val.rgt.lft.val, '2')
		assert.equal(tree.sta.val.rgt.rgt.lft.val, '3')
		assert.equal(tree.sta.val.rgt.rgt.rgt.val, '4')
	});
});

suite('PRUEBAS PARA COMPROBAR LOS CONSTRUCTORES DEL LENGUAJE', function() {
	test('VAR', function() {
   	 	var tree = calculator.parse('var a, b; a = 1.')
   	 	$('#output').html(JSON.stringify(tree,undefined,2));
		assert.equal(output.innerHTML,'{\n  "typ": "BLOCK",\n  "cte": "NULL",\n  "var": [\n    {\n      "typ": "VAR",\n      "val": "a"\n    },\n    {\n      "typ": "VAR",\n      "val": "b"\n    }\n  ],\n  "prc": "NULL",\n  "sta": {\n    "typ": "=",\n    "id_": "a",\n    "val": {\n      "typ": "NUMBER",\n      "val": "1"\n    }\n  }\n}');
		assert.equal(tree.var[0].typ, 'VAR');
		assert.equal(tree.var[0].val, 'a');
		assert.equal(tree.var[1].typ, 'VAR');
		assert.equal(tree.var[1].val, 'b');
		assert.isString($("#output").val(), 'Output is a string');
    });	
    test('CONST', function() {
   	 	var tree = calculator.parse('const a = 2, b = 3; a = 1.')
   	 	$('#output').html(JSON.stringify(tree,undefined,2));
		assert.equal(output.innerHTML,'{\n  "typ": "BLOCK",\n  "cte": [\n    {\n      "typ": "CONST",\n      "lft": "a",\n      "rgt": "2"\n    },\n    {\n      "typ": "CONST",\n      "lft": "b",\n      "rgt": "3"\n    }\n  ],\n  "var": "NULL",\n  "prc": "NULL",\n  "sta": {\n    "typ": "=",\n    "id_": "a",\n    "val": {\n      "typ": "NUMBER",\n      "val": "1"\n    }\n  }\n}');
		assert.equal(tree.cte[0].typ, 'CONST');
		assert.equal(tree.cte[0].lft, 'a');
		assert.equal(tree.cte[0].rgt, '2');
		assert.equal(tree.cte[1].typ, 'CONST');
		assert.equal(tree.cte[1].lft, 'b');
		assert.equal(tree.cte[1].rgt, '3');
		assert.isString(output.innerHTML);
    });
    test('PROCEDURE y BEGIN', function() {
		var tree = calculator.parse('PROCEDURE square; BEGIN squ= x * x END; BEGIN x = 1; CALL square END.');
		assert.equal(tree.prc.typ, 'PROCEDURE', 'Type is Procedure')
		//assert.isNull(tree.prc.arg, 'Procedure Without argument')
		assert.equal(tree.prc.arg, 'NULL', 'Procedure Without argument')
		assert.equal(tree.prc.blc.sta[0].typ, 'BEGIN', 'Type is Begin')
		assert.equal(tree.sta[0].val[1].typ, 'CALL', 'Type is Call')
		//assert.isNull(tree.sta[0].val[1].arg, 'Call Without argument')
		assert.equal(tree.sta[0].val[1].arg, 'NULL', 'Call Without argument')
	});
	test('IF y IFELSE', function() {
		var if_ = calculator.parse('if (a >= 3) then b = 1.');
		var ifelse = calculator.parse('if b != 3 then b = a else a = b.');
 
		assert.isString(if_.sta.con.lft, 'In the Left of the condition is a string')
		assert.deepEqual(if_.sta.typ, 'IF')

		assert.deepEqual(ifelse.sta.typ, 'IFELSE')
		assert.deepEqual(ifelse.sta.tru.typ, '=', 'Type of statement true is =')
	});
	test('CALL', function() {
		var call_ = calculator.parse('call area (a).');
		var call = calculator.parse('call area .');
 
		assert.equal(call_.sta.typ, 'CALL')
		assert.equal(call_.sta.prc, 'area', 'Name of Procedure that call')
		assert.equal(call_.sta.arg[0].typ, 'ARG')
		assert.equal(call_.sta.arg[0].id_, 'a', 'Argument of call')
	});
	test('WHILE', function() {
		var while_ = calculator.parse('while a > 3 do a = 4.');
 
		assert.equal(while_.sta.con.rgt, '3')
		assert.isString(while_.sta.con.typ, '>', 'Operator of condition')
		assert.deepEqual(while_.sta.typ, 'WHILE')
	});
});

suite('PRUEBAS PARA SITUACIONES DE ERROR', function() {
	test('a = 1 + 2 * 3 / 4 ', function() {
		assert.throws(function() { calculator.parse('a = 1 + 2 * 3 / 4 '); });
	});
	test('var a;. ', function() {
		assert.throws(function() { calculator.parse('var a;. '); });
	});
	test('if a = b then c . ', function() {
		assert.throws(function() { calculator.parse('if a = b then c .'); });
	});
	test('a > b .', function() {
		assert.throws(function() { calculator.parse('a > b .'); });
	});
});

