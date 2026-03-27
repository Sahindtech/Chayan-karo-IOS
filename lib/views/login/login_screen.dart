import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import 'widgets/legal_modal.dart';
import 'package:flutter/gestures.dart';
import '../../utils/test_extensions.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _showPrivacyPolicy() {
    Get.bottomSheet(
      const LegalModal(
        title: "Privacy Policy",
        lastUpdated: "31st July, 2025",
        content: '''
Platform Owner: Chayan Karo India Private Limited ("we," "us," or "our")

This Privacy Policy describes how Chayan Karo India Private Limited ("we," "us," or "our") collects, uses, and shares information from users of our mobile application, the Chayan Karo App (the "App"). By using our App, you agree to the collection and use of information in accordance with this policy.

1. Information We Collect
We collect information to provide and improve our App for you. The types of information we may collect are:

a) Information You Provide to Us (Personally Identifiable Information)
Account Information: When you create an account, we may collect your name, email address, phone number, password, and profile picture.
User Content: Information you post or create within the App, such as photos, comments, reviews, service bookings, and messages.
Payment Information: If you make in-app purchases, we may collect information necessary to process your payment, such as your billing address. (Note: This is often handled by third-party payment processors like Google Play).
Communications: If you contact us for support or other inquiries, we will collect the information contained in your message.

b) Information We Collect Automatically (Non-Personally Identifiable Information)
Usage Data: We collect information about how you interact with our App, such as features you use, pages you view, actions you take, and the time, frequency, and duration of your activities.
Device Information: We collect information about the mobile device you use to access our App, including the hardware model, operating system and version, unique device identifiers (e.g., IDFA or Android Advertising ID), mobile network information, and IP address.
Location Information: We may collect your device's precise or approximate location information if you grant us permission to do so. You can disable this at any time through your device settings.
Crash and Performance Data: We collect diagnostic data related to app crashes and performance to help us identify and fix bugs.

c) Information from "Chayan Sathi" (Service Providers)
In addition to the above, we collect and process information from our Service Providers, including Aadhaar e-KYC data for identity validation purposes, as described in our Terms & Conditions.

2. How We Use Your Information
We use the information we collect for various purposes, including: to provide, operate, and maintain our App; to improve, personalize, and expand our App; to understand and analyze how you use our App; to develop new products, services, features, and functionality; to process your transactions and manage your orders; to communicate with you, either directly or through one of our partners, including for customer service, to provide you with updates and other information relating to the App, and for marketing and promotional purposes; to prevent fraud and ensure the security of our App; and for compliance purposes, including enforcing our Terms of Service or other legal rights.

3. How We Share Your Information
We do not sell your personal information. We may share your information in the following situations:

With Service Providers: We may share your information with third-party vendors and service providers that perform services on our behalf, such as cloud hosting (e.g., AWS, Google Cloud), analytics (e.g., Google Analytics for Firebase), payment processing, and customer support. These third parties are obligated to protect your information and are restricted from using it for any other purpose.
For Legal Reasons: We may disclose your information if required to do so by law or in response to valid requests by public authorities (e.g., a court or a government agency).
Business Transfers: If we are involved in a merger, acquisition, or asset sale, your information may be transferred. We will provide notice before your information is transferred and becomes subject to a different Privacy Policy.
With Your Consent: We may disclose your information for any other purpose with your consent.

4. Data Security
We use commercially reasonable administrative, technical, and physical security measures to protect your information from unauthorized access, use, or disclosure. However, no method of transmission over the Internet or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Information, we cannot guarantee its absolute security.

5. Your Data Rights
You have the right to access, update, or delete the information we have on you. You can typically do this through your account settings within the App. If you are unable to perform these actions yourself, please contact us to assist you.

6. Account Deletion Request
You have the right to request the deletion of your account. To initiate this process, you must contact us directly using the details provided in the "Contact Us" section of this policy.

To request deletion via email:
Send an email to chayankaroindia@gmail.com with the subject line "Account Deletion Request". Please send the request from the email address associated with your Chayan Karo account.

To request deletion via phone:
Call us at +91 8299217231 to speak with our support team.

Upon receiving and verifying your request, we will process the permanent deletion of your account and associated data.

7. Data Deletion Request
You have the right to request the deletion of your personal data that we have collected.
Please note that deleting your account using the method described in the "Account Deletion Request" section will also result in the permanent deletion of all your associated personal data. This is the standard procedure for data deletion.
For any specific inquiries about your data, please use the same contact methods outlined above.

8. Children's Privacy
Our App is not intended for use by children under the age of 13. We do not knowingly collect personally identifiable information from children under 13. If you are a parent or guardian and you are aware that your child has provided us with Personal Information, please contact us. If we become aware that we have collected Personal Information from a child under 13 without verification of parental consent, we will take steps to remove that information from our servers.

9. Changes to This Privacy Policy
We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the 'Effective Date' at the top. You are advised to review this Privacy Policy periodically for any changes.

10. Contact Us
If you have any questions about this Privacy Policy, please contact us:
By Email: chayankaroindia@gmail.com
By Phone: +91 8299217231
By Mail: Chayan Karo India Private Limited, 610/003, Keshavnagar, Sitapur Road, Lucknow – 226020

---
Company Incorporation Details:
Company Name: Chayan Karo India Private Limited
Date of Incorporation: 22nd February, 2025
Company Type: Private Limited Company (Limited by shares)
CIN: U74900UP2025PTC217323
PAN: AAMCC4582G
TAN: LKNC09082D
Registered Address: 610/003 Keshavnagar, Sitapur Road, Triveni Nagar, Lucknow – 226020, Uttar Pradesh, India
Registrar of Companies: Central Registration Centre, Manesar
Official Verification: mca.gov.in
''',
      ),
      isScrollControlled: true,
    );
  }

  void _showTermsConditions() {
    Get.bottomSheet(
      const LegalModal(
        title: "TERMS AND CONDITIONS",
        lastUpdated: "31st July, 2025",
        content: '''
Platform Owner: Chayan Karo India Private Limited ("we," "us," or "our")

This Privacy Policy describes how Chayan Karo India Private Limited ("we," "us," or "our") collects, uses, and shares information from users of our mobile application, the Chayan Karo App (the "App"). By using our App, you agree to the collection and use of information in accordance with this policy.

1. Information We Collect
We collect information to provide and improve our App for you. The types of information we may collect are:

a) Information You Provide to Us (Personally Identifiable Information)
Account Information: When you create an account, we may collect your name, email address, phone number, password, and profile picture.
User Content: Information you post or create within the App, such as photos, comments, reviews, service bookings, and messages.
Payment Information: If you make in-app purchases, we may collect information necessary to process your payment, such as your billing address. (Note: This is often handled by third-party payment processors like Google Play).
Communications: If you contact us for support or other inquiries, we will collect the information contained in your message.

b) Information We Collect Automatically (Non-Personally Identifiable Information)
Usage Data: We collect information about how you interact with our App, such as features you use, pages you view, actions you take, and the time, frequency, and duration of your activities.
Device Information: We collect information about the mobile device you use to access our App, including the hardware model, operating system and version, unique device identifiers (e.g., IDFA or Android Advertising ID), mobile network information, and IP address.
Location Information: We may collect your device's precise or approximate location information if you grant us permission to do so. You can disable this at any time through your device settings.
Crash and Performance Data: We collect diagnostic data related to app crashes and performance to help us identify and fix bugs.

c) Information from "Chayan Sathi" (Service Providers)
In addition to the above, we collect and process information from our Service Providers, including Aadhaar e-KYC data for identity validation purposes, as described in our Terms & Conditions.

2. How We Use Your Information
We use the information we collect for various purposes, including: to provide, operate, and maintain our App; to improve, personalize, and expand our App; to understand and analyze how you use our App; to develop new products, services, features, and functionality; to process your transactions and manage your orders; to communicate with you, either directly or through one of our partners, including for customer service, to provide you with updates and other information relating to the App, and for marketing and promotional purposes; to prevent fraud and ensure the security of our App; and for compliance purposes, including enforcing our Terms of Service or other legal rights.

3. How We Share Your Information
We do not sell your personal information. We may share your information in the following situations:

With Service Providers: We may share your information with third-party vendors and service providers that perform services on our behalf, such as cloud hosting (e.g., AWS, Google Cloud), analytics (e.g., Google Analytics for Firebase), payment processing, and customer support. These third parties are obligated to protect your information and are restricted from using it for any other purpose.
For Legal Reasons: We may disclose your information if required to do so by law or in response to valid requests by public authorities (e.g., a court or a government agency).
Business Transfers: If we are involved in a merger, acquisition, or asset sale, your information may be transferred. We will provide notice before your information is transferred and becomes subject to a different Privacy Policy.
With Your Consent: We may disclose your information for any other purpose with your consent.

4. Data Security
We use commercially reasonable administrative, technical, and physical security measures to protect your information from unauthorized access, use, or disclosure. However, no method of transmission over the Internet or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Information, we cannot guarantee its absolute security.

5. Your Data Rights
You have the right to access, update, or delete the information we have on you. You can typically do this through your account settings within the App. If you are unable to perform these actions yourself, please contact us to assist you.

6. Children's Privacy
Our App is not intended for use by children under the age of 13. We do not knowingly collect personally identifiable information from children under 13. If you are a parent or guardian and you are aware that your child has provided us with Personal Information, please contact us. If we become aware that we have collected Personal Information from a child under 13 without verification of parental consent, we will take steps to remove that information from our servers.

7. Changes to This Privacy Policy
We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the 'Effective Date' at the top. You are advised to review this Privacy Policy periodically for any changes.

8. Contact Us
If you have any questions about this Privacy Policy, please contact us:

By Email: chayankaroindia@gmail.com
By Phone: +91 8299217231
By Mail: Chayan Karo India Private Limited, 610/003, Keshavnagar, Sitapur Road, Lucknow – 226020
''',
      ),
      isScrollControlled: true,
    );
  }
  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isTablet = constraints.maxWidth > 600;
            final double sf = isTablet ? constraints.maxWidth / 411 : 1;

            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16.w * sf,
                right: 16.w * sf,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  /// ---------------- LOGO SECTION ----------------
                  Container(
                    width: double.infinity,
                    color: const Color(0xFFF2F4FF),
                    padding: EdgeInsets.only(
                      top: 40.h,
                      bottom: 12.h,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 260, // Auto-fit for all devices
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/logo.svg",
                          width: 300.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// ---------------- PHONE FIELD ----------------
                  TextField(
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    style: TextStyle(
                      fontFamily: 'SFProRegular',
                      fontSize: 16.sp * sf,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "Enter your 10-digit number",
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 12.w),
                          Text(
                            "+91",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SFProSemibold',
                              fontSize: 16.sp * sf,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Container(
                            width: 1,
                            height: 26.h,
                            color: const Color(0xFF79747E),
                          ),
                          SizedBox(width: 8.w),
                        ],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide:
                            const BorderSide(color: Color(0xFF79747E)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(
                          color: Color(0xFFFF6F00),
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                    ),
                  ).withId('login_phone_input'),

                  SizedBox(height: 6.h),

                  /// ---------------- ERROR BOX ----------------
                  Obx(
                    () => controller.errorMessage.isNotEmpty
                        ? Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red, size: 18.sp),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    controller.errorMessage,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: 'Inter',
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  SizedBox(height: 10.h),

                  Text(
                    "An OTP will be sent on given phone number for verification.\nStandard message and data rates apply.",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'Inter',
                      color: const Color(0xFF757575),
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 120.h), // Enough space for scroll
                ],
              ),
            );
          },
        ),
      ),

      /// ---------------- FIXED SAFE BOTTOM BUTTON ----------------
      bottomSheet: SafeArea(
        top: false,
        child: Container(
padding: EdgeInsets.fromLTRB(
      16.w,
      14.h,
      16.w,
      14.h +
          (MediaQuery.of(context).viewInsets.bottom == 0
              ? MediaQuery.of(context).viewPadding.bottom
              : 0),
    ),          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: controller.isButtonEnabled &&
                            !controller.isLoading
                        ? controller.sendOTP
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isButtonEnabled
                          ? const Color(0xFFFF6F00)
                          : const Color(0xFFE6EAFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            "Get Verification OTP",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'SFProSemibold',
                              color: controller.isButtonEnabled
                                  ? Colors.white
                                  : const Color(0xFF757575),
                            ),
                          ),
                  ).withId('login_get_otp_btn'),
                ),
              ),

              SizedBox(height: 6.h),

// PASTE THIS INSTEAD
RichText(
  textAlign: TextAlign.center,
  text: TextSpan(
    text: "By Continuing, You agree to our ",
    style: TextStyle(
      fontSize: 10.sp,
      fontFamily: 'SFProRegular',
      color: Colors.black.withOpacity(0.8),
      height: 1.5,
    ),
    children: [
      TextSpan(
        text: "T&C",
        style: const TextStyle(
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.bold,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _showTermsConditions(); // Calls the function added in step 2
          },
      ),
      const TextSpan(
        text: " and ",
      ),
      TextSpan(
        text: "Privacy Policy",
        style: const TextStyle(
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.bold,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _showPrivacyPolicy(); // Calls the function added in step 2
          },
      ),
    ],
  ),
).withId('login_legal_text_block'),
            ],
          ),
        ),
      ),
    );
  }
}
