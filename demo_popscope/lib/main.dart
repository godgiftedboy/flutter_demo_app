import 'package:flutter/material.dart';
import 'package:mysample/payment_page.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const NavigatorPopHandlerApp());
}

class NavigatorPopHandlerApp extends StatelessWidget {
  const NavigatorPopHandlerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      onGenerateRoute: (RouteSettings settings) {
        return switch (settings.name) {
          '/two' => MaterialPageRoute<FormData>(
              builder: (BuildContext context) => const _PageTwo(),
            ),
          _ => MaterialPageRoute<void>(
              builder: (BuildContext context) => const _HomePage(),
            ),
        };
      },
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  FormData? _formData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Page One'),
            if (_formData != null)
              Text(
                  'Hello ${_formData!.name}, whose favorite food is ${_formData!.favoriteFood}.'),
            TextButton(
              onPressed: () async {
                var test = const FormData();
                print("test" + test.toString());
                final FormData formData =
                    await Navigator.of(context).pushNamed<FormData?>('/two') ??
                        const FormData();
                if (formData != _formData) {
                  setState(() {
                    _formData = formData;
                  });
                }
              },
              child: const Text('Next page'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> showBackDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text(
          'Are you sure you want to leave this page?',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Never mind'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Leave'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
}

class _PopScopeWrapper extends StatelessWidget {
  const _PopScopeWrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope<FormData>(
      canPop: false,
      // The result argument contains the pop result that is defined in `_PageTwo`.
      onPopInvokedWithResult: (bool didPop, FormData? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await showBackDialog(context) ?? false;
        if (context.mounted && shouldPop) {
          Navigator.pop(context, result);
        }
      },
      child: child,
    );
  }
}

// This is a PopScope wrapper over _PageTwoBody
class _PageTwo extends StatelessWidget {
  const _PageTwo();

  @override
  Widget build(BuildContext context) {
    return const _PopScopeWrapper(
      child: _PageTwoBody(),
    );
  }
}

class _PageTwoBody extends StatefulWidget {
  const _PageTwoBody();

  @override
  State<_PageTwoBody> createState() => _PageTwoBodyState();
}

class _PageTwoBodyState extends State<_PageTwoBody> {
  FormData _formData = const FormData();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     showBackDialog(context);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Page Two'),
            Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter your name.',
                    ),
                    onChanged: (String value) {
                      _formData = _formData.copyWith(
                        name: value,
                      );
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter your favorite food.',
                    ),
                    onChanged: (String value) {
                      _formData = _formData.copyWith(
                        favoriteFood: value,
                      );
                    },
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {});
              },
              child: const Text('Setstate'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.maybePop(context, _formData);
              },
              child: const Text('Go back'),
            ),
            TextButton(
              onPressed: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => UsePaypal(
                        sandboxMode: true,
                        clientId:
                            "AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0",
                        secretKey:
                            "EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9",
                        returnURL: "https://samplesite.com/return",
                        cancelURL: "https://samplesite.com/cancel",
                        transactions: const [
                          {
                            "amount": {
                              "total": '10.12',
                              "currency": "USD",
                              "details": {
                                "subtotal": '10.12',
                                "shipping": '0',
                                "shipping_discount": 0
                              }
                            },
                            "description":
                                "The payment transaction description.",
                            // "payment_options": {
                            //   "allowed_payment_method":
                            //       "INSTANT_FUNDING_SOURCE"
                            // },
                            "item_list": {
                              "items": [
                                {
                                  "name": "A demo product",
                                  "quantity": 1,
                                  "price": '10.12',
                                  "currency": "USD"
                                }
                              ],

                              // shipping address is not required though
                              "shipping_address": {
                                "recipient_name": "Jane Foster",
                                "line1": "Travis County",
                                "line2": "",
                                "city": "Austin",
                                "country_code": "US",
                                "postal_code": "73301",
                                "phone": "+00000000",
                                "state": "Texas"
                              },
                            }
                          }
                        ],
                        note: "Contact us for any questions on your order.",
                        onSuccess: (Map params) async {
                          print("onSuccess: $params");
                        },
                        onError: (error) {
                          print("onError: $error");
                        },
                        onCancel: (params) {
                          print('cancelled: $params');
                        }),
                  ),
                )
              },
              child: const Text('Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

@immutable
class FormData {
  const FormData({
    this.name = '',
    this.favoriteFood = '',
  });

  final String name;
  final String favoriteFood;

  FormData copyWith({String? name, String? favoriteFood}) {
    return FormData(
      name: name ?? this.name,
      favoriteFood: favoriteFood ?? this.favoriteFood,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is FormData &&
        other.name == name &&
        other.favoriteFood == favoriteFood;
  }

  @override
  int get hashCode => Object.hash(name, favoriteFood);

  @override
  String toString() {
    return "name: $name, FavFood: $favoriteFood";
  }
}
