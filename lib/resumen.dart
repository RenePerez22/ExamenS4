import 'package:flutter/material.dart';

class ResumenScreen extends StatelessWidget {
  final String nombre;
  final int edad;
  final String fecha;
  final String pais;
  final String ciudad;
  final double cuotaInicial;
  final double cuotaMensual;

  ResumenScreen({
    required this.nombre,
    required this.edad,
    required this.fecha,
    required this.pais,
    required this.ciudad,
    required this.cuotaInicial,
    required this.cuotaMensual,
  });

  @override
  Widget build(BuildContext context) {
    double valorFinal = cuotaInicial + (cuotaMensual * 4);

    return Scaffold(
      appBar: AppBar(title: Text('Resumen'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 4),
            ], // Sombra sutil
          ),
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información del Estudiante',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Divider(thickness: 1), // Línea separadora
              SizedBox(height: 10),

              Text(
                'Nombre: $nombre',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text('Edad: $edad años', style: TextStyle(fontSize: 16)),
              Text(
                'Fecha de inscripción: $fecha',
                style: TextStyle(fontSize: 16),
              ),
              Text('País: $pais', style: TextStyle(fontSize: 16)),
              Text('Ciudad: $ciudad', style: TextStyle(fontSize: 16)),
              Text(
                'Cuota inicial: \$${cuotaInicial.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Cuota mensual con recargo: \$${cuotaMensual.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 15),
              Divider(thickness: 1), // Otra separación visual
              SizedBox(height: 10),

              Text(
                'Valor final: \$${valorFinal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
