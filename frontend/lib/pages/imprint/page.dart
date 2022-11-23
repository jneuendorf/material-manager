import 'dart:html';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/common/components/page_wrapper.dart';
///import 'package:url_launcher/url_launcher.dart';


const imprintRoute = '/imprint';

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
              child: Text('Vereinsname', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9.0),
                    child: Text('Musterstraße 123, 14302 Musterstadt', style: const TextStyle(fontSize: 15.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9.0),
                    child: Text('Telefon: +49 12345678942', style: const TextStyle(fontSize: 15.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9.0),
                    child: Text('Email: Muster@mail.com', style: const TextStyle(fontSize: 15.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9.0),
                    child: Text('Fax: +49 1234 56789', style: const TextStyle(fontSize: 15.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 15.0),
                    child: Text('Vertretungsberechtigter Vorstand', style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  ),
                  Text('Max Mustermann, Helmut Meyer, Sabine Müller', style: const TextStyle(fontSize: 15.0)),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 15.0),
                    child: Text('Eingetragen im Vereinsregister', style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  ),
                  Text('des Amtgerichts Berlin: VR 1234', style: const TextStyle(fontSize: 15.0)),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 15.0),
                    child: Text('Umsatzsteuer-Identifikationsnummer', style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  ),
                  Text('gemäß § 27a UStG: 1234 567 89', style: const TextStyle(fontSize: 15.0)),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 15.0),
                    child: Text('Verordnung über Online-Streitbeilegung in Verbraucherangelegenheiten', style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  ),
                  Text('Die Europäische Kommission stellt eine Plattform zur Online-Streitbeilegung bereit, die Sie unter http://ec.europa.eu/consumers/odr/ finden.', style: const TextStyle(fontSize: 15.0)),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 15.0),
                    child: Text('Haftungshinweis', style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  ),
                  Text('Trotz sorgfältiger Prüfung wird keine Haftung für die Richtigkeit der auf dieser Webseite dargestellten Inhalte übernommen. Die Betreiber dieser Webseite haften nicht für Inhalte bzw. Verfügbarkeit anderer Webseiten, auf die mit Hyperlinks verwiesen wird. Für den Inhalt der verlinkten Seiten sind ausschließlich deren Betreiber verantwortlich.', style: const TextStyle(fontSize: 15.0)),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}