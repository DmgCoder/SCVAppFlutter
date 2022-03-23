import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:scv_app/Components/nastavitveGroup.dart';
import 'package:scv_app/Components/settingsUserCard.dart';
import 'package:scv_app/SettingsPages/aboutAplication.dart';
import 'package:scv_app/SettingsPages/aboutMe.dart';
import 'package:scv_app/SettingsPages/changeStatus.dart';
import 'package:scv_app/prijava.dart';
import 'package:scv_app/theme.dart';
import 'package:scv_app/uvod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:get/get.dart';




class NastavitvePage extends StatefulWidget {
  NastavitvePage({Key key, this.title, this.data}) : super(key: key);

  final String title;

  final Data data;

  _NastavitvePageState createState() => _NastavitvePageState();
}

class _NastavitvePageState extends State<NastavitvePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedPickerItem = 0;

  String token = "";

  @override
  void initState() {
    super.initState();
    loadToken();
  }
  bool jeSistemskaTema=false;
  void loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        token = prefs.getString(keyForAccessToken);
      });
    } catch (e) {
      print(e);
    }
    try{
      bool test = prefs.getBool(keyForThemeDark);
      if(test == null){
        setState(() {
          jeSistemskaTema = true;
        });
      }
    }catch (e){
      print(e);
    }
  }

  bool _value = Get.isDarkMode;

  toggleThemeBtn(toggle) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
      setState((){
        _value=toggle;
      });
      if (Get.isDarkMode){
        Get.changeThemeMode(ThemeMode.light);
        prefs.setBool(keyForThemeDark,false);
      }else{
        Get.changeThemeMode(ThemeMode.dark);
        prefs.setBool(keyForThemeDark,true);
      }
      setState(() {
        jeSistemskaTema = false;
      });
    }

  @override
  Widget build(BuildContext context) {

    Future<void> odjava() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(keyForAccessToken);
      prefs.remove(keyForRefreshToken);
      prefs.remove(keyForExpiresOn);
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => OnBoardingPage()));
    }

    void goToPageChangeStatus(){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangeStatusPage()));
    }
    void goToPageAboutApp(){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutAppPage()));
    }
    void goToPageAboutMe(){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutMePage()));
    }

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Opozorilo!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Ali se res želiš odjaviti iz ŠCVAppa?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text('Ne, prekliči'),
                  onPressed: () => Navigator.pop(context, 'Cancel')),
              TextButton(
                  child: const Text('Da, odjavi me.',style: TextStyle(fontWeight: FontWeight.bold,)), onPressed: odjava),
            ],
          );
        },
      );
    }

    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(24),
            children: [
              SettingsUserCard(
                userName: widget.data.user.displayName,
                userProfilePic: widget.data.user.image,
                cardColor: widget.data.schoolData.schoolColor,
                userMoreInfo: Text(
                  widget.data.user.mail,
                  style: TextStyle(
                    color: Colors.white
                  ),
                  ),
              ),
              NastavitveGroup(
                items: [
                  SettingsItem(
                    iconStyle: IconStyle(
                      iconsColor: Theme.of(context).hintColor,
                      withBackground: true,
                      backgroundColor: Colors.red,
                    ),
                    icons: Icons.change_circle,
                    onTap: goToPageChangeStatus,
                    title: "Status",
                    subtitle: "Spremeni svoj status!",
                  ),
                  SettingsItem(
                    onTap: goToPageAboutApp,
                    icons: Icons.info_rounded,
                    iconStyle: IconStyle(
                      iconsColor: Theme.of(context).hintColor,
                    backgroundColor: Colors.purple,
                  ),
                    title: 'O aplikaciji',
                    subtitle: "Izvedi več o aplikaciji ŠCVApp",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.dark_mode_rounded,
                    iconStyle: IconStyle(
                      iconsColor: Theme.of(context).hintColor,
                      withBackground: true,
                      backgroundColor: Colors.red,
                    ),
                    title: 'Temni način',
                    subtitle: jeSistemskaTema ? "Sistemska" : _value ? "Vklopljeno" : "Izklopljeno",
                    trailing: Switch.adaptive(
                      activeColor: widget.data.schoolData.schoolColor,
                      value: _value,
                      onChanged: toggleThemeBtn,
                    ),
                  ),
                ],
              ),
              NastavitveGroup(
                settingsGroupTitle: "Račun",
                items: [
                  SettingsItem(
                    onTap: goToPageAboutMe,
                    icons: Icons.account_circle,
                    iconStyle: IconStyle(
                      iconsColor: Theme.of(context).hintColor,
                    backgroundColor: widget.data.schoolData.schoolColor,
                  ),
                    title: 'O meni',
                    subtitle: "Informacije mojega računa",
                  ),
                  SettingsItem(
                    onTap: _showMyDialog,
                    icons: Icons.logout,
                    title: "Odjava",
                    subtitle: "Odjavi se iz aplikacije",
                    iconStyle: IconStyle(
                        iconsColor: Theme.of(context).hintColor,
                        withBackground: true,
                        backgroundColor:
                            widget.data.schoolData.schoolColor //Barva šole
                        ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

}
