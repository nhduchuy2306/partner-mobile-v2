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
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                final itemColor =
                    item?.type == "true" ? Colors.green : Colors.red;
                final itemIcon = item?.type == "true"
                    ? Text("Income", style: TextStyle(color: itemColor))
                    : Text("Expense", style: TextStyle(color: itemColor));
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ExpansionTile(
                      title: itemIcon,
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item?.description ?? ""),
                          Text(item?.dateCreated ?? ""),
                        ],
                      ),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          // Ensure the ListView takes only the necessary space
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: item.transactionList!.length,
                          itemBuilder: (context, index) {
                            final itemTransaction =
                                item.transactionList![index];
                            final colorTransaction =
                                itemTransaction?.type == "true"
                                    ? Colors.green
                                    : Colors.red;
                            return ListTile(
                              title: Text(itemTransaction?.wallet ?? ""),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(itemTransaction?.description ?? ""),
                                  Text(itemTransaction?.dateCreated ?? ""),
                                ],
                              ),
                              trailing: Text(
                                '\$${itemTransaction?.amount?.toStringAsFixed(0)}' ??
                                    "",
                                style: TextStyle(color: colorTransaction),
                              ),
                            );
                          },
                        ),
                      ]),
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

class TransactionList extends StatefulWidget {
  TransactionList({super.key, this.transactionList});

  List<Transaction>? transactionList;

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.transactionList!.length,
      itemBuilder: (context, index) {
        final itemTransaction = widget.transactionList![index];
        print(itemTransaction);
        final color =
            itemTransaction?.type == "true" ? Colors.green : Colors.red;
        return ListTile(
          title: Text(itemTransaction?.wallet ?? ""),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(itemTransaction?.description ?? ""),
              Text(itemTransaction?.dateCreated ?? ""),
            ],
          ),
          trailing: Text(
            '\$${itemTransaction?.amount?.toStringAsFixed(0)}' ?? "",
            style: TextStyle(color: color),
          ),
        );
      },
    );
  }
}
