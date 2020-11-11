import 'package:url_launcher/url_launcher.dart';

class OpenFacebook{
  static void openFacebook() async{
    /* numeric value ကို https://lookup-id.com/ မှာ ရှာပါ */
    String fbProtocolUrl = "fb://page/110486103786309";
    String fallbackUrl = "https://www.facebook.com/mmsoftware100";
    try {
      bool launched = await launch(fbProtocolUrl, forceSafariVC: false);
      print("launching..."+fbProtocolUrl);
      if (!launched) {
        print("can't launch");
        await launch(fallbackUrl, forceSafariVC: false);
      }
    } catch (e) {
      print("can't launch exp "+e.toString());
      await launch(fallbackUrl, forceSafariVC: false);
    }
  }
}