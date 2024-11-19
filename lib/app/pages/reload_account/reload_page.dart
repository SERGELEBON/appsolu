import 'package:flutter/material.dart';
import 'package:io/ansi.dart';
import 'package:mobile_wallet/app/pages/reload_account/recharge_moov/input_amount.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/icons.dart';
import '../../../library/common_widgets/app_logo.dart';
import '../../widgets/navbar/custom_bottom_navbar.dart';
import '../../widgets/reload_widget/recharge_option.dart';
import '../../widgets/reload_widget/section_title.dart';

class ReloadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    print('Hauteur $screenHeight');
    print('Largeur $screenWidth');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/madis_finance.png', // Votre chemin de logo
                  height: 80,
                ),
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.center, // Ce code aligne le texte au centre du conteneur
                padding: EdgeInsets.symmetric(horizontal: 16.0), // Padding optionnel
                child: Text(
                  'Choisissez votre moyen de rechargement en cliquant sur l\'opérateur correspondant ci-dessous !',
                  textAlign: TextAlign.center, // Centre le texte dans le widget Text
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 16,
                  ),
                ),
              ),
              // Stack containing the images
              SizedBox(height: 20),
              SectionTitle(
                title: 'Mobile Money',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 16,
                ),
              ),
              Wrap(
                alignment: WrapAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InputAmount(),
                      ),
                    );
                    },
                  child:  mobileMoneyCard(name: "Moov Money", url: "moov", size: MediaQuery.of(context).size.width * 0.4, context: context),
                  ),

                  mobileMoneyCard(name: "Mtn Money", url: "MOMO", size: MediaQuery.of(context).size.width * 0.4, context: context),
                  mobileMoneyCard(name: "Orange Money", url: "OM", size: MediaQuery.of(context).size.width * 0.4, context: context),
                  mobileMoneyCard(name: "Wave", url: "wave", size: MediaQuery.of(context).size.width * 0.4, context: context),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                    ),
                  )
                ],
              ),
          /*      Stack(
                  children: [
                    Container(
                      height: 300, // Adjust the height as needed
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.5, // Aspect ratio to make the images fit
                        children: [
                          GestureDetector(
                            onTap: () {Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InputAmount(),
                              ),
                            );
                            },)
                            child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                          "assets/images/moov.png",
                                        ),
                                        fit: BoxFit.cover
                                    ),
                                    borderRadius: BorderRadius.circular(12)
                                ),
                              ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/momoRoute'); // Remplacez par la route souhaitée
                            },
                            child: Image.asset('assets/images/momo.png', fit: BoxFit.cover),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/waveRoute'); // Remplacez par la route souhaitée
                            },
                            child: Image.asset('assets/images/wave.png', fit: BoxFit.cover),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/image4Route'); // Remplacez par la route souhaitée
                            },
                            child: Image.asset('assets/images/image4.png', fit: BoxFit.cover),
                          ),
                        ],

                      ),
                    ),
                  ],
                ),*/
              SizedBox(height: 20),
              SectionTitle(
                title: 'Virement',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 16,
                ),
              ),
              RechargeOption(
                imageAsset:'assets/madis_finance.png',
                label: 'Compte Madis',
                iconColor: AppColors.text,
                height: 0,
                width: 0,
                fee: 'GRATUIT !',
                onPressed: () {},
              ),
              RechargeOption(
                icon: AppIcons.bank,
                label: 'Compte Bancaire',
                iconColor: AppColors.text,
                height: 0,
                width: 0,
                fee: '2,5%',
                onPressed: () {},
              ),
              RechargeOption(
                icon: AppIcons.card,
                label: 'Carte Bancaire',
                iconColor: AppColors.text,
                height: 0,
                width: 0,
                fee: 'GRATUIT !',
                onPressed: () {},
              ),
              RechargeOption(
                icon: AppIcons.cash,
                label: 'Espèce',
                iconColor: AppColors.text,
                height: 0,
                width: 0,
                fee: 'GRATUIT !',
                onPressed: () {},
              ),
              RechargeOption(
                icon: AppIcons.crypto,
                label: 'Crypto Monnaie',
                iconColor: AppColors.text,
                height: 0,
                width: 0,
                fee: 'GRATUIT !',
                onPressed: () {},
              ),
              RechargeOption(
                icon: AppIcons.token,
                label: 'Token MADIS',
                iconColor: AppColors.text,
                height: 0,
                width: 0,
                fee: 'GRATUIT !',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          // Gérer la navigation en fonction de l'index
        },
      ),
    );
  }
}

Container mobileMoneyCard({required String name, required String url, required double size, required BuildContext context}) {
  return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        //color: Colors.amber,
          image: DecorationImage(
              image: AssetImage(
                "assets/$url.png",
              ),
              fit: BoxFit.cover
          ),
          borderRadius: BorderRadius.circular(12)
      ),
      margin: const EdgeInsets.all(8),
      child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 125),
            decoration: BoxDecoration(
              //color: Colors.amber,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4
            ),
            child: Text(
              name,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10
              ),
            ),
          ),
          ),
  );
}
