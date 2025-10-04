import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../common/widgets/dropdown_list.dart';
import '../../../../../common/widgets/custom_textfield.dart';
import '../../../../../core/constants/countries_phone_code.dart';
import 'step_header.dart';

class RegistrationStepTwo extends StatelessWidget {
  final String? selectedCountry;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final TextEditingController countryCodeController;
  final Function(String?) onCountryChanged;

  const RegistrationStepTwo({
    super.key,
    required this.selectedCountry,
    required this.addressController,
    required this.phoneController,
    required this.onCountryChanged,
    required this.countryCodeController,
  });

  String? _getCountryCode(String? country) {
    if (country == null) return null;
    return countryPhoneData[country]?['code'] as String?;
  }

  int? _getPhoneLength(String? country) {
    if (country == null) return null;
    return countryPhoneData[country]?['length'] as int?;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final phoneLength = _getPhoneLength(selectedCountry);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const StepHeader(currentStep: 2, totalSteps: 2),
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
            const SizedBox(width: 12),

            // Country dropdown
            Expanded(
              flex: 3,
              child: CustomDropdownField<String>(
                value: selectedCountry,
                hintText: "Select your country",
                items: countryPhoneData.keys
                    .map(
                      (country) => DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  onCountryChanged(value);
                  countryCodeController.text = _getCountryCode(value) ?? '';
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
            color: colors.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
        ),

        const SizedBox(height: 16),

        CustomTextField(
          controller: phoneController,
          hintText: "Phone Number",
          keyboardType: TextInputType.phone,
          prefixIcon: Icon(
            Icons.phone_outlined,
            color: colors.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
          inputFormatters: phoneLength != null
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(phoneLength),
                ]
              : [FilteringTextInputFormatter.digitsOnly],
        ),

        if (phoneLength != null) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Phone number length: $phoneLength digits',
              style: TextStyle(
                fontSize: 12,
                color: colors.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ],
    );
  }
}