# astParser.rb
#
# Descripcion: Archivo que contiene las clases usadas para crear el arbol 
# sintactico abstracto correspondiente a las frases del lenguaje BasicTran
#
# Autores :  Ritces Parra   12-11088
#            Palacios Gomez 10-10870


class AST
    attr_accessor :linea
    def print_ast indent=""
        attrs.each do |a|
            a.print_ast indent + "" if a.respond_to? :print_ast
        end
    end
    def print_ast_tabla(tabla, indent="")
        attrs.each do |a|
            a.print_ast_tabla(tabla, indent + "      ")if a.respond_to? :print_ast
        end
    end	
	 
    def set_line l
        @line=l
    end
    def attrs
        instance_variables.map do |a|
            instance_variable_get a
        end
    end   
end
 
 
# Clase principal del programa
class S < AST
  attr_accessor :bloque
    def initialize b
        @bloque = b 
    end
    def print_ast indent = ""
       
        @bloque.print_ast
    end
    def print_ast_tabla(tabla, indent = "")
        puts "#{indent}Tipo: #{self.class}"
        @bloque.print_ast_tabla(tabla.hijo[0])
    end
end

# Clase que contiene las declaraciones e instrucciones
class Bloque < AST
    attr_accessor :declaraciones, :instrucciones

    def initialize d, i
        @declaraciones = d  
        @instrucciones = i  
    end
    def print_ast indent = ""
        if @declaraciones.nil? == false
            @declaraciones.print_ast indent + "    " if @declaraciones.respond_to? :print_ast
        end
        puts "#{indent}     SECUENCIACION"
        
        if @instrucciones.nil? == false
            @instrucciones.print_ast indent + "    " if @instrucciones.respond_to? :print_ast  
        end 
    end
  
    def print_ast_tabla(tabla, indent = "")  
          
            if @declaraciones.nil? == false
                tabla.printTabla(indent + "    ")
            end
             puts "#{indent}     SECUENCIACION"
            if  @instrucciones.nil?
                @instrucciones.print_ast_tabla(tabla.hijo[0], indent + "    ")
             
            end
            tabla.padre.hijo = tabla.padre.hijo.drop(1)
          
     end
end

# Clase que contiene la(s) declaracion(es) de la(s) variable(s)
class DeclaracionesList < AST
    attr_accessor :declaracion, :declaraciones
    
    def initialize d, des
        @declaracion = d
        @declaraciones = des
    end
    def print_ast indent = ""
        @declaracion.print_ast indent + "    " if @declaracion.respond_to? :print_ast
        if declaraciones.nil? == false
            @declaraciones.print_ast indent + "    " if @declaraciones.respond_to? :print_ast             
        end        
    end 

end

 
# Clase donde se maneja la declaracion de variables   
class Declaracion < AST
    attr_accessor :identificador, :tipo 
    
    def initialize i, t
        @identificador = i              
        @tipo = t 
    end
     def print_ast indent=""
        puts "#{indent}DECLARACION"
        @identificador.print_ast indent + "    " if @identificador.respond_to? :print_ast
        @tipo.print_ast indent + "    " if @tipo.respond_to? :print_ast
     end   
end    


# Clase constituida por lo contenido en la lista de identificadores 
class ListaIdentificadores < AST
    
   attr_accessor :id, :expresion,:lista
   def initialize id, expresion,lista
       @id = id
       @expresion = expresion
       @lista = lista
    end   
    def print_ast indent = ""
        @id.print_ast indent + "    " if @id.respond_to? :print_ast
        @expresion.print_ast indent + "    " if @expresion.respond_to? :print_ast
        @lista.print_ast indent + "    " if @lista.respond_to? :print_ast
    end
    def print_ast_tabla(tabla,indent = "")
        @id.print_ast_tabla(tabla, indent + "    " ) if @id.respond_to? :print_ast
        @expresion.print_ast_tabla(tabla, indent + "    " ) if @expresion.respond_to? :print_ast
        @lista.print_ast_tabla(tabla, indent + "      ") if @lista.respond_to? :print_ast
    end


end


#Clase que contiene el tipo de una variable  
class Tipo < AST
    attr_accessor :tipo
    
    def initialize t
        @tipo = t              
    end
    def print_ast indent = ""
     puts "#{indent}         tipo: "  + @tipo.to_s()
    end

    def print_ast_tabla(tabla,indent = "" )
     puts "#{indent}         tipo: "  + @tipo.to_s()
    end

end


