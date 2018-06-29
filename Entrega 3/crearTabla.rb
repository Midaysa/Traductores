require_relative 'tablaSimbolos'  

#Variables globales
$tablaInicial = TablaSimbolos.new
$tablaErrores = Array.new

class CrearTabla
    
    #Funcion para crear las tablas y verificar si hay errores
    def crear(ast)
        @ast = ast
        verificarBloque(@ast.bloque, $tablaInicial)

        if ($tablaErrores.length > 0)
            return $tablaErrores
        else
            return $tablaInicial
        end
    end
   

    #Funcion que se encarga de verificar el codigo dentro de un blque y de la 
    #creacion de las tablas correspondientes al mismo
    def verificarBloque(bloque, tablaActual)
        nuevaTabla = TablaSimbolos.new
        nuevaTabla.asignarPadre(tablaActual)
        tablaActual.asignarHijo(nuevaTabla)
       
        verificarDeclaraciones(bloque.declaraciones, nuevaTabla) 
        verificarInstrucciones(bloque.instrucciones, nuevaTabla)
    end



    #Funcion que se encarga de analizar el tipo de declaracion realizada
    #y la envia a la funcion que se encarga de su verificacion
    def verificarDeclaraciones(declaraciones, tablaActual)

        if declaraciones.nil? == false
            declaraciones.each do |i|
                verificarDeclaracion(i.identificador, i.tipo, tablaActual)
            end
        end 
    end


    #Funcion que se encarga de analizar el tipo de declaracion realizada
    #y la envia a la funcion que se encarga de su verificacion
    def verificarDeclaracion(declaracion, tipo, tablaActual)
        case declaracion
     
        when Identificador
            verificarDeclaracionIdentificador(declaracion, tipo, tablaActual)

        when AsignacionA
            verificarDeclaracionAsignacionA(declaracion.id, tipo, tablaActual)
            
        when ListaIdentificadores
            verificarDeclaracionIdentificador(declaracion.id, tipo, tablaActual)
            verificarDeclaracion(declaracion.lista, tipo, tablaActual)            
            
        when ListaAsignaciones
            verificarDeclaracionAsignacionA(declaracion.id.id, tipo, tablaActual) 
            verificarDeclaracion(declaracion.lista, tipo, tablaActual)
        
        end
    end


    #Funcion que se encarga de insertar en la tabla los datos de la
    #declaracion del identificador
    def verificarDeclaracionIdentificador(identificador, tipo, tablaActual)
        case tipo

        when TipoInt
            begin
                asigno = tablaActual.insertar(identificador.token.valor, "int")
                token = identificador.token
            end

        when TipoBool
            begin
                asigno = tablaActual.insertar(identificador.token.valor, "bool")
                token = identificador.token            
            end

        when TipoChar
            begin
                asigno = tablaActual.insertar(identificador.token.valor, "char")
                token = identificador.token
            end

        when TipoArray
            begin
                asigno = tablaActual.insertar(identificador.token.valor, "array")
                token = identificador.token
            end
            
        when Tipo
        end

        #Si los datos no se pudieron incluir en la tabla se empila en la tabla de errores  un mensaje con el error
        if !asigno then
            error = "Error en linea #{token.linea}, columna #{token.columna}: La variable '#{token.valor}' ya ha sido declarada en este alcance"
            $tablaErrores << error
        end
    end


    #Funcion que se encarga de insertar en la tabla los datos de la 
    #declaracion de la asignacion
    def verificarDeclaracionAsignacionA(declaracion, tipo, tablaActual)
        case tipo

        when TipoInt
            begin
                asigno = tablaActual.insertar(declaracion.token.valor, "int")
                token = declaracion.token
            end

        when TipoBool
            begin
                asigno = tablaActual.insertar(declaracion.token.valor, "bool")
                token = declaracion.token            
            end

        when TipoChar
            begin
                asigno = tablaActual.insertar(declaracion.token.valor, "char")
                token = declaracion.token
            end

        when TipoArray
            begin
                asigno = tablaActual.insertar(declaracion.token.valor, "array")
                token = declaracion.token
            end
        end    

        #Si los datos no se pudieron incluir en la tabla se empila en la tabla de errores  un mensaje con el error
        if !asigno then
            error = "Error en linea #{token.linea}, columna #{token.columna}: La variable '#{token.valor}' ya ha sido declarada en este alcance"
            $tablaErrores << error
        end
    end




    #Funcion que se encarga de analizar el tipo de declaracion realizada
    #y la envia a la funcion que se encarga de su verificacion
    def verificarInstrucciones(instrucciones, tablaActual)

        if instrucciones.nil? == false
            instrucciones.each do |i|
                verificarInstruccion(i, tablaActual)
            end
        else 
            verificarInstruccion(instrucciones.instruccion, tablaActual)
        end 
    end


    #Funcion que se encarga de analizar una instruccion y la envia a la
    #funcion que se encarga de su verificacion
    def verificarInstruccion(instruccion, tablaActual)
        
        puts "VERIFICAR INSTRUCCION"
        puts instruccion
        
        case instruccion

        when AsignacionA
            verificarInstruccionasignacionA(instruccion, tablaActual)

        when Bloque
            verificarBloque(instruccion, tablaActual)

        when Condicional
            verificarInstruccionCondicional(instruccion, tablaActual)

        when CondicionalOth
            verificarInstruccionCondicionalOthe(instruccion, tablaActual)

        when IteracionInd
            verificarInstruccionIteracionInd(instruccion, tablaActual)

        when IteracionDet
            verificarInstruccionIteracionDet(instruccion, tablaActual)

        when Entrada
            verificarInstruccionEntrada(instruccion, tablaActual)

        when Salida
            verificarInstruccionSalida(instruccion, tablaActual)
        end
    end


    #Funcion que se encarga de verificar la instruccion del tipo AsignacionA
    def verificarInstruccionasignacionA(instruccion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera variable con el nombre de identificador
        tablaAux = tablaActual
        identificador = verificarIdentificador(instruccion.id, tablaAux)
        

        while (!identificador and !tablaAux.nil?)
            identificador = verificarIdentificador(instruccion.id, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end

        tablaVerificacion = tablaAux

        #Si no se encuentra la variable identificador en ningun alcance se empila en la tabla de errores un mensaje con el error
        if !identificador then
            error = "Error en linea #{instruccion.id.token.linea}, columna #{instruccion.id.token.columna}: No se encontro la variable '#{identificador.id.token.valor}' en ningun alcance"
            $tablaErrores << error
        end        
 
        #Se busca en los alcances hasta encontrar la primera expresion valida
        tablaAux = tablaActual
        expresion = verificarExpresion(instruccion.expresion, tablaAux)

        while (!expresion and !tablaAux.nil?)
            expresion = verificarExpresion(instruccion.expresion, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
         
        if !tablaVerificacion.nil? then
            if tablaVerificacion.for then
                error = "Error en la linea #{instruccion.id.token.linea}, columna #{instruccion.id.token.columna}: no se puede modificar una variable de iteracion"
                $tablaErrores << error
            end
        end

        #Si ambos lados de la asignacion no son del mismo tipo, se empila en la tabla de errores un mensaje con el error
        if (not identificador.eql? expresion) then
            error = "Error en la linea #{instruccion.id.token.linea}, columna #{instruccion.id.token.columna}: el tipo de la expresion es distinta al del identificador"
            $tablaErrores << error
        end
    end


    #Funcion que se encarga de verificar si un identificador esta en la tabla actual
    def verificarIdentificador(identificador, tablaActual)
        
        #puts "VERIFICAR IDENTIFICADOR"
        nombre = identificador.token.valor
        return tablaActual.buscar(nombre)
    end


    #Funcion que se encarga de verificar la instruccion condicional
    def verificarInstruccionCondicional(instruccion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida
        tablaAux = tablaActual
        guardia = verificarExpresion(instruccion.guardia, tablaAux)

        while (!guardia and !tablaAux.nil?)
            guardia = verificarExpresion(instruccion.guardia, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end

        #Verifica si la guardia es de tipo booleano
        if (not guardia.eql? "bool") then
            tokenAux = instruccion.guardia

            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end

            error = "Error en la linea #{tokenAux.token.linea}: La guardia del if no es de tipo booleano"
            $tablaErrores << error
        end

        verificarInstruccion(instrucciones.instruccion, tablaActual)     
    end


    #Funcion que se encarga de verificar la instruccion condicionalOth
    def verificarInstruccionCondicionalOthe(instruccion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida
        tablaAux = tablaActual
        guardia = verificarExpresion(instruccion.guardia, tablaAux)

        while (!guardia and !tablaAux.nil?)
            guardia = verificarExpresion(instruccion.guardia, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end

        #Verifica si la guardia es de tipo booleano
        if (not guardia.eql? "bool") then
            tokenAux = instruccion.guardia

            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end

            error = "Error en la linea #{tokenAux.token.linea}: La guardia del IF no es de tipo booleano"
            $tablaErrores << error
        end

        verificarInstruccion(instrucciones.instruccion1, tablaActual)
        verificarInstruccion(instrucciones.instruccion2, tablaActual)
    end




    def verificarInstruccionIteracionInd(instruccion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida
        tablaAux = tablaActual
        guardia = verificarExpresion(instruccion.expresion, tablaAux)

        #puts "VEMOS LA GUARDIA  "
        #puts guardia
        #puts tablaAux.nil?
        
        #system.out


        while (!guardia and !tablaAux.nil?)
            guardia = verificarExpresion(instruccion.expresion, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end

        #Verifica si la guardia es de tipo booleano
        if (not guardia.eql? "bool") then
            tokenAux = instruccion.expresion

            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end

            error = "Error en la linea #{tokenAux.token.linea}: La guardia del IF no es de tipo booleano"
            $tablaErrores << error
        end

        verificarInstruccion(instruccion, tablaActual)
    end





    #Funcion que se encarga de verificar la instruccion del tipo IteracionDet
    def verificarIteracionDet(instruccion, tablaPadre)
        #Se crea la tabla para el manejo del for
        tablaActual = TablaSimbolos.new
        tablaActual.asignarPadre(tablaPadre)
        tablaPadre.asignarHijo(tablaActual)
        tablaActual.for = true

        #Se inserta la variable de iteracion en la tabla de simbolos actual
        tablaActual.insertar(instruccion.identificador.token.valor, "tkid")
        verificarExpresion(instruccion.limInf)
        verificarExpresion(instruccion.limSup)
        verificarInstruccion(instruccion.instruccion, tablaActual)
    end


    #Funcion que se encarga de verificar la instruccion del tipo IteracionDetStep
    def verificarIteracionDetStep(instruccion, tablaPadre)
        #Se crea la tabla para el manejo del for
        tablaActual = TablaSimbolos.new
        tablaActual.asignarPadre(tablaPadre)
        tablaPadre.asignarHijo(tablaActual)
        tablaActual.for = true

        #Se inserta la variable de iteracion en la tabla de simbolos actual
        tablaActual.insertar(instruccion.identificador.token.valor, "tkid")
        verificarExpresion(instruccion.limInf)
        verificarExpresion(instruccion.limSup)
        verificarExpresion(instruccion.iterador)
        verificarInstruccion(instruccion.instruccion, tablaActual)
    end


    #Funcion que se encarga de verificar la instruccion de tipo Salida
    def verificarInstruccionSalida(expresion, tablaActual)
        tablaAux = tablaActual
        exp = verificarExpresion(expresion.expresion, tablaAux)
        
        #puts "EXPRESION Y TABLA AUX"
        #puts exp
        #puts tablaAux.nil?
        
        
        
        while (!exp and !tablaAux.nil?)
            exp = verificarExpresion(expresion.expresion, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end

        if !exp
            tokenAux = expresion

            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end                
            error = "Error en línea #{tokenAux.token.linea}: el tipo de la expresion '#{tokenAux.token.valor}' no esta en el alcance."
            $tablaErrores << error            
        end 
    end


    #Funcion que se encarga de verificar la instruccion de tipo Entrada
    def verificarInstruccionEntrada(identificador, tablaActual)

        tablaAux = tablaActual
        id = verificarExpresion(identificador.expresion, tablaAux)

        if tablaActual.buscar(identificador) == false
            error = "Error en línea #{identificador.expresion.token.linea}: el tipo de la expresion '#{identificador.expresion.token.valor}' no esta en el alcance."
            $tablaErrores << error            
            puts "error"
        end 
    end 


    #Funcion que se encarga de analizar el tipo de expresion a evaluar
    #y la envia a la funcion que se encarga de su verificacion
    def verificarExpresion(expresion, tablaActual)
        #puts expresion.token.valor
        
        #puts "VERIFICAMOS LA EXPRESION"
        #puts expresion.class.name
        #puts expresion.token.valor
        
        case expresion

        when PuntoParser
            return verificarPuntoParser(expresion, tablaActual)

        when Sumar
            return verificarSumar(expresion, tablaActual)

        when Restar
            return verificarRestar(expresion, tablaActual)

        when Multiplicacion
            return verificarMultiplicacion(expresion, tablaActual)

        when Division
            return verificarDivision(expresion, tablaActual)

        when Modulo
            return verificarModulo(expresion, tablaActual)

        when Or
            return verificarOr(expresion, tablaActual)

        when And
            return verificarAnd(expresion, tablaActual)

        when Concatenar
            return verificarConcatenar(expresion, tablaActual)

        when Indexacion
            return verificarIndexacion(expresion, tablaActual)

        when MenorQue
            return verificarMenorQue(expresion, tablaActual)

        when MenorIgualQue
            return verificarMenorIgualQue(expresion, tablaActual)
            
        when MayorQue
            return verificarMayorQue(expresion, tablaActual)
            
        when MayorIgualQue
            return verificarMayorIgualQue(expresion, tablaActual)

        when Igualdad
            return verificarIgualdad(expresion, tablaActual)

        when Desigual
            return verificarDesigual(expresion, tablaActual)

        when Negativo
            return verificarNegativo(expresion, tablaActual)

        when Not
            return verificarNot(expresion, tablaActual)

        when CaracterSiguiente
            return verificarCaracterSiguiente(expresion, tablaActual)

        when CaracterAnterior
            return verificarCaracterAnterior(expresion, tablaActual)

        when ValorAsciiParser
            return verificarValorAsciiParser(expresion, tablaActual)

        when ShiftParser
            return verificarShiftParser(expresion, tablaActual)

        when AsignacionA
            return verificarAsignacionA(expresion, tablaActual)

        when AsignacionB
            return verificarAsignacionB(expresion, tablaActual)
            
        when Identificador
            return "tkid" 
        
        when LitNum
            return "tknum"

        when LitChar
            return 'tkcaracter'

        when LitTrue
            return 'true'

        when LitFalse
            return 'false'
        end
    end


    #Funcion que se encarga de verificar las operaciones PuntoParser 
    def verificarPuntoParser(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        izquierda = verificarExpresion(expresion.izquierda, tablaAux)
        
        while (!izquierda and !tablaAux.nil?)
            izquierda = verificarExpresion(expresion.izquierda, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se busca en los alcances hasta encontrar la primera expresion valida a derecha
        tablaAux = tablaActual
        derecha = verificarExpresion(expresion.derecha, tablaAux)
        
        while (!derecha and !tablaAux.nil?)
            derecha = verificarExpresion(expresion.derecha, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end        
        
        #Se verifica si ambas variables son de tipo int
        if (izquierda.eql? "int" and derecha.eql? "int") then
            return "int"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            
            error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion PUNTO son diferentes"
            $tablaErrores << error
        end
    end


    #Funcion que se encarga de verificar la operacion Sumar 
    def verificarSumar(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        izquierda = verificarExpresion(expresion.izquierda, tablaAux)
        
        while (!izquierda and !tablaAux.nil?)
            izquierda = verificarExpresion(expresion.izquierda, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se busca en los alcances hasta encontrar la primera expresion valida a derecha
        tablaAux = tablaActual
        derecha = verificarExpresion(expresion.derecha, tablaAux)
        
        while (!derecha and !tablaAux.nil?)
            derecha = verificarExpresion(expresion.derecha, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end        
        
        #Se verifica si ambas variables son de tipo int
        if (izquierda.eql? "int" and derecha.eql? "int") then
            return "int"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            
            error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion SUMAR son diferentes"
            $tablaErrores << error
        end
    end
    
    
    #Funcion que se encarga de verificar la operacion Restar 
    def verificarRestar(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        izquierda = verificarExpresion(expresion.izquierda, tablaAux)
        
        while (!izquierda and !tablaAux.nil?)
            izquierda = verificarExpresion(expresion.izquierda, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se busca en los alcances hasta encontrar la primera expresion valida a derecha
        tablaAux = tablaActual
        derecha = verificarExpresion(expresion.derecha, tablaAux)
        
        while (!derecha and !tablaAux.nil?)
            derecha = verificarExpresion(expresion.derecha, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end        
        
        #Se verifica si ambas variables son de tipo int
        if (izquierda.eql? "int" and derecha.eql? "int") then
            return "int"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            
            error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion RESTAR son diferentes"
            $tablaErrores << error
        end
    end
    
    
    #Funcion que se encarga de verificar la operacion Multiplicacion 
    def verificarMultiplicacion(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        izquierda = verificarExpresion(expresion.izquierda, tablaAux)
        
        while (!izquierda and !tablaAux.nil?)
            izquierda = verificarExpresion(expresion.izquierda, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se busca en los alcances hasta encontrar la primera expresion valida a derecha
        tablaAux = tablaActual
        derecha = verificarExpresion(expresion.derecha, tablaAux)
        
        while (!derecha and !tablaAux.nil?)
            derecha = verificarExpresion(expresion.derecha, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end        
        
        #Se verifica si ambas variables son de tipo int
        if (izquierda.eql? "int" and derecha.eql? "int") then
            return "int"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            
            error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion MULTIPLICACION son diferentes"
            $tablaErrores << error
        end
    end   
    

    #Funcion que se encarga de verificar la operacion Division 
    def verificarDivision(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        izquierda = verificarExpresion(expresion.izquierda, tablaAux)
        
        while (!izquierda and !tablaAux.nil?)
            izquierda = verificarExpresion(expresion.izquierda, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se busca en los alcances hasta encontrar la primera expresion valida a derecha
        tablaAux = tablaActual
        derecha = verificarExpresion(expresion.derecha, tablaAux)
        
        while (!derecha and !tablaAux.nil?)
            derecha = verificarExpresion(expresion.derecha, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end        
        
        #Se verifica si ambas variables son de tipo int
        if (izquierda.eql? "int" and derecha.eql? "int") then
            return "int"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            
            error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion DIVISION son diferentes"
            $tablaErrores << error
        end
    end


    #Funcion que se encarga de verificar la operacion Modulo 
    def verificarModulo(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        izquierda = verificarExpresion(expresion.izquierda, tablaAux)
        
        while (!izquierda and !tablaAux.nil?)
            izquierda = verificarExpresion(expresion.izquierda, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se busca en los alcances hasta encontrar la primera expresion valida a derecha
        tablaAux = tablaActual
        derecha = verificarExpresion(expresion.derecha, tablaAux)
        
        while (!derecha and !tablaAux.nil?)
            derecha = verificarExpresion(expresion.derecha, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end        
        
        #Se verifica si ambas variables son de tipo int
        if (izquierda.eql? "int" and derecha.eql? "int") then
            return "int"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            
            error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion MODULO son diferentes"
            $tablaErrores << error
        end
    end 
    
    
    #Funcion que se encarga de verificar la operacion Or (Disyuncion)
    def verificarOr(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        izquierda = verificarExpresion(expresion.izquierda, tablaAux)
        
        while (!izquierda and !tablaAux.nil?)
            izquierda = verificarExpresion(expresion.izquierda, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se busca en los alcances hasta encontrar la primera expresion valida a derecha
        tablaAux = tablaActual
        derecha = verificarExpresion(expresion.derecha, tablaAux)
        
        while (!derecha and !tablaAux.nil?)
            derecha = verificarExpresion(expresion.derecha, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end        
        
        #Se verifica si ambas variables son de tipo int
        if (izquierda.eql? "bool" and derecha.eql? "bool") then
            return "bool"
        else 
            if !(izquierda.eql? "bool") then 
                tokenAux = expresion.izquierda
                
                while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                    tokenAux = tokenAux.izquierda
                end
                error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion DISYUNCION son diferentes"
                $tablaErrores << error
            else 
                tokenAux = expresion.derecha
                
                while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                    tokenAux = tokenAux.izquierda
                end
                error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion DISYUNCION son diferentes"
                $tablaErrores << error
            end
        end
    end
    
    
    #Funcion que se encarga de verificar la operacion And (Conjuncion)
    def verificarAnd(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        izquierda = verificarExpresion(expresion.izquierda, tablaAux)
        
        while (!izquierda and !tablaAux.nil?)
            izquierda = verificarExpresion(expresion.izquierda, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se busca en los alcances hasta encontrar la primera expresion valida a derecha
        tablaAux = tablaActual
        derecha = verificarExpresion(expresion.derecha, tablaAux)
        
        while (!derecha and !tablaAux.nil?)
            derecha = verificarExpresion(expresion.derecha, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end        
        
        #Se verifica si ambas variables son de tipo int
        if (izquierda.eql? "bool" and derecha.eql? "bool") then
            return "bool"
        else 
            if !(izquierda.eql? "bool") then 
                tokenAux = expresion.izquierda
                
                while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                    tokenAux = tokenAux.izquierda
                end
                error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion CONJUNCION son diferentes"
                $tablaErrores << error
            else 
                tokenAux = expresion.derecha
                
                while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                    tokenAux = tokenAux.izquierda
                end
                error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion CONJUNCION son diferentes"
                $tablaErrores << error
            end
        end
    end 
    
    
    
    #
    #
    #       En este caso considero que se debe hacer un tipo 'array'
    #                para los tipos de datos de declaracion
    #
    #
    #Funcion que se encarga de verificar la operacion Concatenar
    def verificarConcatenar(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        izquierda = verificarExpresion(expresion.izquierda, tablaAux)
        
        while (!izquierda and !tablaAux.nil?)
            izquierda = verificarExpresion(expresion.izquierda, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se busca en los alcances hasta encontrar la primera expresion valida a derecha
        tablaAux = tablaActual
        derecha = verificarExpresion(expresion.derecha, tablaAux)
        
        while (!derecha and !tablaAux.nil?)
            derecha = verificarExpresion(expresion.derecha, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end        
        
        #Se verifica si ambas variables son de tipo int
        if (izquierda.eql? "array" and derecha.eql? "array") then
            return "array"
        else 
            if !(izquierda.eql? "array") then 
                tokenAux = expresion.izquierda
                
                while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                    tokenAux = tokenAux.izquierda
                end
                error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion CONCATENAR son diferentes"
                $tablaErrores << error
            else 
                tokenAux = expresion.derecha
                
                while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                    tokenAux = tokenAux.izquierda
                end
                error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion CONCATENAR son diferentes"
                $tablaErrores << error
            end
        end
    end
    
    
    #Funcion que se encarga de verificar la operacion Indexacion
    def verificarIndexacion(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        izquierda = verificarExpresion(expresion.izquierda, tablaAux)
        
        while (!izquierda and !tablaAux.nil?)
            izquierda = verificarExpresion(expresion.izquierda, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se busca en los alcances hasta encontrar la primera expresion valida a derecha
        tablaAux = tablaActual
        derecha = verificarExpresion(expresion.derecha, tablaAux)
        
        while (!derecha and !tablaAux.nil?)
            derecha = verificarExpresion(expresion.derecha, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end        
        
        #Se verifica si ambas variables son de tipo int
        if (izquierda.eql? "array" and derecha.eql? "int") then
            return "int"
        else 
            if !(izquierda.eql? "array") then 
                tokenAux = expresion.izquierda
                
                while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                    tokenAux = tokenAux.izquierda
                end
                error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion CONCATENAR son diferentes"
                $tablaErrores << error
            else 
                tokenAux = expresion.derecha
                
                while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                    tokenAux = tokenAux.izquierda
                end
                error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion CONCATENAR son diferentes"
                $tablaErrores << error
            end
        end
    end


    #Funcion que se encarga de verificar la operacion MenorQue
    def verificarMenorQue(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        izquierda = verificarExpresion(expresion.izquierda, tablaAux)
        
        while (!izquierda and !tablaAux.nil?)
            izquierda = verificarExpresion(expresion.izquierda, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se busca en los alcances hasta encontrar la primera expresion valida a derecha
        tablaAux = tablaActual
        derecha = verificarExpresion(expresion.derecha, tablaAux)
        
        while (!derecha and !tablaAux.nil?)
            derecha = verificarExpresion(expresion.derecha, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end        
        
        #Se verifica si ambas variables son de tipo int
        if (izquierda.eql? "int" and derecha.eql? "int") then
            return "bool"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion MENOR QUE son diferentes"
            $tablaErrores << error
        end
    end
    
    
    #Funcion que se encarga de verificar la operacion MenorIgualQue
    def verificarMenorIgualQue(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        izquierda = verificarExpresion(expresion.izquierda, tablaAux)
        
        while (!izquierda and !tablaAux.nil?)
            izquierda = verificarExpresion(expresion.izquierda, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se busca en los alcances hasta encontrar la primera expresion valida a derecha
        tablaAux = tablaActual
        derecha = verificarExpresion(expresion.derecha, tablaAux)
        
        while (!derecha and !tablaAux.nil?)
            derecha = verificarExpresion(expresion.derecha, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end        
        
        #Se verifica si ambas variables son de tipo int
        if (izquierda.eql? "int" and derecha.eql? "int") then
            return "bool"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion MENOR IGUAL QUE son diferentes"
            $tablaErrores << error
        end
    end
    
    
    #Funcion que se encarga de verificar la operacion MayorQue
    def verificarMayorQue(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        izquierda = verificarExpresion(expresion.izquierda, tablaAux)
        
        while (!izquierda and !tablaAux.nil?)
            izquierda = verificarExpresion(expresion.izquierda, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se busca en los alcances hasta encontrar la primera expresion valida a derecha
        tablaAux = tablaActual
        derecha = verificarExpresion(expresion.derecha, tablaAux)
        
        while (!derecha and !tablaAux.nil?)
            derecha = verificarExpresion(expresion.derecha, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end        
        
        #Se verifica si ambas variables son de tipo int
        if (izquierda.eql? "int" and derecha.eql? "int") then
            return "bool"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion MAYOR QUE son diferentes"
            $tablaErrores << error
        end
    end
    
    
    #Funcion que se encarga de verificar la operacion MayorIgualQue
    def verificarMayorIgualQue(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        izquierda = verificarExpresion(expresion.izquierda, tablaAux)
        
        while (!izquierda and !tablaAux.nil?)
            izquierda = verificarExpresion(expresion.izquierda, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se busca en los alcances hasta encontrar la primera expresion valida a derecha
        tablaAux = tablaActual
        derecha = verificarExpresion(expresion.derecha, tablaAux)
        
        while (!derecha and !tablaAux.nil?)
            derecha = verificarExpresion(expresion.derecha, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end        
        
        #Se verifica si ambas variables son de tipo int
        if (izquierda.eql? "int" and derecha.eql? "int") then
            return "bool"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion MAYOR IGUAL QUE son diferentes"
            $tablaErrores << error
        end
    end
    
    
    #Funcion que se encarga de verificar la operacion Igualdad
    def verificarIgualdad(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        izquierda = verificarExpresion(expresion.izquierda, tablaAux)
        
        while (!izquierda and !tablaAux.nil?)
            izquierda = verificarExpresion(expresion.izquierda, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se busca en los alcances hasta encontrar la primera expresion valida a derecha
        tablaAux = tablaActual
        derecha = verificarExpresion(expresion.derecha, tablaAux)
        
        while (!derecha and !tablaAux.nil?)
            derecha = verificarExpresion(expresion.derecha, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end        
        
        #Se verifica si ambas variables son de tipo int
        if (izquierda.eql? derecha) then
            return "bool"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion IGUALDAD son diferentes"
            $tablaErrores << error
        end
    end    


    #Funcion que se encarga de verificar la operacion Desigual
    def verificarDesigual(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        izquierda = verificarExpresion(expresion.izquierda, tablaAux)
        
        while (!izquierda and !tablaAux.nil?)
            izquierda = verificarExpresion(expresion.izquierda, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se busca en los alcances hasta encontrar la primera expresion valida a derecha
        tablaAux = tablaActual
        derecha = verificarExpresion(expresion.derecha, tablaAux)
        
        while (!derecha and !tablaAux.nil?)
            derecha = verificarExpresion(expresion.derecha, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end        
        
        #Se verifica si ambas variables son de tipo int
        if (izquierda.eql? derecha) then
            return "bool"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            error = "Error en línea #{tokenAux.token.linea}: los tipos de la operacion DESIGUAL son diferentes"
            $tablaErrores << error
        end
    end

    
    #Funcion que se encarga de verificar la operacion Negativo (Menos unario)
    def verificarNegativo(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        expr = verificarExpresion(expresion.expresion, tablaAux)
        
        while (!expr and !tablaAux.nil?)
            expr = verificarExpresion(expresion.expresion, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end

        #Se verifica si la variable es de tipo int
        if (expr.eql? "int") then
            return "int"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            error = "Error en línea #{tokenAux.token.linea}: el tipo del operando de la operacion NEGATIVO no es bool"
            $tablaErrores << error
        end
    end


    #Funcion que se encarga de verificar la operacion Not
    def verificarNot(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        expr = verificarExpresion(expresion.expresion, tablaAux)
        
        while (!expr and !tablaAux.nil?)
            expr = verificarExpresion(expresion.expresion, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end

        #Se verifica si la variable es de tipo bool
        if (expr.eql? "bool") then
            return "bool"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            error = "Error en línea #{tokenAux.token.linea}: el tipo del operando de la operacion NOT no es bool"
            $tablaErrores << error
        end
    end
    

    #Funcion que se encarga de verificar la operacion CaracterSiguiente
    def verificarCaracterSiguiente(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        expr = verificarExpresion(expresion.expresion, tablaAux)
        
        while (!expr and !tablaAux.nil?)
            expr = verificarExpresion(expresion.expresion, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end

        #Se verifica si la variable es de tipo bool
        if (expr.eql? "tkcaracter") then
            return "tkcaracter"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            error = "Error en línea #{tokenAux.token.linea}: el tipo del operando de la operacion CARACTER SIGUIENTE no es caracter"
            $tablaErrores << error
        end
    end
    
    
    #Funcion que se encarga de verificar la operacion CaracterAnterior
    def verificarCaracterAnterior(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        expr = verificarExpresion(expresion.expresion, tablaAux)
        
        while (!expr and !tablaAux.nil?)
            expr = verificarExpresion(expresion.expresion, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end

        #Se verifica si la variable es de tipo bool
        if (expr.eql? "tkcaracter") then
            return "tkcaracter"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            error = "Error en línea #{tokenAux.token.linea}: el tipo del operando de la operacion CARACTER ANTERIOR no es caracter"
            $tablaErrores << error
        end
    end
    

    #Funcion que se encarga de verificar la operacion ValorAsciiParser
    def verificarValorAsciiParser(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        expr = verificarExpresion(expresion.expresion, tablaAux)
        
        while (!expr and !tablaAux.nil?)
            expr = verificarExpresion(expresion.expresion, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end

        #Se verifica si la variable es de tipo bool
        if (expr.eql? "tkcaracter") then
            return "tkcaracter"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            error = "Error en línea #{tokenAux.token.linea}: el tipo del operando de la operacion VALOR ASCII no es caracter"
            $tablaErrores << error
        end
    end
    

    #Funcion que se encarga de verificar la operacion ShiftParser
    def verificarShiftParser(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        expr = verificarExpresion(expresion.expresion, tablaAux)
        
        while (!expr and !tablaAux.nil?)
            expr = verificarExpresion(expresion.expresion, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end

        #Se verifica si la variable es de tipo bool
        if (expr.eql? "array") then
            return "array"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            error = "Error en línea #{tokenAux.token.linea}: el tipo del operando de la operacion SHIFT no es array"
            $tablaErrores << error
        end
    end


    #Funcion que se encarga de verificar la operacion AsignacionA
    def verificarAsignacionA(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        izquierda = verificarExpresion(expresion.id, tablaAux)
        
        while (!izquierda and !tablaAux.nil?)
            izquierda = verificarExpresion(expresion.izquierda, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        derecha = verificarExpresion(expresion.expresion, tablaAux)
        
        while (!derecha and !tablaAux.nil?)
            derecha = verificarExpresion(expresion.expresion, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se verifica si la variables son del mismo tipo
        if (izquierda.eql? derecha) then
            return "bool"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            error = "Error en línea #{tokenAux.token.linea}: el tipo de la variable no coincide con la del valor que se le va a asignar"
            $tablaErrores << error
        end
    end
    
    #Funcion que se encarga de verificar la operacion AsignacionB
    def verificarAsignacionB(expresion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        izquierda = verificarExpresion(expresion.id, tablaAux)
        
        while (!izquierda and !tablaAux.nil?)
            izquierda = verificarExpresion(expresion.izquierda, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se busca en los alcances hasta encontrar la primera expresion valida a izquierda
        tablaAux = tablaActual
        derecha = verificarExpresion(expresion.expresion, tablaAux)
        
        while (!derecha and !tablaAux.nil?)
            derecha = verificarExpresion(expresion.expresion, tablaAux)
            tablaAux = tablaAux.obtenerPadre()
        end
        
        #Se verifica si la variables son del mismo tipo
        if (izquierda.eql? derecha) then
            return "bool"
        else 
            tokenAux = expresion.izquierda
            
            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end
            error = "Error en línea #{tokenAux.token.linea}: el tipo de la variable no coincide con la del valor que se le va a asignar"
            $tablaErrores << error
        end
    end    

end
