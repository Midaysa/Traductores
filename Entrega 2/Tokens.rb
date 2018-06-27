# Token.rb
#
# Descripcion: Archivo que contiene los tokens que se van a manejar   
# en el lenguaje BasicTran 
#
# Autores :  Ritces Parra   12-11088
#            Palacios Gomez 10-10870


class Token
    attr_accessor :valor, :linea , :columna
     
    def initialize valor, linea, columna
        @valor = valor
        @linea = linea
        @columna = columna
    end

    #Funcion que imprime el token
    def to_s 
        " #{@valor} "
    end
end


#Subclase de token que define los tokens, pero ademas imprime el valor
#que tiene la expresion regular
class TokensEspeciales < Token
    attr_accessor :key, :valor, :linea , :columna 
    #Se inicializa una nueva instancia con los valores respectivos
    def initialize key , valor, linea, columna
        @key = key 
        @valor  = valor
        @linea  = linea
        @columna = columna
    end

    #Funcion que imprime el token pero con el valor capturado
    def to_s 
        "#{@valor}"
    end
end


#Subclase en donde se tiene los caracteres que no pertenecen al lenguaje
class CaracterInesperado < Token
    attr_accessor :valor, :linea, :columna
    def initialize valor, linea, columna
        @valor= valor
        @linea = linea
        @columna = columna
    end

    #Funcion que imprime el error 
    def to_s 
        "Error: Se encontró un caracter inesperado \"#{@valor}\" en la línea #{@linea}, Columna #{@columna}"
    end
end

# Se crea un hash  
rw = Hash::new
palabras_reservadas = %w(begin read end with int bool output print outputln if else for repeat while do true false from var read of char to array subroutine real otherwise call function stop open write close def break in step)

#Se van agregando al hash con su expresion regular
palabras_reservadas.each do |s|
    if s == 'array'
        rw['TkArray'] = /\Aarray\b/
    else
        rw[s.capitalize] = /\A#{s}\b/
    end
end
 

$tokensEspeciales = {
    
    'TkId'                =>  /\A[a-zA-Z][0-9a-zA-Z_]*/ , 
    'TkNum'               =>  /\A\d+/,
    'TkCaracter'          =>  /\A'([^\\\n]?\\\\|[^\\\n]?\\n|[^\\\n]?\\"|[^\\\n]|[^\\\n]?\\t)?'/,
} 


#Declaracion de los tokens con sus expresiones regulares
tokens = {
     
    'ValorAscii' => /\A#/ ,
    'Negacion' => /\Anot/         ,           
    'Coma'                   =>  /\A\,/,   
    'Punto'                   =>  /\A\./,
    'PuntoYComa'             =>  /\A\;/,
    'SiguienteCar'          => /\A\+\+/    , 
    'Concatenacion' => /\A::/             ,
    'AnteriorCar' => /\A--/       ,    
    'DosPuntos' => /\A:/       ,
    'ParAbre' => /\A\(/       ,
    'ParCierra' => /\A\)/      ,
    'CorcheteAbre' => /\A\[/   ,
    'CorcheteCierre' => /\A\]/ ,
    'Hacer' =>/\A->(?!>)/         ,
    'Asignacion' => /\A<-(?!-)/   ,
    'Suma' => /\A\+/              ,
    'Resta' =>/\A-(?!>)/          ,
    'Mult' => /\A\*/               ,  
    'Desigualdad' =>/\A\/=/        ,             
    'Conjuncion'    => /\A\/\\/   ,
    'Div'    =>  /\A\//           , 
    'Mod' => /\A%(?!=)/           ,
    'Disyuncion' => /\A\\\//      ,
    'MenorIgual' => /\A<=/        ,
    'Menor' => /\A</              ,
    'MayorIgual' => /\A>=/        ,
    'Mayor' => /\A>/              ,
    'Igual' => /\A=/              ,
    'Shift' => /\A\$/            ,

}


#Se une los dos hash el de las palabras reservadas y las de tokens
$tokensDicc = rw.merge(tokens)


#Declaracion del segundo grupo de expresiones regulares , esto se hizo ya que para estas expresiones regulares
# se desea tener el valor que contiene la expresion regular 
$tokensDicc.each do |id,regex|
    newclass = Class::new(Token) do
    end
    Object::const_set("#{id}", newclass)
end


$tokensEspeciales.each do |id,regex|
    newclass = Class::new(TokensEspeciales) do
    end
    Object::const_set("#{id}", newclass)
end