# Clase con las asignaciones regulares del lenguajes
class AsignacionA < AST
   attr_accessor :id, :expresion 
   
   def initialize id, expresion 
       @id = id
       @expresion = expresion
    end   
    def print_ast indent = ""
        puts "#{indent}ASIGNACION "  
        @id.print_ast indent + "    " if @id.respond_to? :print_ast
        @expresion.print_ast indent + "    " if @expresion.respond_to? :print_ast
    end

    def print_ast_tabla(tabla, indent = "")
        puts "#{indent}ASIGNACION "  
        @id.print_ast_tabla(tabla, indent + "    " ) if @id.respond_to? :print_ast
        @expresion.print_ast_tabla(tabla, indent + "    " )  if @expresion.respond_to? :print_ast
    end

end


# Clase con las asignacion de arreglos
class AsignacionB < AST
   attr_accessor :id, :expresion, :expresion1

   def initialize id, expresion ,expresion1
       @id = id
       @expresion = expresion
       @expresion1 = expresion1

    end
    def print_ast indent = ""
        puts "#{indent}ASIGNACION ARRAY "  
        @id.print_ast indent + "    " if @id.respond_to? :print_ast
        @expresion.print_ast indent + "    " if @expresion.respond_to? :print_ast
        @expresion1.print_ast indent + "    " if @expresion1.respond_to? :print_ast
    end  

    def print_ast_tabla(tabla, indent = "")
        puts "#{indent}ASIGNACION ARRAY "  
        @id.print_ast_tabla(tabla, indent + "    " )  if @id.respond_to? :print_ast
        @expresion.print_ast_tabla(tabla, indent + "    " ) if  @expresion.respond_to? :print_ast
        @expresion1.print_ast_tabla(tabla, indent + "    " ) if  @expresion1.respond_to? :print_ast
    end  


end



 

#Clase que permite tener varios corchetes
class  Corchetes < AST
   attr_accessor :expresion, :lista
    def initialize expresion, lista
        @expresion = expresion
        @lista =  lista
    end 
    def print_ast indent = ""
        @expresion.print_ast indent + "    " if @expresion.respond_to? :print_ast
        if lista.nil? == false
            @lista.print_ast indent  if @lista.respond_to? :print_ast             
        end
    end

     def print_ast_tabla(tabla, indent = "")
        @expresion.print_ast_tabla(tabla, indent + "    " )  if @expresion.respond_to? :print_ast
        if lista.nil? == false
            @lista.print_ast_tabla(tabla, indent + "    " )   if @lista.respond_to? :print_ast             
        end
    end


end
	
 
# Clase correspondiente al nodo de instrucciones
class ListaIns < AST
    attr_accessor :instruccion, :instrucciones
    def initialize i, ins
        @instruccion = i
        @instrucciones = ins
    end 
    def print_ast indent = ""
        @instruccion.print_ast indent + "    " if @instruccion.respond_to? :print_ast
        if instrucciones.nil? == false
            @instrucciones.print_ast indent  if @instrucciones.respond_to? :print_ast             
        end
    end

    def print_ast_tabla(tabla, indent = "")
         @instruccion.print_ast_tabla(tabla, indent + "    " )  if @instruccion.respond_to? :print_ast
        if instrucciones.nil? == false
            @instrucciones.print_ast_tabla(tabla, indent + "    " )  if @instrucciones.respond_to? :print_ast             
        end
    end

end


# Clase constituida por una instruccion
class Instruccion < AST
    attr_accessor :instruccion
    
    def initialize i
        @instruccion = i                    
    end
end


# Tipos de las variables que pueden existir en la gramatica
class TipoInt   < Tipo; end
class TipoBool  < Tipo; end
class TipoChar  < Tipo; end


# Clase que corresponde al tipo arreglo
class TipoArray < AST
    attr_accessor :dimension, :tipo
    
    def initialize d, t
        @dimension = d
        @tipo = t
    end
    def print_ast indent = "" 
        puts "#{indent}     ASIGNACION ARREGLO"
        
        puts "#{indent}     dimension del arreglo:"  
        @dimension.print_ast indent + "      " if @dimension.respond_to? :print_ast 
        @tipo.print_ast indent + "      " if @tipo.respond_to? :print_ast
    end  

    def print_ast_tabla(tabla, indent = "")  
        puts "#{indent}     ASIGNACION ARREGLO"
        
        puts "#{indent}     dimension del arreglo:"  
        @dimension.print_ast_tabla(tabla, indent + "    " ) if @dimension.respond_to? :print_ast 
        @tipo.print_ast_tabla(tabla, indent + "    " ) if @tipo.respond_to? :print_ast
    end  

end


