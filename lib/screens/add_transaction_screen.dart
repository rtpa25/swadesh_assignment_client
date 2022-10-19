import 'package:client/store/transaction_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';
import '../models/user_model.dart';
import '../networking/add_transaction.dart';
import '../networking/fetch_user.dart';
import '../store/user_data.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String transactionType = "credit";

  String transactionAmount = "";

  final _text = TextEditingController();
  bool _validate = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> addTransactionHandler() async {
    final transactionSlice =
        Provider.of<TransactionsData>(context, listen: false);
    final userSlice = Provider.of<UserData>(context, listen: false);

    final navigator = Navigator.of(context);

    String? userId = Provider.of<UserData>(context, listen: false).id;

    Transaction newTransaction = await createTransactionOnServer(
      userId: userId!,
      transactionAmount: transactionAmount,
      transactionType: transactionType,
    );

    transactionSlice.addTransaction(newTransaction);

    if (newTransaction.status != "cancelled") {
      User user = await fetchUser(uuid: userSlice.uuid!);
      userSlice.setUserData(user);
    }

    navigator.pop();
  }

  void handleInputStateChange(String value) {
    setState(() {
      if (value.isEmpty) {
        _validate = true;
      } else if (double.parse(value) < 0) {
        _validate = true;
      } else if (double.parse(value) > 10000) {
        _validate = true;
      } else {
        _validate = false;
      }
      transactionAmount = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 13, 10, 46),
      child: Container(
        padding: const EdgeInsets.all(30.0),
        decoration: const BoxDecoration(
          color: Color(0xFF0A0E21),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              "Add Transaction",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFEB1555),
                fontSize: 30.0,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: _text,
              decoration: InputDecoration(
                errorText: _validate ? 'invalid value' : null,
                hintText: "Enter your amount",
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Color(0xFFEB1555),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Color(0xFFEB1555),
                  ),
                ),
              ),
              autofocus: true,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              autocorrect: true,
              onChanged: handleInputStateChange,
            ),
            const SizedBox(
              height: 20.0,
            ),
            DropdownButton(
              value: transactionType,
              style: const TextStyle(
                color: Color(0xFFEB1555),
                fontSize: 18,
              ),
              items: const [
                DropdownMenuItem(
                  value: "credit",
                  child: Text("credit"),
                ),
                DropdownMenuItem(
                  value: "debit",
                  child: Text("debit"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  transactionType = value!;
                });
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: addTransactionHandler,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFEB1555),
                padding: const EdgeInsets.all(20),
              ),
              child: const Text(
                "Add",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
