import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:partner_mobile/models/customer_membership.dart';
import 'package:partner_mobile/models/raise_recharge_wallet.dart';
import 'package:partner_mobile/screens/widgets/loading_screen_widget.dart';
import 'package:partner_mobile/services/raise_recharge_service.dart';
import 'package:partner_mobile/styles/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerWallet extends StatefulWidget {
  CustomerWallet({super.key, this.userInfo, this.customerMemberShips});

  UserInfo? userInfo;
  Future<CustomerMemberShip>? customerMemberShips;

  @override
  State<CustomerWallet> createState() => _CustomerWalletState();
}

class _CustomerWalletState extends State<CustomerWallet> {
  final TextEditingController _amountController = TextEditingController();
  int _selectedWallet = 0;

  @override
  void initState() {
    super.initState();
    _selectedWallet = 0;
  }

  setSelectedWallet(int index) {
    setState(() {
      _selectedWallet = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Wallet'),
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
        ),
        body: Container(
          margin: const EdgeInsets.all(12),
          child: FutureBuilder<CustomerMemberShip>(
              future: widget.customerMemberShips,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.walletList!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title:
                                Text(snapshot.data!.walletList![index].type!),
                            subtitle: Text(
                                '\$${snapshot.data!.walletList![index].balance!.toStringAsFixed(0)}'),
                            trailing: Text(
                                '\$${snapshot.data!.walletList![index].totalReceipt!.toStringAsFixed(0)}'),
                          ),
                        );
                      });
                } else if (snapshot.hasError) {
                  return const Text('Error');
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
        bottomNavigationBar: TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('Recharge',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      content: StatefulBuilder(
                        builder: (context, setState) {
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FutureBuilder<CustomerMemberShip>(
                                  future: widget.customerMemberShips,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final list = snapshot.data!.walletList!;
                                      return ListBody(
                                        children: list
                                            .map((e) => RadioListTile(
                                                  title: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(e.type!),
                                                      Text(
                                                          '\$${e.balance!.toStringAsFixed(0)}'),
                                                    ],
                                                  ),
                                                  value: e.id,
                                                  groupValue: _selectedWallet,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _selectedWallet =
                                                          value as int;
                                                    });
                                                  },
                                                  selected:
                                                      _selectedWallet == e.id,
                                                ))
                                            .toList(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text('Error');
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter amount',
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () async {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              final String? fcmToken =
                                  prefs.getString('fcmToken');
                              RaiseWallet raiseWallet = RaiseWallet(
                                  customerId: "1",
                                  amount: double.parse(_amountController.text),
                                  description: 'Recharge wallet',
                                  token: fcmToken,
                                  walletId: _selectedWallet);
                              await RaiseRechargeService.raiseRechargeRequest(
                                  raiseWallet);

                              Future.delayed(const Duration(seconds: 2), () {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return const CircularProgressIndicator();
                                    });
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) =>
                                        const LoadingScreenWidget()));
                              });
                            },
                            child: const Text('Recharge')),
                      ],
                    );
                  });
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primaryColor,
              ),
              child: const Center(
                child: Text(
                  'Recharge more money',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            )));
  }
}