# Clase para las expresiones binarias
class ExpresionBinaria < AST
    attr_accessor :izquierda, :derecha
    
    def initialize i, d
        @izquierda = i
        @derecha = d 
    end
    def print_ast indent = "" 
        puts "#{indent}     operacion: #{self.class}"
        puts "#{indent}     operador izquierdo:"  
        @izquierda.print_ast indent + "      " if @izquierda.respond_to? :print_ast 
        puts "#{indent}     operador derecho:"
        @derecha.print_ast indent + "      " if @derecha.respond_to? :print_ast
    end
    def print_ast_tabla(tabla, indent = "")  
         puts "#{indent}     operacion: #{self.class}"
        puts "#{indent}     operador izquierdo:"  
        @izquierda.print_ast_tabla(tabla, indent + "    " ) if @izquierda.respond_to? :print_ast 
        puts "#{indent}     operador derecho:"
        @derecha.print_ast_tabla(tabla, indent + "    " ) if @derecha.respond_to? :print_ast
    end

end


#Clases binarias aritmeticas
class Sumar < ExpresionBinaria; end
class Restar < ExpresionBinaria; end
class Multiplicacion < ExpresionBinaria; end
class Division < ExpresionBinaria; end
class Modulo < ExpresionBinaria; end


# Clases Binarias Booleanas
class Or < ExpresionBinaria; end
class And < ExpresionBinaria; end 
class PuntoParser < ExpresionBinaria; end

# Clases Binarias Relacionales
class MenorQue < ExpresionBinaria; end
class MenorIgualQue < ExpresionBinaria; end
class MayorQue < ExpresionBinaria; end
class MayorIgualQue < ExpresionBinaria; end
class Igualdad < ExpresionBinaria; end
class Desigual < ExpresionBinaria; end
 

# Clases binarias de arreglos
class Concatenar < ExpresionBinaria; end
class Indexacion < ExpresionBinaria;end
class ConcatenarArreglo < ExpresionBinaria; end


# Clase para el condicional    
class Condicional < AST
    attr_accessor :guardia, :instruccion
    
    def initialize g, i 
        @guardia = g 
        @instruccion = i
    end
    def print_ast indent = ""
        puts "#{indent} CONDICIONAL"
        indent = indent + "      "
        puts "#{indent}     guardia:" 
        @guardia.print_ast indent + "      " if @guardia.respond_to? :print_ast 
        puts "#{indent}     exito:" 
        @instruccion.print_ast indent + "      " if @instruccion.respond_to? :print_ast
    end

    def print_ast_tabla(tabla, indent = "") 
       puts "#{indent} CONDICIONAL"
        indent = indent + "      "
        puts "#{indent}     guardia:" 
        @guardia.print_ast_tabla(tabla, indent + "    " ) if @guardia.respond_to? :print_ast 
        puts "#{indent}     exito:" 
        @instruccion.print_ast_tabla(tabla, indent + "    " ) if @instruccion.respond_to? :print_ast
    end

end


# Clase para el condicional con otherwise   
class CondicionalOth < AST
    attr_accessor :guardia, :instruccion1, :instruccion2 
    
    def initialize g, i1, i2
        @guardia = g 
        @instruccion1 = i1
        @instruccion2 = i2
    end
    def print_ast indent = ""
        puts "#{indent} CONDICIONAL"
        puts "#{indent}     guardia:" 
        @guardia.print_ast indent + "      " if @guardia.respond_to? :print_ast 

        puts "#{indent}     exito: " 
        @instruccion1.print_ast indent + "      " if @instruccion1.respond_to? :print_ast

        puts "#{indent}     fracaso:" 
        @instruccion2.print_ast indent + "      " if @instruccion2.respond_to? :print_ast   
    end

     def print_ast_tabla(tabla, indent = "") 
        puts "#{indent} CONDICIONAL"
        puts "#{indent}     guardia:" 
        @guardia.print_ast_tabla(tabla, indent + "    " ) if @guardia.respond_to? :print_ast 

        puts "#{indent}     exito: " 
        @instruccion1.print_ast_tabla(tabla, indent + "    " ) if @instruccion1.respond_to? :print_ast

        puts "#{indent}     fracaso:" 
        @instruccion2.print_ast_tabla(tabla, indent + "    " ) if @instruccion2.respond_to? :print_ast   
    end


end


