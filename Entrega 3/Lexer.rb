# Lexer.rb
#
# Descripcion: Archivo que contiene la implementacion del Lexer  
# del lenguaje BasicTran 
#
# Autores :  Ritces Parra   12-11088
#            Palacios Gomez 10-10870

require_relative 'Tokens'

#Clase lexer 
class Lexer
    
    #Se inicializa el lexer con el archivo a ser leido como parametro de entrada
    def initialize(archivo)
        @tokens = []#arreglo con los tokens pertenecientes al lenguaje que se han leido
        @errores = []#arreglo con los errores  
        @actual = 0
        @linea = 1   
        @columna = 1   
        @archivo = archivo

    end

    #Funcion que se encarga de leer del archivo linea por linea las entradas 
    #para extraer los tokens o en su defecto los errores del archivo
    def leerLexer

        #Se ignora los espacios en blanco al inicio de la linea
        @archivo =~ /\A[ \t\r\f]*|[ \n]*|\A[ \t\r\f]+/
        if not$&.nil?
            @columna += $&.length
            @archivo = $'
        end

        #Se ignora si hay un salto de linea, y se vuelve a llamar a la funcion
        #para empezar nuevamente la lectura
        @archivo =~ /\A\n/
        if not$&.nil?
            @linea += 1
            @columna = 1
            @archivo = $'
            self.leerLexer()
        end

        #Si no lo consigue en el diccionario de tokens, lo busco en las expresiones 
        #regulares que se definieron en la subclase token
       $tokensDicc.each do |key, valor|
            #verifica si encontro una epresion regular con la que coincida
            if @archivo =~ valor
                matchToken = $& #Se guarda lo que capturo la expresion regular
                resto = $' #Se guarda el resto del archivo para seguir con la lectura
                @TokenClass = Object::const_get(key) #Se crea un nueva instacia de token
                @tokens << @TokenClass.new(key, @linea, @columna) 
                @columna += matchToken.length #Se actualiza en que columna en donde estamos
                @archivo = resto  
                self.leerLexer()  
            end
        end
        
        #Si no lo consigue en el diccionario de tokens, lo busco en las expresiones 
        #regulares que se definieron en la subclase token
        $tokensEspeciales.each do |key, valor|
            if @archivo=~ valor
                matchToken = $& 
                resto = $'  
                @TokenClass = Object::const_get(key)  
                @tokens << @TokenClass.new(key, matchToken, @linea, @columna) 
                @columna += matchToken.length  
                @archivo = resto  
                self.leerLexer() 
            end
        end

        #Sino esta en ninguna de las anteriores , lo tomo como un error
        if !@archivo.eql?(nil) and !(@archivo.length.eql? 0)
            @TokenClass = Object::const_get("#{CaracterInesperado}")#Se crea un nueva instacia de error
            @errores << @TokenClass.new(@archivo[0], @linea, @columna)#Se almacena en el arreglo de errores
            @columna += 1  
            @archivo = @archivo[1..(@archivo.length-1)]#Se actualiza la entrada quitando el caracter de error
            self.leerLexer()  
        end
    end


    #Funcion que devuelve en donde estoy 
    def tiene_token
        return @actual < @tokens.length
    end

    
    #Funcion que devuelve el siguiente token    
    def siguiente_token 
        token = @tokens[@actual]
        @actual = @actual + 1
        return token
    end


    #Funcion que  imprimir lo que se leyo en el archivo
    def imprimir
        #Si no encontro errores, entonces imprimo los tokens
        if @errores.empty?
            puts @tokens
        #En caso contrario, imprimo los errores
        else
            puts @errores
        end
    end


    #Funcion que me dice si encontro errores 
    def encontrado
        #Si no encontro errores, entonces retorna los tokens
        if @errores.empty?
            return @tokens
        #Sino, imprimo los errores
        else
            self.imprimir
        end
    end
end
