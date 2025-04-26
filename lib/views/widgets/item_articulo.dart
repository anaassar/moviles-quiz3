import 'package:flutter/material.dart';

import 'valoracion.dart';

class ItemArticulo extends StatelessWidget {
  final String imagen;
  final String nombre;
  final String precio;
  final String descuento;
  final String valoracion;
  final String calificaciones;

  const ItemArticulo({
    super.key,
    required this.imagen,
    required this.nombre,
    required this.precio,
    required this.descuento,
    required this.valoracion, required this.calificaciones,
  });

  int calcularPrecioFinal(String precio, String descuento) {
    int precioO = int.tryParse(precio) ?? 0;
    int descuentoPorcentaje = int.tryParse(descuento.trim()) ?? 0;

    if (descuentoPorcentaje == 0) return precioO;

    return precioO * (100 - descuentoPorcentaje) ~/ 100;
  }

  @override
  Widget build(BuildContext context) {

    final precioFinal = calcularPrecioFinal(precio, descuento);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imagen,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                        "\$${precioFinal.toString()}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (descuento != "0")
                      Text(
                        "$descuento% OFF",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
                Valoracion(
                  rating: valoracion,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
