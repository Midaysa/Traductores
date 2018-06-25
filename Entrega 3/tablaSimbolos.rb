class TablaSimbolos
    
    attr_accessor :tabla, :padre, :hijo
    
    def initialize 
        @tabla = Hash.new
        @padre = nil

    def asignarPadre(padre)
        @padre = padre
    end
    
    def obtenerPadre()
        return @padre
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


$tablaInicial = TablaSimbolos.new

class crearTabla
    
    def crear(arbol)
        @arbol = arbol
        verificarBloque(@arbol.bloque, $tablaInicial)
    end
   
    def  verificarBloque(bloque, tablaActual)
       nuevaTabla = TablaSimbolos.new
       nuevaTabla.asignarPadre(tablaActual)
       
        if !bloque.declaraciones.nil?
            bloque.declaraciones do |d|
                verificarDeclaracion(d, tablaActual) 
            end
        end
        
        verificarInstrucciones(bloque.instrucciones, tablaActual)
       
    end

end
