class Validar {
  static bool validar(List lista) {
    bool estado = false;
    for (var element in lista) {
      element.toString().isEmpty ? estado = false : estado = true;
    }
    return estado;
  }
}
