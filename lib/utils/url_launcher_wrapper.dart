import 'package:flipflop/constant/keys.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> launchURL(String type, String url) async {
  assert(type != null);
  switch(type) {
    case Keys.URL_EMAIL_TYPE:
      if(await canLaunch("mailto:"))
        return launch(getEmailForm(url, "Feedback"));
    break;
    case Keys.URL_BROWSER_TYPE:
    if(await canLaunch("http:"))
      return launch(url);
    break;

    default:
      throw Exception("This URL launch type is not supported.");
    break;
  }

  return throw Exception("Can't find app to open this URL");
}

String getEmailForm(String address, String subject) {
  return "mailto:$address?subject=$subject";
}