#Análisis de Ámbito en PL0

## Resumen

>Se amplia el *Analizador de [PL0 Grammar](http://en.wikipedia.org/wiki/Recursive_descent_parser)* realizado en la [práctica 7](http://pl-lab07.herokuapp.com/) usando *Jison*. También podría observarse la [práctica 5](http://pl-lab05.herokuapp.com/) y [práctica 6](http://pl-lab06.herokuapp.com/) realizada con *PGE.js*.

>Además, se pidió para la práctica que:

>1. Modifique la [práctica anterior](http://pl-lab07.herokuapp.com/) para que cada nodo del tipo `PROCEDURE` disponga de una tabla de símbolos en la que se almacenan todas las constantes, variables y procedimientos declarados en el mismo.
>2. Existirá ademas una tabla de símbolos asociada con el nodo raíz que representa al programa principal.
>3. Las declaraciones de constantes y variables no crean nodo, sino que se incorporan como información a la tabla de símbolos del procedimiento actual.
>4. Para una entrada de la tabla de símbolos `sym["a"]` se guarda que clase de objeto es: constante, variable, procedimiento, etc.
>5. Si es un procedimiento se guarda el número de argumentos.
>6. Si es una constante se guarda su valor.
>7. Cada uso de un identificador (constante, variable, procedimiento) tiene un atributo `declared_in` que referencia en que nodo se declaró.
>8. Si un identificador es usado y no fué declarado es un error.
>9. Si se trata de una llamada a procedimiento (se ha usado `CALL` y el identificador corresponde a un `PROCEDURE`) se comprobará que el número de argumentos coincide con el número de parámetros declarados en su definición.
>10. Si es un identificador de una constante, es un error que sea usado en la parte izquierda de una asignación (que no sea la de su declaración).
>11. Base de Datos: 

>>* Guarde en una tabla el nombre de usuario que guardó un programa. Provea una ruta para ver los programas de un usuario.
>>* Un programa `belongs_to` un usuario. Un usuario `has_n` programas. Vea la sección [DataMapper Associations](http://datamapper.org/docs/associations.html).

>[12].  Elabore un vídeo de presentación de su práctica usando [Camtasia](http://www.techsmith.com/camtasia.html?gclid=CKq7zbiz9r0CFWjpwgodfhMA8Q) o equivalente (Bájese una versión de prueba). En el vídeo deberá responder a las preguntas siguientes:

>>* ¿Reconoce bien las definiciones de variables declaradas en ámbitos anidados (procedures dentro de procedures)?
>>* ¿Da error si se intenta modificar una constante?
>>* ¿Da error si se intenta usar una variable no declarada?
>>* ¿Da error si se intenta llamar a un procedimiento con número erróneo de argumentos?
>>* ¿Muestra los programas escritos por un usuario?
>>* ¿Se han usado la sección "issues" del repositorio para el desarrollo?
>>* ¿Son suficientes las pruebas realizadas?
>>* No se limite a mostrar que funciona. Intente razonar porqué su código funciona. En definitiva, intente demostrar una buena comprensión del código presentado.

>**Nota**: Use la sección `issues` del repositorio en GitHub para coordinarse así como para llevar un histórico de las incidencias y la forma en la que se resolvieron. Repase el tutorial [Mastering Issues](https://guides.github.com/overviews/issues/).



>>![alt text](http://pl-lab06.herokuapp.com/images/PL0.png "PL/0")

## Motivación

>La aplicación fue propuesta para ser desarrolla en la asignatura **Procesadores de Lenguajes**, del tercer año del **Grado en Ingeniería Informática**. Se corresponde con la 8ª práctica de la asignatura.

##  Funcionamiento

>Puede probar en [Heroku](http://pl-lab08.herokuapp.com/), el funcionamiento del *Análisis de Ámbito en PL/0*.

>... EN PROCESO ...

## Desarrollo

>Los lenguajes y herramientas (frameworks, librerías, etc.) utilizados para el desarrollo del presente proyecto fueron:

>* [Ruby gems](http://rubygems.org/)
* [Sinatra](http://www.sinatrarb.com/configuration.html)
* [Heroku](https://dashboard.heroku.com/apps)
* HTML/CSS/Javascript
* [JQuery](http://jquery.com/)
* [PEG.js](http://pegjs.majda.cz/)
* [DataMapper](http://datamapper.org/docs/)
* [Sass](http://sass-lang.com/) 
* [MathJax](http://docs.mathjax.org/en/latest/start.html)
* [SQLite](https://sqlite.org/)
* [PostgreSQL](http://www.postgresql.org/)
* [Jison](http://zaach.github.io/jison/)
* [Omniauth](http://intridea.github.io/omniauth/)
* [Sinatra-Flash](https://github.com/SFEley/sinatra-flash)
* [bootstrap](http://getbootstrap.com/)

## Tests

>Entorno de pruebas basado en [Mocha](http://visionmedia.github.io/mocha/) y [Chai](http://chaijs.com/guide/installation/). 

>Pueden ejecutarse las pruebas [aquí](http://pl-lab08.herokuapp.com/tests).


## Colaboradores

| Autores | E-mail |
| ---------- | ---------- |
| María D. Batista Galván   | magomenlopark@gmail.com  |


## Licencia

>Léase el archivo LICENSE.txt.