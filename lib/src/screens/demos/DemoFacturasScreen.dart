// import 'package:blim/src/core/models/Factura.dart';
// import 'package:blim/src/core/structures/MList.dart';
// import 'package:blim/src/core/utils.dart';
// import 'package:blim/src/providers/Facturas.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';

// class DemoFacturasScreen extends StatefulWidget {
//   @override
//   _DemoScreenState createState() => _DemoScreenState();
// }

// class _DemoScreenState extends State<DemoFacturasScreen> {
//   Facturas facturas = Facturas();
//   MList<Factura> _facturas = MList<Factura>();
//   Factura tmpFactura = Factura();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('BLIM: Factura'),
//       ),
//       body: Container(
//         margin: EdgeInsets.only(left: 32, right: 32, top: 24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Form(
//                 child: Column(
//               children: [
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Usuario'),
//                   onChanged: (value) {
//                     setState(() {
//                       tmpFactura.userId = value;
//                     });
//                   },
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Monto'),
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       tmpFactura.monto = double.tryParse(value);
//                     });
//                   },
//                 ),
//               ],
//             )),
//             SizedBox(height: 12),
//             ElevatedButton(
//               child: Text('Agregar factura'),
//               onPressed: () async {
//                 tmpFactura = await facturas.agregar(tmpFactura.clone());
//                 setState(() {
//                   _facturas.add(tmpFactura.clone());
//                 });
//               },
//             ),
//             SizedBox(height: 12),
//             Text('Facturas',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _facturas.length,
//                 itemBuilder: (context, int index) {
//                   Factura f = _facturas[index];
//                   return ListTile(
//                     title: Text(f.userId ?? ''),
//                     subtitle: Text(f.id ?? ''),
//                     trailing: IconButton(
//                         onPressed: () async {
//                           await facturas.eliminar(f);
//                           setState(() {
//                             _facturas.remove(f);
//                           });
//                         },
//                         icon: Icon(Icons.close)),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
