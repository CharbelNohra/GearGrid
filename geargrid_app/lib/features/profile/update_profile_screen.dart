import 'package:flutter/material.dart';
import 'package:geargrid/common/widgets/custom_app_bar.dart';
import 'package:geargrid/common/widgets/custom_textfield.dart';

import '../../common/widgets/dropdown_list.dart';
import '../../core/constants/countries_phone_code.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => UpdateProfileScreenState();
}

class UpdateProfileScreenState extends State<UpdateProfileScreen> {
  Map<String, dynamic>? user;
  String? selectedCountry;
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController countryController;
  late TextEditingController countryCodeController;
  late TextEditingController phoneController;
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController();
    countryController = TextEditingController();
    countryCodeController = TextEditingController();
    phoneController = TextEditingController();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();

    _fetchUser();
  }

  Future<void> _fetchUser() async {
    // simulate fetching from backend
    await Future.delayed(const Duration(seconds: 1));
    final fetchedUser = {
      "id": "12345",
      "fullName": "John Doe",
      "email": "john@example.com",
      "address": "Beirut, Lebanon",
      "country": "Lebanon",
      "countryCode": "+961",
      "phone": "71123456",
      "avatar": "",
    };
    setState(() {
      user = fetchedUser;
      fullNameController.text = fetchedUser["fullName"]!;
      emailController.text = fetchedUser["email"]!;
      addressController.text = fetchedUser["address"]!;
      countryController.text = fetchedUser["country"]!;
      countryCodeController.text = fetchedUser["countryCode"]!;
      phoneController.text = fetchedUser["phone"]!;
    });
  }

  void onCountryChanged(String? country) {
    setState(() {
      selectedCountry = country;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Update Profile',
        automaticallyImplyLeading: true,
        notificationCount: 3,
        cartCount: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      'assets/images/launcher_icon.png',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'User12345',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                ],
              ),
              CustomTextField(
                controller: fullNameController,
                hintText: "Full Name",
                keyboardType: TextInputType.name,

                prefixIcon: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: emailController,
                hintText: "Email",
                prefixIcon: Icon(
                  Icons.email,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomTextField(
                      controller: countryCodeController,
                      hintText: "Country Code",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: CustomDropdownField<String>(
                      value:
                          selectedCountry ??
                          user?['country'], // fallback to fetched user
                      hintText: "Select your country",
                      items:
                          countryPhoneData.keys
                              .map(
                                (country) => DropdownMenuItem(
                                  value: country,
                                  child: Text(country),
                                ),
                              )
                              .toList(),
                      onChanged: (country) {
                        setState(() {
                          selectedCountry = country;
                          countryController.text = country ?? '';
                          countryCodeController.text =
                              country != null
                                  ? countryPhoneData[country]! as String
                                  : '';
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: addressController,
                hintText: "Address",
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: phoneController,
                hintText: "Phone",
                prefixIcon: Icon(
                  Icons.phone,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
