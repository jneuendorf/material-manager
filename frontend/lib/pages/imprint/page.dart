import 'dart:html';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/common/components/page_wrapper.dart';

import 'package:frontend/common/core/models.dart';
import 'package:frontend/extensions/user/model.dart';



const imprintRoute = '/imprint';

//mock data -- remove when endpoint exists
final ImprintModel mockImprint = ImprintModel(
  clubName: 'Deutscher Alpenverein Sektion Berlin e.V.',
  address: Address(street:'Musterstraße' ,houseNumber:'56A',zip:'12553' ,city:'Berlin'),
  phoneNumber: '+49 12345678942',
  email: 'muster@mail.com',
  boardMembers: ['Peter Müller (Vorsitzender)','Hans Meyer (Stellvertreter)'],
  registrationNumber: 7235,
  registryCourt: 'Amtgericht Berlin',
  vatNumber: '1234 567 89'
);

class ImprintPage extends StatelessWidget {
  const ImprintPage({super.key});


  @override
  Widget build(BuildContext context) => PageWrapper(
    child: 
    Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 18.0, left: 250.0, bottom: 18.0, right: 250.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('imprint'.tr, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 35.0)),
            Padding(
              padding: const EdgeInsets.only(top: 35.0, bottom: 15.0),
              child: Text(mockImprint.clubName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9.0),
                    child: Text('${mockImprint.address.street} ${mockImprint.address.houseNumber}, ${mockImprint.address.zip} ${mockImprint.address.city}', style: const TextStyle(fontSize: 15.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9.0),
                    child: Text('${'phone'.tr}: ${mockImprint.phoneNumber}', style: const TextStyle(fontSize: 15.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9.0),
                    child: Text('${'email'.tr}: ${mockImprint.email}', style: const TextStyle(fontSize: 15.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 5.0),
                    child: Text('authorized_board_of_directors'.tr, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  ),
                  for(var boardMember in mockImprint.boardMembers)
                    Text(boardMember, style: const TextStyle(fontSize: 15.0)),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 5.0),
                    child: Text('registered_in_club_register'.tr, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  ),
                  Text('${mockImprint.registryCourt}: ${mockImprint.registrationNumber}', style: const TextStyle(fontSize: 15.0)),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 5.0),
                    child: Text('vat_number'.tr, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  ),
                  Text(mockImprint.vatNumber, style: const TextStyle(fontSize: 15.0)),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 5.0),
                    child: Text('regulation_on_online_dispute_resolution_in_consumer_matters'.tr, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  ),
                  //launch url "http://ec.europa.eu/consumers/odr/"
                  const Text('Die Europäische Kommission stellt eine Plattform zur Online-Streitbeilegung bereit, die Sie unter http://ec.europa.eu/consumers/odr/ finden.', style: TextStyle(fontSize: 15.0)),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 5.0),
                    child: Text('liability_note'.tr, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  ),
                  const Text('Trotz sorgfältiger Prüfung wird keine Haftung für die Richtigkeit der auf dieser Webseite dargestellten Inhalte übernommen. Die Betreiber dieser Webseite haften nicht für Inhalte bzw. Verfügbarkeit anderer Webseiten, auf die mit Hyperlinks verwiesen wird. Für den Inhalt der verlinkten Seiten sind ausschließlich deren Betreiber verantwortlich.', style: TextStyle(fontSize: 15.0)),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}