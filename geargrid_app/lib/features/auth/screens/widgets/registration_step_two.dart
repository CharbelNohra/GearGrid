import 'package:flutter/material.dart';
import '../../../../common/widgets/dropdown_list.dart';
import '../../../../common/widgets/custom_phonefield.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../../../../core/constants/countries_phone_code.dart';
import 'step_header.dart';

class RegistrationStepTwo extends StatelessWidget {
  final String? selectedCountry;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final Function(String?) onCountryChanged;

  const RegistrationStepTwo({
    super.key,
    required this.selectedCountry,
    required this.addressController,
    required this.phoneController,
    required this.onCountryChanged,
  });

  String? _getCountryCode(String? country) {
    if (country == null) return null;
    final countryData = countryPhoneData[country];
    return countryData?['code'] as String?;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const StepHeader(currentStep: 2, totalSteps: 2),
        const SizedBox(height: 16),
        CustomDropdownField<String>(
          value: selectedCountry,
          hintText: "Select your country",
          items:
              countryPhoneData.keys
                  .map(
                    (country) =>
                        DropdownMenuItem(value: country, child: Text(country)),
                  )
                  .toList(),
          onChanged: onCountryChanged,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: addressController,
          hintText: "Address",
          prefixIcon: Icon(
            Icons.location_on_outlined,
            color: colors.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
        ),
        const SizedBox(height: 16),
        CustomPhoneField(
          controller: phoneController,
          hintText: "Enter phone number",
          countryCode: _getCountryCode(selectedCountry),
          onCountryTap: () {
            // Optional: You can add logic to open country selector here
          },
        ),
      ],
    );
  }
}