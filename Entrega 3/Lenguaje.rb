# Lenguaje.rb
#
# Descripcion: Archivo que contiene el main usado para
# ejecutar el lexer y parser del lenguaje BasicTran
#
# Autores :  Ritces Parra   12-11088
#            Palacios Gomez 10-10870


require_relative 'Lexer'
require_relative 'Parser'  
require_relative 'crearTabla'  


#main: Procedimiento que capta el archivo a ser analizado y llama al lexer
def main
  
    ARGV[ARGV.length-1] =~ /\w+\ s/
    puts("#{ARGV[ARGV.length-1]}")
    display = ARGV
    
    #Se crea el archivo
    input = File::read(ARGV[display.length-1])
    
        #Se crea el Lexer con el archivo de entrada
        lexer = Lexer::new input
        #Se llama la funcion que lee la entrada del archivo , para luego imprimir los tokens
        lexer.leerLexer
        
       
        listaTokens = lexer.encontrado
      
        if listaTokens.nil? == false
            
            parser = Parser.new(lexer)
  
            ast = parser.parse       
   
            if ast.nil? == false
                    generador = CrearTabla.new
                    astAux = ast 
                    tablas = generador.crear(astAux)
                    if tablas.class == Array
                        tablas.each do |e|
                            puts e
                        end
                    else
                        ast.print_ast_tabla(tablas)
                    end
            end       
        end
        
end 
 
main
