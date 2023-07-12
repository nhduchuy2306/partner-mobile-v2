import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:partner_mobile/models/customer_membership.dart';
import 'package:partner_mobile/models/wallet.dart';
import 'package:partner_mobile/screens/profile/add_wallet_success.dart';
import 'package:partner_mobile/services/customer_membership_service.dart';
import 'package:partner_mobile/services/wallet_service.dart';

class WalletManagement extends StatefulWidget {
  WalletManagement({super.key, this.userInfo, this.customerMemberShips});

  UserInfo? userInfo;
  Future<CustomerMemberShip>? customerMemberShips;

  @override
  State<WalletManagement> createState() => _WalletManagementState();
}

class _WalletManagementState extends State<WalletManagement> {
  Set<int> walletType = {};
  late Future<List<WalletModel>>? walletList;
  int _selectedWallet = 0;
  int memberShipId = 0;

  @override
  void initState() {
    super.initState();
    _selectedWallet = 0;

    widget.customerMemberShips?.then((value) {
      value?.walletList?.forEach((element) {
        walletType.add(element.typeId ?? 0);
      });
      memberShipId = value?.membership?.id ?? 0;
    });

    walletList = WalletService.getAllWallet();
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
          title:
              const Text('Add Wallet', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(12),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Wallet Type",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              FutureBuilder<List<WalletModel>>(
                future: walletList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // get all wallet type except wallet in walletType
                    final walletList = snapshot.data?.where((element) {
                      return !walletType.contains(element.id);
                    }).toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: walletList!.length,
                      itemBuilder: (context, index) {
                        final item = walletList![index];
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
                            title: Text(item.type ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  item.description ?? "",
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            await openDialogRecharge();
            setState(() {
              widget.customerMemberShips =
                  CustomerMemberShipService.getCustomerMemberShipById(
                      widget.userInfo!.uid!);
              widget.customerMemberShips?.then((value) {
                value?.walletList?.forEach((element) {
                  walletType.add(element.typeId ?? 0);
                });
                memberShipId = value?.membership?.id ?? 0;
              });
              walletList = WalletService.getAllWallet();
            });
          },
          child: const Text("Add Wallet"),
        ),
      ),
    );
  }

  Future openDialogRecharge() => showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Add Wallet',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder<List<WalletModel>>(
                      future: walletList,
                      builder: (context, snapshot) {
                        // get all wallet type except wallet in walletType
                        final walletList = snapshot.data?.where((element) {
                          return !walletType.contains(element.id);
                        }).toList();

                        if (snapshot.hasData) {
                          final list = walletList ?? [];
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

                  await WalletService.createWallet(
                      memberShipId, _selectedWallet);

                  Future.delayed(const Duration(seconds: 2), () async {
                    Navigator.pop(context); //pop dialog
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddWalletSuccess()),
                        (route) => false);
                  });
                },
                child: const Text('Add')),
          ],
        );
      });
}
