// import 'package:flutter/material.dart';
// import 'package:pneumonia_diagnostic_app/Common/Widgets/button.dart';
// import 'package:pneumonia_diagnostic_app/Common/Widgets/custom_text.dart';
//
// class ReportScreen extends StatelessWidget {
//   const ReportScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const CustomText(
//           text: 'Detailed Report',
//           color: Colors.white,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: ListView(
//           children: [
//             const CustomText(
//               text: 'Diagnosis Summary:',
//               size: 20,
//             ),
//             const SizedBox(height: 8),
//             const CustomText(
//               text: 'Pneumonia detected in the left lung.',
//               size: 16,
//               color: Colors.grey,
//             ),
//             const SizedBox(height: 16),
//             const CustomText(
//               text: 'Recommendations:',
//               size: 20,
//             ),
//             const SizedBox(height: 8),
//             const CustomText(
//               text: 'Consult a specialist for further evaluation.',
//               size: 16,
//               color: Colors.grey,
//             ),
//             const SizedBox(height: 24),
//             CustomButton(
//               ontap: () {},
//               btnName: 'Download Report',
//             ),
//             const SizedBox(height: 16),
//             const Divider(),
//             const SizedBox(height: 8),
//             const CustomText(
//               text:
//                   'Note: The report is generated automatically based on the scans.',
//               size: 14,
//               color: Colors.grey,
//               align: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pneumonia_diagnostic_app/Common/Widgets/custom_text.dart';

class ReportScreen extends StatelessWidget {
  final String patientName;
  final String result;
  final String date;

  const ReportScreen({
    super.key,
    required this.patientName,
    required this.result,
    required this.date,
  });

  Future<void> _downloadReport(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Pneumonia Diagnostic Report',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('Patient Name: $patientName'),
            pw.Text('Diagnosis Result: $result'),
            pw.Text('Date: $date'),
            pw.SizedBox(height: 40),
            pw.Text('Doctor Signature: ____________________________'),
          ],
        ),
      ),
    );

    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Storage permission denied")),
        );
        return;
      }

      final output = await getExternalStorageDirectory();
      final file = File("${output!.path}/Pneumonia_Report_$date.pdf");
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF downloaded to ${file.path}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to download PDF: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diagnosis Report"),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: const Color(0xFFF3F6FD),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: "Patient: $patientName", size: 18),
            CustomText(text: "Result: $result", size: 18),
            CustomText(text: "Date: $date", size: 18),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _downloadReport(context),
                icon: const Icon(Icons.download),
                label: const Text("Download Report"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
