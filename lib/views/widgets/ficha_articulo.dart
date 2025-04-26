import 'package:flutter/material.dart';
import 'package:flutter_fingerprint2/views/widgets/valoracion.dart';

class FichaArticulo extends StatelessWidget {
  final String imagen;
  final String nombre;
  final String precio;
  final String descuento;
  final String valoracion;
  final String calificaciones;

  const FichaArticulo({
    super.key,
    required this.imagen,
    required this.nombre,
    required this.precio,
    required this.descuento,
    required this.valoracion,
    required this.calificaciones,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Artículo",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(imagen,
                  width: double.infinity, height: 250, fit: BoxFit.cover),
              SizedBox(height: 10),
              Text(
                nombre,
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${int.parse(precio) * (100 - int.parse(descuento)) ~/ 100}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (descuento != "0") ...[
                    SizedBox(height: 5),
                    Text(
                      "$descuento% OFF",
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ],
                ],
              ),
              if (descuento != "0") ... [SizedBox(height: 5),
              Text(
                "Antes \$$precio",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (int.parse(valoracion) / 10).toStringAsFixed(1),
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Valoracion(
                    rating: valoracion,
                  ),
                      Text(
                    "$calificaciones calificaciones",
                    style: TextStyle(fontSize: 16),
                  ),
                    ],
                  ),
                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
