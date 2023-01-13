   class  Validar {

    static bool validar(List lista){
      bool estado=false;
        lista.forEach((element) {
         element.toString().isEmpty?
            estado= false:estado=true;
         
        });
        return estado;
    }
}