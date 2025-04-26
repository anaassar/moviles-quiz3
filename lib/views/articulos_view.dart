import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_fingerprint2/views/widgets/ficha_articulo.dart';
import 'package:flutter_fingerprint2/views/widgets/item_articulo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ListaArticulos extends StatefulWidget {
  final bool soloOfertas;

  const ListaArticulos({super.key, this.soloOfertas = false});

  @override
  _ListaArticulosState createState() => _ListaArticulosState();
}

class _ListaArticulosState extends State<ListaArticulos> {
  Future<List<ItemArticulo>> _consultarArticulos() async {
    String sUrl = "https://q3821230-3000.use.devtunnels.ms";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("jwt");

      if (token == null) return [];

      final oRespuesta = await http.get(
        Uri.parse('$sUrl/api/articulos'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (oRespuesta.statusCode != 200) return [];

      dynamic oJsonDatos = jsonDecode(utf8.decode(oRespuesta.bodyBytes));
      List aItems = oJsonDatos;
      List<ItemArticulo> awItems = [];

      for (var articulo in aItems) {
        String descuento = articulo["Descuento"].toString();

        if (widget.soloOfertas && (descuento == "0" || descuento == "0.0")) {
          continue;
        }

        awItems.add(
          ItemArticulo(
            imagen:
                "https://f.rpp-noticias.io/2019/02/22/756457descarga-1jpg.jpg",
            nombre: articulo["Articulo"] ?? "Sin nombre",
            precio: articulo["Precio"].toString(),
            descuento: descuento,
            valoracion: articulo["Valoracion"].toString(),
            calificaciones: articulo["Calificaciones"].toString(),
          ),
        );
      }

      return awItems;
    } catch (e) {
      print("Error al obtener los datos: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.soloOfertas ? "Ofertas" : "Artículos",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: widget.soloOfertas ? Colors.redAccent : Colors.blue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),

        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<List<ItemArticulo>>(
            future: _consultarArticulos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error al cargar los datos"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No hay datos disponibles"));
              } else {
                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => FichaArticulo(
                                  imagen: snapshot.data![index].imagen,
                                  nombre: snapshot.data![index].nombre,
                                  precio: snapshot.data![index].precio,
                                  descuento: snapshot.data![index].descuento,
                                  valoracion: snapshot.data![index].valoracion,
                                  calificaciones:
                                      snapshot.data![index].calificaciones,
                                ),
                          ),
                        );
                      },
                      child: snapshot.data![index],
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
