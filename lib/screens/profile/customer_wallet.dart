import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:partner_mobile/models/customer_membership.dart';
import 'package:partner_mobile/models/raise_recharge_wallet.dart';
import 'package:partner_mobile/provider/payment_wallet_provider.dart';
import 'package:partner_mobile/screens/profile/payment_success.dart';
import 'package:partner_mobile/services/customer_membership_service.dart';
import 'package:partner_mobile/services/momo_service.dart';
import 'package:partner_mobile/styles/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool paymentCompleted = false;

  @override
  void initState() {
    super.initState();
    _selectedWallet = 0;
    widget.customerMemberShips =
        CustomerMemberShipService.getCustomerMemberShipById(
            widget.userInfo!.uid!);
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
          title: const Text('My Wallet', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(12),
            child: FutureBuilder<CustomerMemberShip>(
                future: widget.customerMemberShips,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.walletList!.length,
                        itemBuilder: (context, index) {
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
                              expandedAlignment: Alignment.centerLeft,
                              childrenPadding: const EdgeInsets.all(12),
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data!.walletList![index].type!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '\$${snapshot.data!.walletList![index].balance!.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                Text(
                                  'Total Receipt: \$${snapshot.data!.walletList![index].totalReceipt!.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Total Expenditure: \$${snapshot.data!.walletList![index].totalExpenditure!.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Date Created: ${snapshot.data!.walletList![index].dateCreated}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
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
        ),
        bottomNavigationBar: Row(
          children: [
            TextButton(
                onPressed: () async {
                  await openDialogRecharge();
                  setState(() {
                    widget.customerMemberShips =
                        CustomerMemberShipService.getCustomerMemberShipById(
                            widget.userInfo!.uid!);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryColor,
                  ),
                  child: const Center(
                    child: Text(
                      'Recharge money',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )),
            TextButton(
                onPressed: () async {
                  await openDialogMoMo();
                  Future.delayed(const Duration(seconds: 1), () {
                    context.read<PaymentWalletProvider>().clear();
                  });
                  setState(() {
                    widget.customerMemberShips =
                        CustomerMemberShipService.getCustomerMemberShipById(
                            widget.userInfo!.uid!);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.pink,
                  ),
                  child: const Center(
                    child: Text(
                      'MoMo Transfer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )),
          ],
        ));
  }

  Future openDialogRecharge() => showDialog(
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
                                            CrossAxisAlignment.start,
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
                                          _selectedWallet = value as int;
                                        });
                                      },
                                      selected: _selectedWallet == e.id,
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
                // show loading indicator
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Loading"),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  final String? fcmToken = prefs.getString('fcmToken');
                  RaiseWallet raiseWallet = RaiseWallet(
                      customerId: widget.userInfo!.uid,
                      amount: double.parse(_amountController.text),
                      description: 'Recharge wallet',
                      token: fcmToken,
                      walletId: _selectedWallet);

                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pop(context); //pop dialog
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentSuccess(
                                  raiseWallet: raiseWallet,
                                )),
                        (route) => false);
                  });
                },
                child: const Text('Recharge')),
          ],
        );
      });

  Future openDialogMoMo() => showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('MoMo Transfer',
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
                                              CrossAxisAlignment.start,
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
                                            _selectedWallet = value as int;
                                          });
                                        },
                                        selected: _selectedWallet == e.id,
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
                child: const Text('Cancel'),
              ),
              Consumer<PaymentWalletProvider>(
                  builder: (context, paymentProvider, child) {
                return TextButton(
                    // show loading indicator
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Loading"),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                      String? payUrl = await MoMoService.getPayUrl(
                          int.parse(_amountController.text) * 23000);
                      _launchUrl(payUrl!);

                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final String? fcmToken = prefs.getString('fcmToken');
                      RaiseWallet raiseWallet = RaiseWallet(
                          customerId: widget.userInfo!.uid,
                          amount: double.parse(_amountController.text),
                          description: 'Recharge wallet',
                          token: fcmToken,
                          walletId: _selectedWallet);

                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.pop(context); //pop dialog

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentSuccess(
                                      raiseWallet: raiseWallet,
                                    )),
                            (route) => false);
                      });
                    },
                    child: const Text('MoMo Transfer'));
              })
            ],
          );
        },
      );

  void _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
