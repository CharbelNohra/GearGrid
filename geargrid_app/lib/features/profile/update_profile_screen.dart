import 'package:flutter/material.dart';
import 'package:geargrid/common/widgets/custom_app_bar.dart';
import 'package:geargrid/common/widgets/custom_textfield.dart';
import 'package:geargrid/core/utils/snackbar_helper.dart';
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
  bool isEditing = false;
  bool isLoading = true;

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

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    addressController.dispose();
    countryController.dispose();
    countryCodeController.dispose();
    phoneController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _fetchUser() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    final fetchedUser = {
      "id": "#12345",
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
      fullNameController.text = fetchedUser["fullName"] ?? "";
      emailController.text = fetchedUser["email"] ?? "";
      addressController.text = fetchedUser["address"] ?? "";
      countryController.text = fetchedUser["country"] ?? "";
      countryCodeController.text = fetchedUser["countryCode"] ?? "";
      phoneController.text = fetchedUser["phone"] ?? "";
      selectedCountry = fetchedUser["country"];
      isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    SnackBarHelper.showSuccess(
      context,
      "Saving Profile...",
      "Please wait while we save your profile information.",
    );

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Update user data
    setState(() {
      user = {
        ...user!,
        "fullName": fullNameController.text,
        "email": emailController.text,
        "address": addressController.text,
        "country": selectedCountry ?? countryController.text,
        "countryCode": countryCodeController.text,
        "phone": phoneController.text,
      };
    });

    SnackBarHelper.showSuccess(
      context,
      "Profile updated successfully",
      "Saved changes.",
    );
  }

  void _toggleEditMode() async {
    if (isEditing) {
      // Save the profile
      await _saveProfile();
    }

    setState(() {
      isEditing = !isEditing;
    });
  }

  void _onCountryChanged(String? country) {
    if (!isEditing) return; // Exit early if not in editing mode

    setState(() {
      selectedCountry = country;
      if (country != null) {
        countryController.text = country;
        if (countryPhoneData.containsKey(country)) {
          countryCodeController.text = countryPhoneData[country]!['code'].toString();
        }
      }
    });
  }

  Future<void> _pickAvatar() async {
    if (!isEditing) return;
    SnackBarHelper.showInfo(
      context,
      "Avatar Change",
      "Avatar change functionality is not implemented in this demo.",
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Update Profile',
          automaticallyImplyLeading: true,
          notificationCount: 3,
          cartCount: 2,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Edit / Save button
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(isEditing ? Icons.check : Icons.edit),
                  label: Text(isEditing ? "Save" : "Edit"),
                  onPressed: _toggleEditMode,
                ),
              ),

              const SizedBox(height: 30),

              // Avatar and username section
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: isEditing ? _pickAvatar : null,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: const AssetImage(
                              'assets/images/launcher_icon.png',
                            ),
                          ),
                          if (isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Icon(
                                Icons.camera_alt,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                size: 25,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user?["id"] ?? 'User12345',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // Form fields
              CustomTextField(
                controller: fullNameController,
                hintText: "Full Name",
                readOnly: !isEditing,
                keyboardType: TextInputType.name,
                prefixIcon: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: emailController,
                hintText: "Email",
                readOnly: !isEditing,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(
                  Icons.email,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),

              // Country code and country dropdown row
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomTextField(
                      controller: countryCodeController,
                      hintText: "Code",
                      readOnly: true, // Always disabled as it's auto-filled
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: CustomDropdownField<String>(
                      value: selectedCountry,
                      readOnly: !isEditing,
                      hintText: "Select your country",
                      items:
                          countryPhoneData.keys
                              .map(
                                (country) => DropdownMenuItem<String>(
                                  value: country,
                                  child: Text(
                                    country,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: _onCountryChanged,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: addressController,
                hintText: "Address",
                readOnly: !isEditing,
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: phoneController,
                hintText: "Phone",
                readOnly: !isEditing,
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(
                  Icons.phone,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 30,
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}