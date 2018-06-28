class TablaSimbolos
    
    attr_accessor :tabla, :padre, :hijo, :for
    
    #Funcion para inicializar una tabla de simbolos
    def initialize 
        @tabla = Hash.new
        @padre = nil
        @hijo = Array.new
        #@for = false
    end

    def asignarPadre(padre)
        @padre = padre
    end

    def asignarHijo(hijo)
        @hijo << hijo
    end
    
    def obtenerPadre()
        return @padre
    end
    
    def obtenerHijo()
        return @hijo
    end

   def insertar(identificador, tipo)
        if !@tabla.has_key?(identificador)
            @tabla[identificador] = tipo
            return true
        else
            return false
        end
    end


    def actualizar(identificador, tipo)
        if @tabla.has_key?(identificador)
            @tabla[identificador] = tipo
            return true
        else
            return false
        end
    end
    
    def contiene(identificador)
       return @tabla.has_key?(identificador) 
    end

    def buscar(identificador)
        if @tabla.has_key?(identificador)
            return @tabla[identificador]
        else
            return false
        end
    end
    
    def obtenerTabla
        return @tabla
    end

    def printTabla(indent = "")
        puts "#{indent}Tabla De Simbolos"
        indent = indent + "      "
        tabla.each do |identificador,tipo|
            puts identificador
            puts "#{indent}Nombre: #{identificador}, Tipo: #{tipo}\n" 
        end
    end
end        
   