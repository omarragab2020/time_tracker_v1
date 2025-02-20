// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class LeaveRequestsListScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("طلبات الإجازة السابقة")),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: fetchLeaveRequests(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text("❌ لا توجد طلبات إجازة"));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 var request = snapshot.data![index];
//                 return Card(
//                   child: ListTile(
//                     title: Text("🚀 طلب #${request['id']}"),
//                     subtitle: Text("📅 من: ${request['From']} - إلى: ${request['To']}"),
//                     trailing: Text("📌 الحالة: ${request['Status']}"),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
