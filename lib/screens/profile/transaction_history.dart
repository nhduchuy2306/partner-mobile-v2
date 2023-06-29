import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:partner_mobile/models/transaction_history_model.dart';
import 'package:partner_mobile/services/transaction_service.dart';
import 'package:partner_mobile/styles/app_colors.dart';

class TransactionHistory extends StatefulWidget {
  TransactionHistory({super.key, this.userInfo});

  UserInfo? userInfo;

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  late Future<List<TransactionHistoryModel>> transactionHistorys;

  @override
  void initState() {
    super.initState();
    transactionHistorys = TransactionService.getAllTransactionHistory(
        widget.userInfo?.uid ?? "1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: FutureBuilder<List<TransactionHistoryModel>>(
        future: transactionHistorys,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(snapshot.data?[index].partnerName ?? ""),
                    subtitle: Text(snapshot.data?[index].description ?? ""),
                    trailing: Text(
                        '\$${snapshot.data?[index].amount?.toStringAsFixed(0)}' ??
                            ""),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