# Clase para la iteraciones indeterminadas
class IteracionInd < AST
    attr_accessor :expresion, :instruccion
    
    def initialize e, i 
        @expresion = e
        @instruccion = i
    end
    def print_ast indent = ""
        puts "#{indent} ITERACION INDETERMINADA"
        puts "#{indent}     guardia:"
        @expresion.print_ast indent + "      " if @expresion.respond_to? :print_ast
        @instruccion.print_ast indent + "      " if @instruccion.respond_to? :print_ast
    end
    def print_ast_tabla(tabla, indent = "") 
        puts "#{indent} ITERACION INDETERMINADA"
        puts "#{indent}     guardia:"
        @expresion.print_ast_tabla(tabla, indent + "    " ) if @expresion.respond_to? :print_ast
        @instruccion.print_ast_tabla(tabla, indent + "    " ) if @instruccion.respond_to? :print_ast
    end


end

 
 

class IteracionDet < AST
    attr_accessor :identificador, :limInf, :limSup, :instrucciones, :iterador 
    
    def initialize ident, li, ls, ins, iter
        @identificador = ident
        @limInf = li
        @limSup = ls
        @instrucciones = ins
        @iterador = iter
    end
    def print_ast indent = ""
        puts "#{indent} ITERACION DETERMINADA"
        puts "#{indent}     identificador:"
        @identificador.print_ast indent + "      " if @identificador.respond_to? :print_ast

        puts "#{indent}     limite inferior:"
        @limInf.print_ast indent + "      " if @limInf.respond_to? :print_ast
        
        puts "#{indent}     limite superior:"
        @limSup.print_ast indent + "      " if @limSup.respond_to? :print_ast
    
        if @iterador.nil? == false
            puts "#{indent}     paso de iteracion:"
            @iterador.print_ast indent + "      " if @iterador.respond_to? :print_ast
        end
        @instrucciones.print_ast indent + "      " if @instrucciones.respond_to? :print_ast   
    end   

    def print_ast_tabla(tabla, indent = "") 
        puts "#{indent} ITERACION DETERMINADA"
        puts "#{indent}     identificador:"
        @identificador.print_ast_tabla(tabla, indent + "    " ) if @identificador.respond_to? :print_ast

        puts "#{indent}     limite inferior:"
        @limInf.print_ast_tabla(tabla, indent + "    " )  if @limInf.respond_to? :print_ast
        
        puts "#{indent}     limite superior:"
        @limSup.print_ast_tabla(tabla, indent + "    " )  if @limSup.respond_to? :print_ast
    
        if @iterador.nil? == false
            puts "#{indent}     paso de iteracion:"
            @iterador.print_ast_tabla(tabla, indent + "    " ) if @iterador.respond_to? :print_ast
        end
        @instrucciones.print_ast_tabla(tabla, indent + "    " )   if @instrucciones.respond_to? :print_ast   
    end 

end


# Clase para las iteraciones determinadas que tienen el paso del iterador
class IteracionDetStep < AST
    attr_accessor :identificador, :limInf, :limSup, :instrucciones, :iterador 
    
    def initialize ident, li, ls, ins, iter
        @identificador = ident
        @limInf = li
        @limSup = ls
        @instrucciones = ins
        @iterador = iter
    end
    def print_ast indent = ""
        puts "#{indent} ITERACION DETERMINADA"
        puts "#{indent}     identificador:"
        @identificador.print_ast indent + "      " if @identificador.respond_to? :print_ast

        puts "#{indent}     limite inferior:"
        @limInf.print_ast indent + "      " if @limInf.respond_to? :print_ast
        
        puts "#{indent}     limite superior:"
        @limSup.print_ast indent + "      " if @limSup.respond_to? :print_ast
    
        if @iterador.nil? == false
            puts "#{indent}     paso de iteracion:"
            @iterador.print_ast indent + "      " if @iterador.respond_to? :print_ast
        end
        @instrucciones.print_ast indent + "      " if @instrucciones.respond_to? :print_ast   
    end  

    def print_ast_tabla(tabla,indent = "")
        puts "#{indent} ITERACION DETERMINADA"
        puts "#{indent}     identificador:"
        @identificador.print_ast_tabla(tabla, indent + "    " ) if @identificador.respond_to? :print_ast

        puts "#{indent}     limite inferior:"
        @limInf.print_ast_tabla(tabla, indent + "    " )   if @limInf.respond_to? :print_ast
        
        puts "#{indent}     limite superior:"
        @limSup.print_ast_tabla(tabla, indent + "    " )  if @limSup.respond_to? :print_ast
    
        if @iterador.nil? == false
            puts "#{indent}     paso de iteracion:"
            @iterador.print_ast_tabla(tabla, indent + "    " )   if @iterador.respond_to? :print_ast
        end
        @instrucciones.print_ast_tabla(tabla, indent + "    " )  if @instrucciones.respond_to? :print_ast   
    end 

