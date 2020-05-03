import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatefulWidget {
  PrivacyPolicyPage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFFF7F9FC),
        leading: Center(
          child: Ink(
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: CircleBorder(),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Color(0xff0e3178),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: new Text("Privacy Policy",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Gilroy',
              color: Color(0xff3a3f5c),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            )),
      ),
      body: new Container(
        color: Color(0xFFF7F9FC),
        child: new Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(40.0),
                  topRight: const Radius.circular(40.0),
                )),
            child: Padding(
              padding: const EdgeInsets.only(left: 38, right: 37, top: 26),
              child: ListView(
                children: [
                  new Text(
                      "Wanderift, Inc., a Delaware corporation, doing business as FlyLine (“FlyLine”) operates the FlyLine.com and Wanderift.com websites (“Sites”), the FlyLine mobile application (“App”), and the travel booking membership services offered through our Sites and App (together with the App and the Sites, the “Services”).\n "
                      "FlyLine respects and protects the privacy of all individuals in our system. We maintain strict policies to ensure the privacy of those who use our Services (“End Users”) or those who may just be visiting our Site or whose data we hold as part of our service provider relationship with our clients (“Visitors”). This policy (“Privacy Policy”) describes the types of information we may collect from you and our practices for how we collect, use, maintain, protect, and disclose such information. The way that we collect and use your information depends on the way you access the Services (whether by Site or by App). This Privacy Policy also includes a description of certain rights that you may have over information that we may collect from you. \n"
                      "By using the Services, you agree to this Privacy Policy. If you do not agree with our policies and practices, your choice is to not use our Services. \n \n"
                      "Information that FlyLine Collects \n"
                      "Types of Information Collected \n"
                      "Personal Data \n"
                      "“Personal Data” is information by which you may be personally identified. FlyLine may collect the following Personal Data from you: \n \n"
                      "• Name \n"
                      "• Email \n"
                      "• Phone number; \n"
                      "• Date of Birth; \n"
                      "• Gender; \n"
                      "• Payment Information; \n"
                      "• Billing Address; and \n"
                      "• Known Traveler Numbers (TSA Pre-Check/Global Entry/etc.) \n \n"
                      "Non-Personal Data \n"
                      "Non-personal data includes any data that cannot be used on its own to identify, trace, or identify a person. We may collect your IP Address, device information, or location information. When non-Personal Data you give to us is combined with Personal Data we collect about you, it will be treated as Personal Data and we will only use it in accordance with this Privacy Policy.\n \n"
                      "How we collect information \n"
                      "With the exception of IP addresses which may be automatically collected, we only collect Personal Data when you affirmatively give it to us through interactions with the Services, including: \n \n"
                      "• During sign up to create an account on the Services; \n"
                      "• Through purchases you make on the Services; \n"
                      "• Through service requests or customer support; or \n"
                      "• Through feedback forms, surveys, or contests on the Services. \n"
                      "We may collect non-Personal Data via automatic means including through cookies or through our third-party service providers listed below. \n \n"
                      "Why we collect and how we use your information. (Legal Basis) \n"
                      "In general, we collect and use your Personal Data for the following reasons: \n \n"
                      "• when it is necessary for the general functioning of the Services;\n"
                      "• when it is necessary in connection with any contract you have entered into with us or to take steps prior to entering into a contract with us;\n"
                      "• when we have obtained your prior consent to the use (this legal basis is only used in relation to uses that are entirely voluntary – it is not used for information processing that is necessary or obligatory in any way);\n"
                      "• when we have a legitimate interest in processing your information for the purpose of providing or improving our Services;\n"
                      "• when have a legitimate interest in using the information for the purpose of contacting you, subject to compliance with applicable law; or \n"
                      "• when we have a legitimate interest in using the information for the purpose of detecting, and protecting against, breaches of our policies and applicable laws. \n"
                      "We may use aggregated (anonymized) information about our End Users, and information that does not identify any individual, without restriction.\n \n"
                      "Accessing and Controlling Your Information \n"
                      "FlyLine acknowledges your right to access and control your Personal Data. An individual who seeks access (including a list of all Personal Data we hold), or who seeks to correct, amend, or delete data may do so through their account settings or by contacting us at support@JoinFlyLine.com. If we receive a request to access or remove data, we will respond within a reasonable timeframe.\n \n"
                      "If you would like to prevent us from collecting your information, you should cease use of our Services. You may have the option to opt-out of certain communications or data collection method as specified when presented to you, such as opt-ins or unsubscribe options. Please be aware that you are unable to opt-out of certain communications, including transaction-based communications. \n \n"
                      "How Long do we Store Personal Data? \n"
                      "We will retain your Personal Data until we receive a deletion request or we determine the need to delete or archive the information. This length of time may vary according to the nature of your relationship with us.\n \n"
                      "Automated Data Collection Methods \n"
                      "Cookies \n"
                      "A cookie is a small file placed on the hard drive of your computer. Cookies are used to help us manage and report on your interaction with the Site. Through cookies, we are able to collect information that we use to improve the Services, keep track of shopping carts, keep track of click-stream data, authenticate your login credentials, manage multiple instances of the Site in a single browser, and tailor your experience on the Services. Cookies may also collect other data such as the date and time you visited the Site, and your current IP address. If you turn off cookies, your experience on the Services will be impaired.\n \n"
                      "Log Files \n"
                      "We use means through the Services to collect IP addresses, browser types, access times, and physical location. We use this information to analyze service performance and to improve our Services.\n \n"
                      "Users under the age of 16 \n"
                      "Our Services are not intended for children under 16 years of age and we do not knowingly collect Personal Data from children under 16. If you are under 16, do not use or register on the Services, make any purchases, use any of the interactive or public comment features, or provide any information about yourself to us. If we learn we have collected or received Personal Data from a child under 16 without verification of parental consent, we will delete that information. If you believe we might have any information from or about a child under 16, please contact us at the email address listed below.\n \n"
                      "Do Not Track Settings \n"
                      "We do not track our Users over time and across third party websites to provide targeted advertising and do not specifically respond to Do Not Track (“DNT”) signals.\n \n"
                      "Who We Share Data With \n"
                      "We may use aggregated (anonymized) information about our End Users and Visitors, and information that does not identify any individual, without restriction. We do not sell or otherwise disclose Personal Data specific personal or transactional information to anyone except as described below:\n \n"
                      "Public Reviews\n"
                      "When you write a review about your use of the Services, the review and your name may be posted on the review page on the Services.\n \n"
                      "Affiliates \n"
                      "We may, for our legitimate interests, share your information with entities under common ownership or control with us who will process your information in a manner consistent with this Privacy Policy and subject to appropriate safeguards. \n \n"
                      "Successors in Interest. \n"
                      "We may, for our legitimate interests, share your information with a buyer or other successor in the event of a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of our assets, in which Personal Data about our End Users and Visitors is among the assets transferred. You will be notified of any such change by a prominent notice displayed on our Services or by e-mail. Any successor in interest to this Privacy Policy will be bound to the Privacy Policy at the time of transfer.\n \n"
                      "Law enforcement and other governmental agencies.\n"
                      "We may share your information when we believe in good faith that such sharing is reasonably necessary to investigate, prevent, or take action regarding possible illegal activities or to comply with legal process. This may involve the sharing of your information with law enforcement, government agencies, courts, and/or other organizations. \n \n"
                      "Service Providers. \n"
                      "We may, for our legitimate interests, share certain information with contractors, service providers, third party authenticators, and other third parties we use to support our business and who are bound by contractual obligations to keep Personal Data confidential and use it only for the purposes for which we disclose it to them. Some of the functions that our service providers provide are as follows:\n \n"
                      "• Travel booking APIs; \n"
                      "• Customer relationship management and live chat; \n"
                      "• Site and App analytics for activity, performance, and troubleshooting;\n"
                      "• Inbound marketing, sales, and service management; and \n"
                      "• Payment processing and payment storage./n"
                      "Third-Party Services and Websites. \n"
                      "FlyLine is not responsible for the privacy policies or other practices employed by websites linked to, or from, our Services nor the information or content contained therein, and we encourage you to read the privacy statements of any linked third party. This includes sharing information via social media websites. \n\n"
                      "Data Storage and How FlyLine Protects Your Information \n"
                      "FlyLine stores basic End User and Visitor data on our contracted servers including name, email, phone number, address, and username. Payment information is processed and stored by our partners or service providers. Personal Data about End Users and Visitors is stored within the United States. The Services are intended to be used inside the United States. If you are using the Services from the EEA or other regions with laws governing data collection and use, please note that you are agreeing to the transfer of your Personal Data to the United States. The United States may have laws which are different, and potentially not as protective, as the laws of your own country. By providing your Personal Data, you consent to any transfer and processing in accordance with this Privacy Policy. FlyLine employs physical, electronic, and manageri \n",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff707070),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ))
                ],
              ),
            )),
      ),
    );
  }
}
