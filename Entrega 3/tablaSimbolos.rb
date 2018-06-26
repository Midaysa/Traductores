class TablaSimbolos
    
    attr_accessor :tabla, :padre, :hijo, :for
    
    #Funcion para inicializar una tabla de simbolos
    def initialize 
        @tabla = Hash.new
        @padre = nil
        @hijo = Array.new
        @for = false
    end

    def asignarPadre(padre)
        @padre = padre
    end

    def asignarHijo(hijo)
        @hijo = hijo
    end
    
    def obtenerPadre()
        return @padre
    end
    
    def obtenerHijo()
        return @hijo
    end

    def insertar(id, tipo)
        if tabla.has_key?(id) == false
            @tabla[id] = tipo
            return true
        else
            return false
        end
    end

    def actualizar(id, tipo)
        if @tabla.has_key?(id)
            @tabla[id] = tipo
            return true
        else
            return false
        end
    end
    
    def contiene(id)
       return @tabla.has_key?(id) 
    end

    def buscar(id)
        if @tabla.has_key?(id)
            return @tabla[id]
        else
            return false
        end
    end
    
    def obtenerTabla
        return @tabla
    end

    def imprimirTabla(indent = "")
        puts "#{indent}TABLA DE SIMBOLOS"
        indent = indent + "     "
        tabla.each do |id, tipo|
            puts "#{indent}Nombre: #{id}, Tipo #{tipo}\n"
        end
    end
    
end

#Variables globales
$tablaInicial = TablaSimbolos.new
$tablaErrores = Array.new