end


# Clase para las expresiones unarias
class ExpresionUnaria < AST
    attr_accessor :expresion
    
    def initialize e
        @expresion = e
    end
    def print_ast indent = ""
        puts "#{indent}     operacion: #{self.class}"
        puts "#{indent}     operador:"
        @expresion.print_ast indent + "    " if @expresion.respond_to? :print_ast    
    end
    def print_ast_tabla(tabla, indent = "") 
        puts "#{indent}     operacion: #{self.class}"
        puts "#{indent}     operador:"
        @expresion.print_ast_tabla(tabla, indent + "    " )   if @expresion.respond_to? :print_ast    
    end

end


# Expresiones Unarias Booleanas
class Not < ExpresionUnaria; end


# Expresiones Unarias Aritmeticas
class Literal < ExpresionUnaria; end
class Negativo < ExpresionUnaria; end


# Expresiones Unarias de Caracteres
class CaracterSiguiente < ExpresionUnaria; end
class CaracterAnterior < ExpresionUnaria; end
class ValorAsciiParser < ExpresionUnaria; end


# Expresiones Unarias de Arreglos
class ShiftParser < ExpresionUnaria; end


#Clase para la lectura y escritura de expresiones
class Io < AST
    attr_accessor :expresion
    
    def initialize e
        @expresion = e
    end
    def print_ast indent = ""
        if self.class == Entrada 
            puts "#{indent}LECTURA"
        end
        if self.class == Salida
            puts "#{indent}ESCRITURA" 
        end
        @expresion.print_ast indent + "    " if @expresion.respond_to? :print_ast    
    end
    def print_ast_tabla(tabla, indent = "") 
         if self.class == Entrada 
            puts "#{indent}LECTURA"
        end
        if self.class == Salida
            puts "#{indent}ESCRITURA" 
        end
        @expresion.print_ast_tabla(tabla, indent = "")  if @expresion.respond_to? :print_ast    
    end 
 
end  


# Clase para los valores a leer
class Entrada < Io; end
     

# Clase para valores a imprimir
class Salida < Io; end

 
# Clase para reglas terminales
class Terminales < AST
    attr_accessor :token
    
    def initialize t
        @token = t
    end
    def print_ast indent = ""
        if self.class == Identificador
            puts "#{indent}     expresion: VARIABLE"
             puts "#{indent}     identificador: " + @token.to_s()
        end
        if self.class == LitNum
            puts "#{indent}     expresion: LITERAL NUMERICO"
             puts "#{indent}     valor: " + @token.to_s()    
        end
        if self.class == LitChar
            puts "#{indent}     expresion: LITERAL CARACTER"
            puts "#{indent}     identificador: " + @token.to_s()
        end

         
    end

     def print_ast_tabla(tabla,indent = "")
        if self.class == Identificador
            puts "#{indent}     expresion: VARIABLE"
             puts "#{indent}     identificador: " + @token.to_s()
        end
        if self.class == LitNum
            puts "#{indent}     expresion: LITERAL NUMERICO"
             puts "#{indent}     valor: " + @token.to_s()    
        end
        if self.class == LitChar
            puts "#{indent}     expresion: LITERAL CARACTER"
            puts "#{indent}     identificador: " + @token.to_s()
        end

         
    end


end

# Tipo de literales que pueden existir en la gramatica
class Identificador < Terminales; end
class LitNum < Terminales; end
class LitChar < Terminales; end


# Clase para reglas terminales booleanas
class TerminalesBool < AST
    attr_accessor :token
    
    def initialize t
        @token = t
    end
    def print_ast indent = ""
        puts "#{indent}     contenedor: LITERAL BOOLEANO" 
        puts "#{indent}     valor: " + @token.to_s()
        
    end
    def print_ast(tabla, indent = "")
        puts "#{indent}     contenedor: LITERAL BOOLEANO" 
        puts "#{indent}     valor: " + @token.to_s()
        
    end
end


# Tipos de literales booleanos
class LitTrue < TerminalesBool; end
class LitFalse < TerminalesBool;end  
 

#Clase para los arreglos
class TipoArray < AST
    attr_accessor :dimension, :tipo
    
    def initialize  dimension, tipo
        @dimension = dimension
        @tipo = tipo
    end
    def print_ast indent = ""
        puts "#{indent}Tipo Array "
        @dimension.print_ast indent + "      " if @dimension.respond_to? :print_ast
        @tipo.print_ast indent + "      " if @tipo.respond_to? :print_ast
    end
end
