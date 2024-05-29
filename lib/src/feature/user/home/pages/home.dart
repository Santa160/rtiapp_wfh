import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rtiapp/src/common/extentions/extention.dart';
import 'package:rtiapp/src/common/widget/header.widget.dart';
import 'package:rtiapp/src/common/widget/title_style.dart';
import 'package:rtiapp/src/core/kcolors.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/feature/user/home/widget/dropdowns/pia.dropdown.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activeTab = "Home";
  // List to store TextEditingControllers for each TextFormField
  List<TextEditingController> controllers = [];

  // GlobalKey to access the form
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize with two TextFormFields
    addField();
    addField();
  }

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
          labelText: 'Question ${count + 1}',
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

  // Method to add a new field to the form
  void addField() {
    setState(() {
      final controller = TextEditingController();
      controllers.add(controller);
    });
  }

  // Method to handle form submission
  void handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      for (var controller in controllers) {
        logger.e(controller.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var mw = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          const HeaderWidget().addPadding(
              left: mw > 650 ? 150 : 50, right: mw > 650 ? 150 : 50),
          const Gap(20),
          Container(
            color: KCOLOR.brand,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        activeTab = "Home";
                        setState(() {});
                      },
                      child: Container(
                        color: Colors.white
                            .withOpacity(activeTab == "Home" ? 0.2 : 0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Home",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Colors.white,
                                  )),
                        ),
                      ),
                    ),
                    const Gap(20),
                    InkWell(
                      onTap: () {
                        activeTab = "Submit RTI";
                        setState(() {});
                      },
                      child: Container(
                        color: Colors.white
                            .withOpacity(activeTab == "Submit RTI" ? 0.2 : 0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Submit RTI",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ).addPadding(left: 150, right: 150, bottom: 20),
                Text(
                  "Logout",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ).addPadding(left: 150, right: 150, bottom: 20),
              ],
            ),
          ),
          Expanded(
            child: activeTab == "Home"
                ? const Text("Home")
                : SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(5),
                          Text(
                            'Submit RTI Request',
                            style: style,
                          ),
                          PiaDropdownForm(
                            questions: (qests) {},
                            file: (file) {},
                          ),
                          const Gap(5),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: controllers.length,
                            itemBuilder: (context, index) {
                              return createTextFormField(
                                  controllers[index], index);
                            },
                          ),
                          const Gap(5),
                          TextButton.icon(
                              icon: const Icon(Icons.add),
                              onPressed: addField,
                              label: const Text("Add more questions")),
                          const Gap(5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  style: const ButtonStyle(
                                      foregroundColor:
                                          WidgetStatePropertyAll(Colors.white),
                                      backgroundColor:
                                          WidgetStatePropertyAll(KCOLOR.brand)),
                                  onPressed: handleSubmit,
                                  child: const Text("Submit")),
                            ],
                          )
                        ],
                      ).addPadding(left: 150, right: 150),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
