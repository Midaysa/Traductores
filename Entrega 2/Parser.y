# Parser.y
#
# Descripcion: Archivo que contiene la clase Parser, en la cual 
# se define la gramatica del lenguaje BasicTran
#
# Autores :  Ritces Parra   12-11088
#            Palacios Gomez 10-10870

class Parser

	token 'TkId' 'TkNum' 'TkCaracter'

    #Precedencia de los operadores	
	prechigh
    	left ')'
    	right '('
    	left '['
    	left ']'
    	left '::'
        left '$'
    	left '++' '--'
    	left '#'
        left '+' '-'
        left '*' '/' '%' 
        left UMINUS
        left '\/'
        left '/\\'
        left 'not' 
        nonassoc '=' '/=' '>=' '<=' '>' '<'
	preclow
	
	convert
	    'with'      'With'
		'begin'		'Begin'
		'end' 		'End'
		'array'	    'TkArray'
		'var'       'Var'
		'of'        'Of'
		'int'		'Int'
		'bool'		'Bool'
		'char'      'Char'
		'if'        'If'
		'otherwise' 'Otherwise'
		'while'     'While'
		'for'       'For'
        'from'      'From'
        'to'        'To'
		'step'      'Step'
		'read'      'Read'
		'print'     'Print'
        '#'         'ValorAscii'    
        'not'       'Negacion'
        ','         'Coma' 
        '.'         'Punto'
        ';'         'PuntoYComa'
        '++'        'SiguienteCar'
        '::'        'Concatenacion'
        '--'        'AnteriorCar'    
        ':'         'DosPuntos'
        '('         'ParAbre'
        ')'         'ParCierra'
        '['         'CorcheteAbre'
        ']'         'CorcheteCierre'
        '->'        'Hacer'
        '<-'        'Asignacion' 
        '+'         'Suma' 
        '-'         'Resta' 
        '*'         'Mult' 
        '/='        'Desigualdad' 
        '/\\'       'Conjuncion' 
        '/'         'Div' 
        '%'         'Mod'
        '\/'        'Disyuncion'
        '<='        'MenorIgual'
        '<'         'Menor'   
        '>='        'MayorIgual'
        '>'         'Mayor'
        '='         'Igual'
        '$'         'Shift'
        'true'      'True'
        'false'     'False'
        'tkid'       'TkId'   
        'tknum'      'TkNum' 
        'tkcaracter' 'TkCaracter'
    end
    

	start S

	rule
		S 	
			: Bloque                {result = S.new(val[0])}
			;

		Bloque
			: 'with' ListaDeclaraciones 'begin' Instrucciones 'end'		{result = Bloque.new(val[1], val[3])} 
			| 'begin' Instrucciones 'end'								{result = Bloque.new(nil, val[1])}
			;

		ListaDeclaraciones
			: Declaracion 												{result = DeclaracionesList.new(val[0], nil)}	
			| Declaracion   ListaDeclaraciones					 	{result = DeclaracionesList.new(val[0], val[2])}
			;
			

		Declaracion   
			: 'var' ListaId ':' Tipo						            {result = Declaracion.new(val[1], val[3]) }
			;
			
		Tipo
			: 'int'									{result = TipoInt.new(val[0])}
			| 'bool'								{result = TipoBool.new(val[0])}
			| 'char'								{result = TipoChar.new(val[0])}
			| 'array' '[' Expresion ']' 'of' Tipo 	{result = TipoArray.new(val[2], val[5])}
			;
		
		ListaId
			: Id ',' ListaId			            {result = ListaIdentificadores.new(val[0], nil , val[2])  }
			| Id '<-' Expresion ',' ListaId	        {result = ListaIdentificadores.new(val[0], val[2], val[4])}
			| Id 								    {result = ListaIdentificadores.new(val[0], nil, nil)}
			| Id '<-' Expresion 			    	{result = ListaIdentificadores.new(val[0], val[2], nil)}
			;

		Asignacion
 			: Id '<-' Expresion						{result = AsignacionA.new(val[0], val[2] )}
			| Id  ListaCorchetes  '=' Expresion		{result = AsignacionB.new(val[0], val[2], val[5])}
			;
		 
		 ListaCorchetes
			: '[' Expresion ']'  					{result = Corchetes.new(val[1],nil  )}
			| '[' Expresion ']' ListaCorchetes      {result = Corchetes.new(val[1], val[3])}
			
			;
			
		Instrucciones
			: Instruccion				    		{result = ListaIns.new(val[0], nil)}
			| Instruccion Instrucciones		    	{result = ListaIns.new(val[0], val[1]) }
			;

		Instruccion
			: Asignacion ';'						    {result = Instruccion.new(val[0])}
			| Bloque			    					{result = Instruccion.new(val[0])}
			| Condicional			    				{result = Instruccion.new(val[0])}
			| IteracionInd				    			{result = Instruccion.new(val[0])}
			| IteracionDet					    		{result = Instruccion.new(val[0])}
			| Entrada ';'								{result = Instruccion.new(val[0])}
			| Salida ';'								{result = Instruccion.new(val[0])}
			 
			;

		Condicional
			: 'if' Expresion '->' Instrucciones 'end'									{result = Condicional.new(val[1], val[3])}
			| 'if' Expresion '->' Instrucciones 'otherwise' '->' Instrucciones 'end' 		{result = CondicionalOth.new(val[1], val[3], val[6])}
			;

		IteracionInd
			: 'while' Expresion '->' Instrucciones 'end'		{result = IteracionInd.new(val[1], val[3])}
			;

		IteracionDet
			: 'for' Id 'from' Expresion 'to' Expresion '->' Instrucciones 'end'							{result = IteracionDet.new(val[1], val[3], val[5], val[7], nil)}
			| 'for' Id 'from' Expresion 'to' Expresion 'step' Expresion '->' Instrucciones 'end'		{result = IteracionDet.new(val[1], val[3], val[5], val[9], val[7])}
			;

		Entrada
			: 'read' Id 						{result = Entrada.new(val[1])}
			; 
		Salida
			: 'print' Expresion					{result = Salida.new(val[1])}
			;
 
		Expresion

			: Literal							{result = val[0]}
			| '-' Expresion = UMINUS 			{result = Negativo.new(val[1])}
			| '(' Expresion ')'                 {result = val[1]}
			| Expresion'.' Expresion		    	{result = PuntoParser.new(val[0], val[2])}                   	             
			| Expresion'+' Expresion		    	{result = Sumar.new(val[0], val[2])}
			| Expresion'-' Expresion		    	{result = Restar.new(val[0], val[2])}
			| Expresion '*' Expresion		    	{result = Multiplicacion.new(val[0], val[2])}
			| Expresion '/' Expresion		    	{result = Division.new(val[0], val[2])}
			| Expresion '%' Expresion		    	{result = Modulo.new(val[0], val[2])}
			| Expresion'\/' Expresion			{result = Or.new(val[0], val[2])}
			| Expresion'/\\' Expresion			{result = And.new(val[0], val[2])}
			| 'not' Expresion					{result = Not.new(val[1])}
			| Expresion '++'						{result = CaracterSiguiente.new(val[0])}
			| Expresion '--'				    	{result = CaracterAnterior.new(val[0])}
			| '#' Expresion					   	{result = ValorAsciiParser.new(val[1])}
			| Expresion'::' Expresion			{result = Concatenar.new(val[0], val[2])}
			| '$' Expresion						{result = ShiftParser.new(val[1])}
			| Expresion'[' Expresion ']'		    	{result = Indexacion.new(val[0], val[2])}
			| Expresion'<' Expresion			    {result = MenorQue.new(val[0], val[2])}
			| Expresion '<=' Expresion			{result = MenorIgualQue.new(val[0], val[2])}
			| Expresion'>' Expresion	    		{result = MayorQue.new(val[0], val[2])}
			| Expresion'>=' Expresion			{result = MayorIgualQue.new(val[0], val[2])}
			| Expresion '=' Expresion		    	{result = Igualdad.new(val[0], val[2])}
			| Expresion'/=' Expresion			{result = Desigual.new(val[0], val[2])}
			| Asignacion						{result = val[0]}
			;

		Literal
			: Id                                {result = val[0]}
			| 'tknum'							{result = LitNum.new(val[0])}
			| 'tkcaracter'						{result = LitChar.new(val[0])}
			| 'true'							{result = LitTrue.new("true")}
			| 'false'							{result = LitFalse.new("false")}
			;

		Id
			: 'tkid' 							{result = Identificador.new(val[0])}
			;


---- header ----
require_relative 'astParser.rb'
require_relative 'Lexer.rb'
 

---- inner ----
    
    def initialize(lexer)
        @lexer = lexer
    end

    def on_error(id, token, stack)
    	@TokenClass = Object::const_get("#{CaracterInesperado}") #Se crea un nueva instacia de error
        error = @TokenClass.new(token.valor, token.linea, token.columna)
      	puts error
      	return
    end
    
    def next_token
        if @lexer.tiene_token then
            token = @lexer.siguiente_token;
            return [token.class, token]
        else
            return nil
        end
    end

    def parse
        do_parse
    end
