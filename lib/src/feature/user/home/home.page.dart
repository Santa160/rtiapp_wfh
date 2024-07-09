import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:rtiapp/src/common/extentions/extention.dart';
import 'package:rtiapp/src/common/header_footer_wrapper.dart';
import 'package:rtiapp/src/common/utils/filepicker.helper.dart';
import 'package:rtiapp/src/core/app_config.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/feature/user/home/pages/rti_view.view.dart';
import 'package:rtiapp/src/feature/user/home/widget/popups/term_and_conditions.dart';
import 'package:rtiapp/src/feature/user/home/service/rti.service.dart';
import 'package:rtiapp/src/feature/user/home/pages/rti.table.view.dart';
import 'package:rtiapp/src/feature/user/home/widget/dropdowns/pia.dropdown.dart';
import 'package:rtiapp/src/initial-setup/initial_setup.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activeTab = "Home";
  // List to store TextEditingControllers for each TextFormField
  List<TextEditingController> controllers = [];

  Map<String, dynamic> paymentOption = {};

  // GlobalKey to access the form
  final _formKey = GlobalKey<FormState>();

  bool isPaymentFailed = false;

  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    InitialSetup.queryStatus();
    InitialSetup.status();
    addField();
  }

  void openCheckout() async {
    try {
      _razorpay.open(paymentOption);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  late Razorpay _razorpay;

  Map<String, dynamic>? _selectedPia;
  FilePickerModel? _file;

  String rtiId = "0";

  // Method to create a new TextFormField
  Widget createTextFormField(TextEditingController controller, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        key: UniqueKey(),
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () {
                controllers.removeAt(count);
                setState(() {});
              },
              icon: const Icon(Icons.close)),
          border: const OutlineInputBorder(),
          labelText: 'Enter Your Query',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    var order = {
      "razorpay_order_id": response.orderId,
      "razorpay_payment_id": response.paymentId,
      "razorpay_signature": response.signature
    };

    var service = RTIService();
    var res = await service.confirmPayment(order);
    if (res['success']) {
      controllers.clear();
      addField();
      isPaymentFailed = false;
      paymentOption.clear();
      errorMsg = '';
      EasyLoading.dismiss();
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            AppBtn.outline(
              "Okay",
              onPressed: () {
                activeTab = "Home";
                setState(() {});
                Navigator.pop(context);
              },
            )
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Success",
                style: TextStyle(
                  color: KCOLOR.success,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(10),
              const Text(
                "You have successfully submitted your RTI Application",
                style: TextStyle(fontSize: 20),
              ),
              const Gap(10),
              const Text(
                "Your RTI application number is",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "${res["data"]["rti_no"]}",
                style: const TextStyle(fontSize: 30, color: KCOLOR.brand),
              ),
              const Gap(10),
            ],
          ),
        );
      },
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    EasyLoading.dismiss();
    isPaymentFailed = true;
    errorMsg = "${response.message}";
    setState(() {});
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    EasyLoading.showInfo(
      "EXTERNAL_WALLET: ${response.walletName!}",
    );
  }

  // Method to add a new field to the form
  void addField() {
    setState(() {
      final controller = TextEditingController();
      controllers.add(controller);
    });
  }

  // Method to handle form submission
  void handleSubmit(context) async {
    if (_selectedPia == null) {
      EasyLoading.showInfo("Please select pia");
    } else if (_formKey.currentState!.validate()) {
      var loQ = controllers
          .map(
            (e) => e.text,
          )
          .toList();

      var service = RTIService();

      EasyLoading.show(status: "Please wait");

      var res =
          await service.createRTI(loQ, _file, _selectedPia!["id"].toString());
      if (res["success"]) {
        if (res['data']['order'].toString() == 'null') {
          EasyLoading.dismiss();

          activeTab = 'Home';
          setState(() {});
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actions: [
                  AppBtn.outline(
                    "Okay",
                    onPressed: () {
                      activeTab = "Home";
                      setState(() {});
                      Navigator.pop(context);
                    },
                  )
                ],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Success",
                      style: TextStyle(
                        color: KCOLOR.success,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(10),
                    const Text(
                      "You have successfully submitted your RTI Application",
                      style: TextStyle(fontSize: 20),
                    ),
                    const Gap(10),
                    const Text(
                      "Your RTI application number is",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "${res["data"]["rti_no"]}",
                      style: const TextStyle(fontSize: 30, color: KCOLOR.brand),
                    ),
                    const Gap(10),
                  ],
                ),
              );
            },
          );
        } else {
          setState(() {
            paymentOption = res['data']['order'];
          });
          openCheckout();
        }
      }
    }
  } // Method to handle form submission

  @override
  Widget build(BuildContext context) {
    var mw = MediaQuery.of(context).size.width;
    return HeaderFooterWrapper(
        child: Column(
      children: [
        _pageHeader(context, mw),
        Column(
          children: [
            Visibility(
                visible: activeTab == "View",
                child: RTIViewPage(
                  onBackTab: () {
                    activeTab = "Home";
                    controllers.clear();
                    addField();
                    setState(() {});
                  },
                  rtiId: rtiId,
                )),
            const Gap(10),
            Visibility(
                visible: activeTab == "Home",
                child: RTITableView(
                  onApplyTab: () {
                    activeTab = "Apply RTI";
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return TermAndConditions(
                          onCancel: () {
                            setState(() {
                              activeTab = "Home";
                            });
                          },
                        );
                      },
                    );
                    setState(() {});
                  },
                  onViewTab: (data) {
                    setState(() {
                      activeTab = "View";
                      rtiId = data["id"];
                    });
                  },
                )),
            Visibility(
              visible: activeTab == "Apply RTI",
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(5),
                    const AppText.heading(
                      'Apply RTI Request',
                      color: KCOLOR.brand,
                    ),
                    const Gap(10),
                    PiaDropdownForm(
                      pia: (pia) {
                        logger.d(pia);
                        setState(() {
                          _selectedPia = pia;
                        });
                      },
                      file: (file) {
                        setState(() {
                          _file = file;
                        });
                      },
                    ),
                    const Gap(5),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: controllers.length,
                      itemBuilder: (context, index) {
                        return createTextFormField(controllers[index], index);
                      },
                    ),
                    const Gap(5),
                    TextButton.icon(
                        icon: const Icon(Icons.add),
                        onPressed: addField,
                        label: const Text("Add more questions")),
                    const Gap(5),
                    if (errorMsg.isNotEmpty)
                      Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: KCOLOR.danger.withOpacity(0.03),
                            border: const Border(
                              left: BorderSide(color: KCOLOR.danger, width: 2),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const AppText.subheading("Payment Failed!",
                                      color: KCOLOR.danger),
                                  AppText.smallText(errorMsg),
                                  const AppText.smallText(
                                      "Try after sometime or click pay to continue try again"),
                                  const Gap(10)
                                ],
                              ).addPadding(bottom: 10),
                            ],
                          )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: const ButtonStyle(
                                foregroundColor:
                                    WidgetStatePropertyAll(Colors.white),
                                backgroundColor:
                                    WidgetStatePropertyAll(KCOLOR.brand)),
                            onPressed: () {
                              handleSubmit(context);
                              // openCheckout();
                            },
                            child: const Text("Submit")),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ).addPadding(left: 50, right: 50),
      ],
    ));
  }

  _pageHeader(BuildContext context, double mw) {
    return Container(
      color: KCOLOR.brand,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              activeTab = "Home";
              paymentOption.clear();

              errorMsg = '';
              setState(() {});
            },
            child: Container(
              color: Colors.white.withOpacity(activeTab == "Home" ? 0.2 : 0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Home",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                        )),
              ),
            ),
          ),
          const Gap(20),
          InkWell(
            onTap: () {
              activeTab = "Apply RTI";
              // _formKey.currentState!.reset();

              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return TermAndConditions(
                    onCancel: () {
                      setState(() {
                        activeTab = "Home";
                      });
                    },
                  );
                },
              );
              setState(() {});
            },
            child: Container(
              color:
                  Colors.white.withOpacity(activeTab == "Apply RTI" ? 0.2 : 0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Apply RTI",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ).addPadding(left: 50, right: 50, top: 8, bottom: 8),
    );
  }
}
