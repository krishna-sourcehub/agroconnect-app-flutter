import 'package:agroconnect/route/route_constants.dart';
import 'package:flutter/material.dart';

class TermsOfServicesScreen extends StatelessWidget {
  const TermsOfServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Terms & Privacy")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "AgroConnect – Terms of Service",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            const Text(
              '1. AgroConnect is a platform that connects farmers and      merchants for agricultural product sales.\n'
              '2. All users must register with valid identification and contact      information.\n'
              '3. Farmers are responsible for listing accurate product details      including price, quality, and quantity.\n'
              '4. Merchants are expected to make timely payments and collect      produce as agreed.\n'
              '5. AgroConnect is not responsible for disputes related to      payments, quality, or delivery.\n'
              '6. Users must not engage in fraudulent, illegal, or misleading      activities on the platform.\n'
              '7. AgroConnect reserves the right to suspend or remove      accounts that violate the terms of service.',
              style: TextStyle(
                fontFamily: 'RobotoMono',
                fontSize: 14, // Optional: keeps tab spacing uniform
                height: 1.6, // Optional: improves readability
              ),
              textAlign: TextAlign.start,
            ),

            const SizedBox(height: 24),
            Text(
              "AgroConnect – Privacy Policy",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            const Text(
              '''1. AgroConnect collects user information such as name, phone      number, and location for account setup and service use.
2. Your personal data is kept confidential and used only to      connect farmers with merchants.
3. We do not share your information with third parties without      your consent.
4. Location data may be used to suggest nearby buyers or      sellers.
5. AgroConnect uses secure methods to store and protect user      data.
6. Users can request to update or delete their data at any time.
7. By using AgroConnect, you agree to the collection and use of      information as described.''',
              style: TextStyle(
                fontFamily: 'RobotoMono',
                fontSize: 14, // Optional: keeps tab spacing uniform
                height: 1.6, // Optional: improves readability
              ),
              textAlign: TextAlign.start,
            ),

            const SizedBox(height: 24),
            const Text("By using AgroConnect, you agree to these terms."),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to home or next screen
                  Navigator.pushReplacementNamed(
                    context,
                    signUpScreenRoute,
                  ); // replace '/home' with your route
                },
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
