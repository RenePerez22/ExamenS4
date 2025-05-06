import 'package:flutter/material.dart';
import 'package:flutter_examen/dataBase/database_helper.dart';
import 'package:flutter_examen/resumen.dart';

class RegistroEstudiantesScreen extends StatefulWidget {
  @override
  _RegistroEstudiantesScreenState createState() =>
      _RegistroEstudiantesScreenState();
}

class _RegistroEstudiantesScreenState extends State<RegistroEstudiantesScreen> {
  DateTime? _selectedDate;
  String? _selectedPais;
  String? _selectedCiudad;
  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();
  final _cuotaInicialController = TextEditingController();

  // Mapa con ciudades según el país seleccionado
  final Map<String, List<String>> ciudadesPorPais = {
    'Ecuador': ['Quito', 'Guayaquil', 'Cuenca'],
    'Colombia': ['Bogotá', 'Medellín', 'Cali'],
    'Perú': ['Lima', 'Arequipa', 'Cusco'],
  };

  double calcularCuotaMensual(double inicial) {
    return ((1500 - inicial) / 4) * 1.05;
  }

  void guardarEstudiante() async {
    if (_nombreController.text.isEmpty ||
        _edadController.text.isEmpty ||
        _cuotaInicialController.text.isEmpty ||
        _selectedDate == null ||
        _selectedPais == null ||
        _selectedCiudad == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    double inicial = double.parse(_cuotaInicialController.text);
    double mensual = calcularCuotaMensual(inicial);
    double valorFinal = inicial + (mensual * 4);

    final dbHelper = DatabaseHelper();
    await dbHelper.insertarEstudiante({
      'nombre': _nombreController.text,
      'edad': int.parse(_edadController.text),
      'fecha': _selectedDate.toString(),
      'pais': _selectedPais!,
      'ciudad': _selectedCiudad!,
      'cuota_inicial': inicial,
      'cuota_mensual': mensual,
      'valor_final': valorFinal,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Estudiante registrado exitosamente')),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ResumenScreen(
              nombre: _nombreController.text,
              edad: int.parse(_edadController.text),
              fecha: _selectedDate.toString(),
              pais: _selectedPais!,
              ciudad: _selectedCiudad!,
              cuotaInicial: inicial,
              cuotaMensual: mensual,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registro de Estudiantes',
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Registro de Estudiantes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),

              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),

              TextField(
                controller: _edadController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Edad',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),

              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                child: Text('Seleccionar Fecha'),
              ),
              SizedBox(height: 15),

              DropdownButton<String>(
                value: _selectedPais,
                hint: Text('Seleccione un País'),
                items:
                    ciudadesPorPais.keys
                        .map(
                          (pais) =>
                              DropdownMenuItem(value: pais, child: Text(pais)),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPais = value;
                    _selectedCiudad = null;
                  });
                },
              ),
              SizedBox(height: 10),

              if (_selectedPais != null)
                DropdownButton<String>(
                  value: _selectedCiudad,
                  hint: Text('Seleccione una Ciudad'),
                  items:
                      ciudadesPorPais[_selectedPais]!
                          .map(
                            (ciudad) => DropdownMenuItem(
                              value: ciudad,
                              child: Text(ciudad),
                            ),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => _selectedCiudad = value),
                ),
              SizedBox(height: 10),
              Text(
                'Valor del curso: 1500',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _cuotaInicialController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Cuota Inicial',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_selectedPais == null || _selectedCiudad == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Seleccione un país y una ciudad antes de continuar',
                        ),
                      ),
                    );
                  } else {
                    guardarEstudiante();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: Text(
                  'Confirmar Registro',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
