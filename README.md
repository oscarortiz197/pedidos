# pedidos

Aplicación: App de pedidos 

1-	Objetivos de la app: 
-	Tener una base de datos de los productos que se comercializan 
Por ejemplo: 

cod	~ descripcion ~	Costo ~	Precio de venta 
			

-	Ser capaz de almacenar los pedidos contando para ello con una tabla (o más) en la base de datos adecuada, algunos elementos de información que será necesario almacenar para cada pedido son: nombre del cliente, en detalle de los productos que el cliente ha pedido y las cantidades para cada uno. 

-	Realizar un pedido destinado al proveedor para poder comprar todos los productos y cantidades que los clientes hayan encargado que se pueda compartir por whatsapp un PDF

-	Exportar la información de los pedidos tomados para un evento(el día de entrega) en formato txt o por mensaje atravez de whatsap 

-	Crud para productos 

-	Crud para pedidos 

2-	Análisis de mercado 
No aplica, la aplicación es para practica y será usada solo por un usuario, sin embargo, la aplicación será usada en la vida real con datos reales por lo que en el futuro podría ser comercializada y en el rubro del comercio de mercancías

3-	Definición de alcance 
Uso cotidiano para toma de pedidos y cálculo de pedido al proveedor 

4-	Interfaz de usuario 
 flujo 1:  listado de entregas - listado de pedidos entrega - detalle de pedido desplazable 
 <img src="lib/imagenes_repositorio/listado_entrega.jpeg" alt="listado de entregas" width="187" height="400">
 <img src="lib/imagenes_repositorio/pedidos_entrega.jpeg" alt="listado de pedidos entrega " width="187" height="400">
 <img src="lib/imagenes_repositorio/detalle_pedido_desplazable.jpeg" alt="detalle de pedido desplazable" width="187" height="400">



 flujo 2: listado de pedidos - listado de productos para toma de pedido - confirmacion y detallar nombre de cliente
  <img src="lib/imagenes_repositorio/listado_pedidos.jpeg" alt="listado de pedidos" width="187" height="400">
 <img src="lib/imagenes_repositorio/producto_pedido.jpeg" alt=" listado de productos para toma de pedido " width="187" height="400">
 <img src="lib/imagenes_repositorio/pantalla_confirmacion.jpeg" alt="confirmacion y detallar nombre de cliente" width="187" height="400">
<br>
 flujo 3: listado de productos para administracion - eliminar con alerta - ver y/o editar informacion del producto: nombre, precio, costo
 <br>
<img src="lib/imagenes_repositorio/administracion_producto.jpeg" alt="administracion_producto" width="187" height="400"> <img src="lib/imagenes_repositorio/detalle_productpo.jpeg" alt="detalle_productpo" width="187" height="400">

5-	Recopilación de requerimientos técnicos 
-	Editor de código: visual studio code 
-	Base de datos: es necesario almacenar datos de manera local SQLite
-	Lenguaje de programación: dart, flutter



## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