class crearTabla
    
    #Funcion para crear las tablas y verificar si hay errores
    def crear(arbol)
        @arbol = arbol
        verificarBloque(@arbol.bloque, $tablaInicial)

        if ($tablaErrores.length > 0)
            return $tablaErrores
        else
            return tablaInicial
        end
    end
   

    #Funcion que se encarga de verificar el codigo dentro de un blque y de la 
    #creacion de las tablas correspondientes al mismo
    def verificarBloque(bloque, tablaActual)
        nuevaTabla = TablaSimbolos.new
        nuevaTabla.asignarPadre(tablaActual)
       
        verificarDeclaracion(bloque.declaraciones.declaracion, tablaActual) 
        verificarInstruccion(bloque.instrucciones.instruccion, tablaActual)
    end


    #Funcion que se encarga de analizar el tipo de declaracion realizada
    #y la envia a la funcion que se encarga de su verificacion
    def verificarDeclaracion(declaracion, tablaActual)
        case declaracion.identificador
        
        when Identificador
            verificarDeclaracionIdentificador(declaracion, tablaActual)

        when AsignacionA
            verificarDeclaracionAsignacionA(declaracion, tablaActual)
        end
    end


    #Funcion que se encarga de insertar en la tabla los datos de la
    #declaracion del identificador
    def verificarDeclaracionIdentificador(declaracion, tablaActual)
        case declaracion.tipo

        when TipoInt
            begin
                asigno = tablaActual.insertar(declaracion.identificador.izquierda.token.value, "int")
                token = declaracion.identificador.izquierda.token
            end

        when TipoBool
            begin
                asigno = tablaActual.insertar(declaracion.identificador.izquierda.token.value, "bool")
                token = declaracion.identificador.izquierda.token            
            end

        when TipoChar
            begin
                asigno = tablaActual.insertar(declaracion.identificador.izquierda.token.value, "char")
                token = declaracion.identificador.izquierda.token
            end

        when TipoArray
            begin
                asigno = tablaActual.insertar(declaracion.identificador.izquierda.token.value, "array")
                token = declaracion.identificador.izquierda.token
            end
        end

        #Si los datos no se pudieron incluir en la tabla se empila en la tabla de errores  un mensaje con el error
        if !asigno then
            error = "Error en linea #{token.linea}, columna #{token.columna}: La variable '#{token.valor}' ya ha sido declarada en este alcance"
            $tablaErrores << error
        end
    end


    #Funcion que se encarga de insertar en la tabla los datos de la 
    #declaracion de la asignacion
    def verificarDeclaracionAsignacionA(declaracion, tablaActual)
        case declaracion.tipo

        when TipoInt
            begin
                asigno = tablaActual.insertar(declaracion.identificador.izquierda.token.value, "int")
                token = declaracion.identificador.izquierda.token
            end

        when TipoBool
            begin
                asigno = tablaActual.insertar(declaracion.identificador.izquierda.token.value, "bool")
                token = declaracion.identificador.izquierda.token            
            end

        when TipoChar
            begin
                asigno = tablaActual.insertar(declaracion.identificador.izquierda.token.value, "char")
                token = declaracion.identificador.izquierda.token
            end

        when TipoArray
            begin
                asigno = tablaActual.insertar(declaracion.identificador.izquierda.token.value, "array")
                token = declaracion.identificador.izquierda.token
            end
        end    

        #Si los datos no se pudieron incluir en la tabla se empila en la tabla de errores  un mensaje con el error
        if !asigno then
            error = "Error en linea #{token.linea}, columna #{token.columna}: La variable '#{token.valor}' ya ha sido declarada en este alcance"
            $tablaErrores << error
        end
    end


    #Funcion que se encarga de analizar una instruccion y la envia a la
    #funcion que se encarga de su verificacion
    def verificarInstruccion(instruccion, tablaActual)
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
        nombre = identificador.token.valor
        return tablaActual.buscar(nombre)
    end


    #Funcion que se encarga de verificar la instruccion condicional
    def verificarInstruccionCondicional(instruccion, tablaActual)
        #Se busca en los alcances hasta encontrar la primera expredion valida
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
        #Se busca en los alcances hasta encontrar la primera expredion valida
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


    #Funcion que se encarga de verificar la instruccion del tipo IteracionDet
    def verificarIteracionDet(instruccion, tablaPadre)
        #Se crea la tabla para el manejo del for
        tablaActual = TablaSimbolos.new
        tablaActual.asignarPadre(tablaPadre)
        tablaPadre.asignarHijo(tablaActual)
        tablaActual.for = true

        #Se inserta la variable de iteracion en la tabla de simbolos actual
        tablaActual.insertar(instruccion.identificador.token.valor, "tkid")
        limiteInferior = verificarLiteral(instruccion.limInf)
        limiteSuperior = verificarLiteral(instruccion.limSup)
        verificarInstruccion(instruccion.instruccion, tablaActual)
    end

    #
    #           OJO CON ESTO
    #AQUI SE DEBE MODIFICAR PARA ESTE NODO EL NOMBRE DE IteracionDet A IteracionDetStep
    #
    #
    #Funcion que se encarga de verificar la instruccion del tipo IteracionDetStep
    def verificarIteracionDetStep(instruccion, tablaPadre)
        #Se crea la tabla para el manejo del for
        tablaActual = TablaSimbolos.new
        tablaActual.asignarPadre(tablaPadre)
        tablaPadre.asignarHijo(tablaActual)
        tablaActual.for = true

        #Se inserta la variable de iteracion en la tabla de simbolos actual
        tablaActual.insertar(instruccion.identificador.token.valor, "tkid")
        limiteInferior = verificarLiteral(instruccion.limInf)
        limiteSuperior = verificarLiteral(instruccion.limSup)
        pasoDeIteracion = verificarLiteral(instruccion.iterador)
        verificarInstruccion(instruccion.instruccion, tablaActual)
    end


    #Funcion que se encarga de verificar la instruccion de tipo Salida
    def Salida(expresion, tablaActual)
        tablaAux = tablaActual
        exp = verificarExpresion(instruccion.expresion, tablaAux)
        
        while (!exp and !tablaAux.nil?)
            exp = verificarExpresion(instruccion.expresion, tablaAux)
            tablaAux = tablaAux.obtenerPadre
        end

        if !exp
            tokenAux = expresion

            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end                
            error = "Error en línea #{tokenAUX.token.linea}: el tipo de la expresion '#{tokenAUX.token.valor}' no esta en el alcance."
            $errorTabla << error            
        end 
    end


    #Funcion que se encarga de verificar la instruccion de tipo Entrada
    def Entrada(identificador, tablaActual)
        tablaAux = tablaActual
        identificador = verificarExpresion(identificador.expresion, tablaAux)
        
        while (!identificador and !tablaAux.nil?)
            identificador = verificarIdentificador(identificador.expresion, tablaAux)
            tablaAux = tablaAux.obtenerPadre
        end

        if !identificador
            tokenAux = identificador

            while (!(tokenAux.class.eql? Identificador) and !(tokenAux.class.eql? LitNum) and !(tokenAux.class.eql? LitChar) and !(tokenAux.class.eql? LitTrue) and !(tokenAux.class.eql? LitFalse))
                tokenAux = tokenAux.izquierda
            end                
            error = "Error en línea #{tokenAUX.token.linea}: el tipo de la expresion '#{tokenAUX.token.valor}' no esta en el alcance."
            $errorTabla << error            
        end 
    end


    #Funcion que se encarga de analizar el tipo de expresion a evaluar
    #y la envia a la funcion que se encarga de su verificacion
    def verificarExpresion(expresion, tablaActual)
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


    #Funcion que se encarga de verificar 

end
