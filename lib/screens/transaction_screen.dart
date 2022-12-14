import 'package:client/models/transaction_model.dart';
import 'package:client/models/user_model.dart';
import 'package:client/networking/add_user.dart';
import 'package:client/networking/fetch_transactions.dart';
import 'package:client/networking/fetch_user.dart';
import 'package:client/screens/add_transaction_screen.dart';
import 'package:client/store/transaction_data.dart';
import 'package:client/store/user_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../widgets/loading_indicator.dart';
import '../widgets/transactions_list.dart';

var randomUuidGen = const Uuid().v4;

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final storage =
      LocalStorage('my_data.json'); //local storage used to store uuid

  bool transactionIsLoading = false;
  String sortingCriteria = "Sort by amount H-L";
  String filterCriteria = "all";

  void updateTransactionsIsLoading(bool value) {
    setState(() {
      transactionIsLoading = value;
    });
  }

  @override
  void initState() {
    super.initState();

    storage.ready.then((_) async {
      dynamic localUuid = storage.getItem("uuid");

      final userSlice = Provider.of<UserData>(context, listen: false);

      //create a user if no user exists for the specific instance of the app
      if (localUuid == null) {
        try {
          User user = await createUserOnServer(uuid: randomUuidGen());

          storage.setItem("uuid", user.uuid);

          userSlice.setUserData(user);
        } catch (e) {
          rethrow;
        }
      } else {
        //fetch the user whose uuid is stored in the local storage
        try {
          User user = await fetchUser(uuid: localUuid);

          userSlice.setUserData(user);
        } catch (e) {
          rethrow;
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    void fetchTransactionsSideEffect() async {
      final userSlice = Provider.of<UserData>(context, listen: false);

      final transactionSlice =
          Provider.of<TransactionsData>(context, listen: false);

      //fetch transactions for the user
      try {
        String? userId = userSlice.id;

        if (userId != null) {
          updateTransactionsIsLoading(true);
          List<Transaction> transactions = await fetchTransactions(
            userId: userId,
            filter: filterCriteria,
            sort: sortingCriteria,
          );
          transactionSlice.setTransactions(transactions);
          updateTransactionsIsLoading(false);
        }
      } catch (e) {
        rethrow;
      }
    }

    fetchTransactionsSideEffect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              left: 30.0,
              right: 30.0,
              bottom: 30.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const CircleAvatar(
                  radius: 50.0,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      FontAwesomeIcons.moneyBillTransfer,
                      size: 40.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                  'Hello,',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                  ),
                ),
                const Text(
                  'Swadesh',
                  style: TextStyle(
                    color: Color(0xFFEB1555),
                    fontSize: 50.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30.0,
                    horizontal: 5,
                  ),
                  child: Text(
                    "Balance: \$ ${Provider.of<UserData>(context).balance ?? 0}",
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DropdownButton(
                      value: sortingCriteria,
                      style: const TextStyle(
                        color: Color(0xFFEB1555),
                        fontSize: 18,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Sort by amount H-L",
                          child: Text("Sort by amount H-L"),
                        ),
                        DropdownMenuItem(
                          value: "Sort by amount L-H",
                          child: Text("Sort by amount L-H"),
                        ),
                        DropdownMenuItem(
                          value: "Sort by date L-H",
                          child: Text("Sort by date L-H"),
                        ),
                        DropdownMenuItem(
                          value: "Sort by date H-L",
                          child: Text("Sort by date H-L"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          sortingCriteria = value.toString();
                          didChangeDependencies();
                        });
                      },
                    ),
                    DropdownButton(
                      value: filterCriteria,
                      style: const TextStyle(
                        // color: Color(0xFFEB1555),
                        fontSize: 18,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "credit",
                          child: Text("Credit"),
                        ),
                        DropdownMenuItem(
                          value: "debit",
                          child: Text("Debit"),
                        ),
                        DropdownMenuItem(
                          value: "transfer",
                          child: Text("Transfer"),
                        ),
                        DropdownMenuItem(
                          value: "all",
                          child: Text("All"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          filterCriteria = value.toString();
                          didChangeDependencies();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF1D1E33),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: transactionIsLoading
                  ? const LoadingIndicator()
                  : TransactionsList(
                      updateTransactionLoadingFlag: updateTransactionsIsLoading,
                      filterCriteria: filterCriteria,
                      sortingCriteria: sortingCriteria,
                    ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context)
                      .viewInsets
                      .bottom, //ui sits on top of keyboard
                ),
                child: const AddTransactionScreen(),
              ),
            ),
          );
        },
        child: const Icon(
          FontAwesomeIcons.plus,
          size: 20.0,
        ),
      ),
    );
  }
}
