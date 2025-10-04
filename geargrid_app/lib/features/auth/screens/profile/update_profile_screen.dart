import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geargrid/common/widgets/custom_app_bar.dart';
import 'package:geargrid/common/widgets/custom_textfield.dart';
import 'package:geargrid/core/utils/snackbar_helper.dart';
import '../../../../common/widgets/dropdown_list.dart';
import '../../../../core/constants/countries_phone_code.dart';
import '../../../../core/providers/flutter_riverpod.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<UpdateProfileScreen> createState() =>
      UpdateProfileScreenState();
}

class UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  String? selectedCountry;
  bool isEditing = false;

  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController countryController;
  late TextEditingController countryCodeController;
  late TextEditingController phoneController;
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;

  bool hideOldPassword = true;
  bool hideNewPassword = true;

  File? avatarFile;

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

    _populateUser();
  }

  void _populateUser() {
    final auth = ref.read(authControllerProvider);
    final user = auth.currentUser;
    if (user != null) {
      fullNameController.text = user.fullName;
      emailController.text = user.email;
      addressController.text = user.address;
      countryController.text = user.country;
      countryCodeController.text = user.countryCode;
      phoneController.text = user.phoneNumber;
      selectedCountry = user.country;
    }
  }

  int? _getPhoneLength(String? country) {
    if (country == null) return null;
    return countryPhoneData[country]?['length'] as int?;
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

  Future<void> _saveProfile() async {
    final auth = ref.read(authControllerProvider);

    final success = await auth.updateProfile(
      fullName: fullNameController.text,
      email: emailController.text,
      address: addressController.text,
      country: selectedCountry ?? countryController.text,
      phoneNumber: phoneController.text,
      oldPassword:
          oldPasswordController.text.isNotEmpty
              ? oldPasswordController.text
              : null,
      newPassword:
          newPasswordController.text.isNotEmpty
              ? newPasswordController.text
              : null,
      avatarFile: avatarFile,
    );

    if (!mounted) return;

    if (success) {
      SnackBarHelper.showSuccess(
        context,
        "Profile updated successfully",
        "Saved changes.",
      );
    } else if (auth.error != null) {
      SnackBarHelper.showError(context, "Update Failed", auth.error!);
    }
  }

  void _toggleEditMode() async {
    if (isEditing) {
      await _saveProfile();

      if (ref.read(authControllerProvider).error != null) {
        _populateUser();
        return;
      }

      setState(() {
        isEditing = false;
        oldPasswordController.clear();
        newPasswordController.clear();
        avatarFile = null;
      });
    } else {
      setState(() {
        isEditing = true;
      });
    }
  }

  void _cancelEdit() {
    setState(() {
      isEditing = false;
      _populateUser();
      oldPasswordController.clear();
      newPasswordController.clear();
      avatarFile = null;
    });
  }

  void _onCountryChanged(String? country) {
    if (!isEditing) return;
    setState(() {
      selectedCountry = country;
      if (country != null) {
        countryController.text = country;
        if (countryPhoneData.containsKey(country)) {
          countryCodeController.text =
              countryPhoneData[country]!['code'].toString();
        }
      }
    });
  }

  Future<void> _pickAvatar() async {
    if (!isEditing) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        avatarFile = File(pickedFile.path);
      });
      if (!mounted) return;
      SnackBarHelper.showSuccess(
        context,
        "Avatar Selected",
        "New avatar will be saved when you press Save.",
      );
    } else {
      if (!mounted) return;
      SnackBarHelper.showInfo(
        context,
        "No image selected",
        "You did not select any image.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final isLoading = auth.isLoading;
    final phoneLength = _getPhoneLength(selectedCountry);

    if (isLoading && auth.currentUser == null) {
      return Scaffold(body: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: CustomAppBar(title: 'Update Profile'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  if (isEditing) ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                          foregroundColor:
                              Theme.of(context).colorScheme.onSurface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.close),
                        label: const Text("Cancel"),
                        onPressed: _cancelEdit,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.check),
                        label: const Text("Save"),
                        onPressed: _toggleEditMode,
                      ),
                    ),
                  ] else
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit"),
                      onPressed: _toggleEditMode,
                    ),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: InkWell(
                  onTap: isEditing ? _pickAvatar : null,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            avatarFile != null
                                ? FileImage(avatarFile!)
                                : NetworkImage(auth.currentUser?.avatar ?? '')
                                    as ImageProvider,
                      ),
                      if (isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Icon(
                            Icons.camera_alt,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(160),
                            size: 25,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: fullNameController,
                hintText: "Full Name",
                readOnly: !isEditing,
                keyboardType: TextInputType.name,
                prefixIcon: Icon(Icons.person),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: emailController,
                hintText: "Email",
                readOnly: !isEditing,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomTextField(
                      controller: countryCodeController,
                      hintText: "Code",
                      readOnly: true,
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
                                (country) => DropdownMenuItem(
                                  value: country,
                                  child: Text(country),
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
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: phoneController,
                hintText: "Phone",
                readOnly: !isEditing,
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(Icons.phone),
                inputFormatters:
                    isEditing && phoneLength != null
                        ? [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(phoneLength),
                        ]
                        : (isEditing
                            ? [FilteringTextInputFormatter.digitsOnly]
                            : null),
              ),
              if (isEditing && phoneLength != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Phone number length: $phoneLength digits',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (isEditing) ...[
                CustomTextField(
                  controller: oldPasswordController,
                  hintText: "Old Password",
                  readOnly: !isEditing,
                  isPassword: hideOldPassword,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hideOldPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        hideOldPassword = !hideOldPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: newPasswordController,
                  hintText: "New Password",
                  readOnly: !isEditing,
                  isPassword: hideNewPassword,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hideNewPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        hideNewPassword = !hideNewPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}