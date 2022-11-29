import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:frontend/common/components/page_wrapper.dart';


const privacyPolicyRoute = '/privacyPolicy';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) => PageWrapper(
    child: 
    SingleChildScrollView(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0, left: 250.0, bottom: 18.0, right: 250.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Text('privacy_policy'.tr, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 35.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text('1. Datenschutz auf einen Blick', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 30.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Allgemeine Hinweise', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text('Die folgenden Hinweise geben einen einfachen Überblick darüber, was mit Ihren personenbezogenen Daten passiert, wenn Sie diese Website besuchen. Personenbezogene Daten sind alle Daten, mit denen Sie persönlich identifiziert werden können. Ausführliche Informationen zum Thema Datenschutz entnehmen Sie unserer unter diesem Text aufgeführten Datenschutzerklärung.', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text('Datenerfassung auf dieser Website', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),
                  child: Text('Wer ist verantwortlich für die Datenerfassung auf dieser Website?', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Die Datenverarbeitung auf dieser Website erfolgt durch den Websitebetreiber. Dessen Kontaktdaten können Sie dem Abschnitt „Hinweis zur Verantwortlichen Stelle“ in dieser Datenschutzerklärung entnehmen', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:10.0,bottom: 10.0),
                  child: Text('Wie erfassen wir Ihre Daten?', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Ihre Daten werden zum einen dadurch erhoben, dass Sie uns diese mitteilen. Hierbei kann es sich z. B. um Daten handeln, die Sie in ein Kontaktformular eingeben.', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Andere Daten werden automatisch oder nach Ihrer Einwilligung beim Besuch der Website durch unsere IT- Systeme erfasst. Das sind vor allem technische Daten (z. B. Internetbrowser, Betriebssystem oder Uhrzeit des Seitenaufrufs). Die Erfassung dieser Daten erfolgt automatisch, sobald Sie diese Website betreten.', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:10.0,bottom: 10.0),
                  child: Text('Wofür nutzen wir Ihre Daten?', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Ein Teil der Daten wird erhoben, um eine fehlerfreie Bereitstellung der Website zu gewährleisten. Andere Daten können zur Analyse Ihres Nutzerverhaltens verwendet werden.', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:10.0,bottom: 10.0),
                  child: Text('Welche Rechte haben Sie bezüglich Ihrer Daten?', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Sie haben jederzeit das Recht, unentgeltlich Auskunft über Herkunft, Empfänger und Zweck Ihrer gespeicherten personenbezogenen Daten zu erhalten. Sie haben außerdem ein Recht, die Berichtigung oder Löschung dieser Daten zu verlangen. Wenn Sie eine Einwilligung zur Datenverarbeitung erteilt haben, können Sie diese Einwilligung jederzeit für die Zukunft widerrufen. Außerdem haben Sie das Recht, unter bestimmten Umständen die Einschränkung der Verarbeitung Ihrer personenbezogenen Daten zu verlangen. Des Weiteren steht Ihnen ein Beschwerderecht bei der zuständigen Aufsichtsbehörde zu.Hierzu sowie zu weiteren Fragen zum Thema Datenschutz können Sie sich jederzeit an uns wenden.', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0,bottom: 15.0),
                  child: Text('2. Allgemeine Hinweise und Pflichtinformationen', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 30.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text('Datenschutz', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Die Betreiber dieser Seiten nehmen den Schutz Ihrer persönlichen Daten sehr ernst. Wir behandeln Ihre personenbezogenen Daten vertraulich und entsprechend den gesetzlichen Datenschutzvorschriften sowie dieser Datenschutzerklärung.', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Wenn Sie diese Website benutzen, werden verschiedene personenbezogene Daten erhoben. Personenbezogene Daten sind Daten, mit denen Sie persönlich identifiziert werden können. Die vorliegende Datenschutzerklärung erläutert, welche Daten wir erheben und wofür wir sie nutzen. Sie erläutert auch, wie und zu welchem Zweck das geschieht.', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Wir weisen darauf hin, dass die Datenübertragung im Internet (z. B. bei der Kommunikation per E-Mail) Sicherheitslücken aufweisen kann. Ein lückenloser Schutz der Daten vor dem Zugriff durch Dritte ist nicht möglich.', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0,bottom: 5.0),
                  child: Text('Hinweis zur verantwortlichen Stelle', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Die verantwortliche Stelle für die Datenverarbeitung auf dieser Website ist:', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Beispielfirma \nMusterweg 10 \n90210 Musterstadt', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Telefon: +49 (0) 123 44 55 66 \n E-Mail: info@beispielfirma.de', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Verantwortliche Stelle ist die natürliche oder juristische Person, die allein oder gemeinsam mit anderen über die Zwecke und Mittel der Verarbeitung von personenbezogenen Daten (z. B. Namen, E-Mail-Adressen o. Ä.) entscheidet.', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0,bottom: 5.0),
                  child: Text('Speicherdauer', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Soweit innerhalb dieser Datenschutzerklärung keine speziellere Speicherdauer genannt wurde, verbleiben Ihre personenbezogenen Daten bei uns, bis der Zweck für die Datenverarbeitung entfällt. Wenn Sie ein berechtigtes Löschersuchen geltend machen oder eine Einwilligung zur Datenverarbeitung widerrufen, werden Ihre Daten gelöscht, sofern wir keine anderen rechtlich zulässigen Gründe für die Speicherung Ihrer personenbezogenen Daten haben (z. B. steuer- oder handelsrechtliche Aufbewahrungsfristen); im letztgenannten Fall erfolgt die Löschung nach Fortfall dieser Gründe.', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0,bottom: 5.0),
                  child: Text('Allgemeine Hinweise zu den Rechtsgrundlagen der Datenverarbeitung auf dieser Website', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Sofern Sie in die Datenverarbeitung eingewilligt haben, verarbeiten wir Ihre personenbezogenen Daten auf Grundlage von Art. 6 Abs. 1 lit. a DSGVO bzw. Art. 9 Abs. 2 lit. a DSGVO, sofern besondere Datenkategorien nach Art. 9 Abs. 1 DSGVO verarbeitet werden. Im Falle einer ausdrücklichen Einwilligung in die Übertragung personenbezogener Daten in Drittstaaten erfolgt die Datenverarbeitung außerdem auf Grundlage von Art. 49 Abs. 1 lit. a DSGVO. Sofern Sie in die Speicherung von Cookies oder in den Zugriff auf Informationen in Ihr Endgerät (z. B. via Device-Fingerprinting) eingewilligt haben, erfolgt die Datenverarbeitung zusätzlich auf Grundlage von § 25 Abs. 1 TTDSG. Die Einwilligung ist jederzeit widerrufbar. Sind Ihre Daten zur Vertragserfüllung oder zur Durchführung vorvertraglicher Maßnahmen erforderlich, verarbeiten wir Ihre Daten auf Grundlage des Art. 6 Abs. 1 lit. b DSGVO. Des Weiteren verarbeiten wir Ihre Daten, sofern diese zur Erfüllung einer rechtlichen Verpflichtung erforderlich sind auf Grundlage von Art. 6 Abs. 1 lit. c DSGVO. Die Datenverarbeitung kann ferner auf Grundlage unseres berechtigten Interesses nach Art. 6 Abs. 1 lit. f DSGVO erfolgen. Über die jeweils im Einzelfall einschlägigen Rechtsgrundlagen wird in den folgenden Absätzen dieser Datenschutzerklärung informiert.', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0,bottom: 5.0),
                  child: Text('Widerruf Ihrer Einwilligung zur Datenverarbeitung', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Viele Datenverarbeitungsvorgänge sind nur mit Ihrer ausdrücklichen Einwilligung möglich. Sie können eine bereits erteilte Einwilligung jederzeit widerrufen. Die Rechtmäßigkeit der bis zum Widerruf erfolgten Datenverarbeitung bleibt vom Widerruf unberührt.', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0,bottom: 5.0),
                  child: Text('Widerspruchsrecht gegen die Datenerhebung in besonderen Fällen sowie gegen Direktwerbung (Art. 21 DSGVO)', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('WENN DIE DATENVERARBEITUNG AUF GRUNDLAGE VON ART. 6 ABS. 1 LIT. E ODER F DSGVO ERFOLGT, HABEN SIE JEDERZEIT DAS RECHT, AUS GRÜNDEN, DIE SICH AUS IHRER BESONDEREN SITUATION ERGEBEN, GEGEN DIE VERARBEITUNG IHRER PERSONENBEZOGENEN DATEN WIDERSPRUCH EINZULEGEN; DIES GILT AUCH FÜR EIN AUF DIESE BESTIMMUNGEN GESTÜTZTES PROFILING. DIE JEWEILIGE RECHTSGRUNDLAGE, AUF DENEN EINE VERARBEITUNG BERUHT, ENTNEHMEN SIE DIESER DATENSCHUTZERKLÄRUNG. WENN SIE WIDERSPRUCH EINLEGEN, WERDEN WIR IHRE BETROFFENEN PERSONENBEZOGENEN DATEN NICHT MEHR VERARBEITEN, ES SEI DENN, WIR KÖNNEN ZWINGENDE SCHUTZWÜRDIGE GRÜNDE FÜR DIE VERARBEITUNG NACHWEISEN, DIE IHRE INTERESSEN, RECHTE UND FREIHEITEN ÜBERWIEGEN ODER DIE VERARBEITUNG DIENT DER GELTENDMACHUNG, AUSÜBUNG ODER VERTEIDIGUNG VON RECHTSANSPRÜCHEN (WIDERSPRUCH NACH ART. 21 ABS. 1 DSGVO).', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('WERDEN IHRE PERSONENBEZOGENEN DATEN VERARBEITET, UM DIREKTWERBUNG ZU BETREIBEN, SO HABEN SIE DAS RECHT, JEDERZEIT WIDERSPRUCH GEGEN DIE VERARBEITUNG SIE BETREFFENDER PERSONENBEZOGENER DATEN ZUM ZWECKE DERARTIGER WERBUNG EINZULEGEN; DIES GILT AUCH FÜR DAS PROFILING, SOWEIT ES MIT SOLCHER DIREKTWERBUNG IN VERBINDUNG STEHT. WENN SIE WIDERSPRECHEN, WERDEN IHRE PERSONENBEZOGENEN DATEN ANSCHLIESSEND NICHT MEHR ZUM ZWECKE DER DIREKTWERBUNG VERWENDET (WIDERSPRUCH NACH ART. 21 ABS. 2 DSGVO).', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0,bottom: 5.0),
                  child: Text('Beschwerderecht bei der zuständigen Aufsichtsbehörde', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Im Falle von Verstößen gegen die DSGVO steht den Betroffenen ein Beschwerderecht bei einer Aufsichtsbehörde, insbesondere in dem Mitgliedstaat ihres gewöhnlichen Aufenthalts, ihres Arbeitsplatzes oder des Orts des mutmaßlichen Verstoßes zu. Das Beschwerderecht besteht unbeschadet anderweitiger verwaltungsrechtlicher oder gerichtlicher Rechtsbehelfe.', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0,bottom: 5.0),
                  child: Text('Recht auf Datenübertragbarkeit', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Sie haben das Recht, Daten, die wir auf Grundlage Ihrer Einwilligung oder in Erfüllung eines Vertrags automatisiert verarbeiten, an sich oder an einen Dritten in einem gängigen, maschinenlesbaren Format aushändigen zu lassen. Sofern Sie die direkte Übertragung der Daten an einen anderen Verantwortlichen verlangen, erfolgt dies nur, soweit es technisch machbar ist.', style: const TextStyle(fontSize: 15.0)),
                ),
                 Padding(
                  padding: const EdgeInsets.only(top: 15.0,bottom: 5.0),
                  child: Text('Auskunft, Löschung und Berichtigung', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Sie haben im Rahmen der geltenden gesetzlichen Bestimmungen jederzeit das Recht auf unentgeltliche Auskunft über Ihre gespeicherten personenbezogenen Daten, deren Herkunft und Empfänger und den Zweck der Datenverarbeitung und ggf. ein Recht auf Berichtigung oder Löschung dieser Daten. Hierzu sowie zu weiteren Fragen zum Thema personenbezogene Daten können Sie sich jederzeit an uns wenden.', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0,bottom: 5.0),
                  child: Text('Recht auf Einschränkung der Verarbeitung', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 23.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Sie haben das Recht, die Einschränkung der Verarbeitung Ihrer personenbezogenen Daten zu verlangen. Hierzu können Sie sich jederzeit an uns wenden. Das Recht auf Einschränkung der Verarbeitung besteht in folgenden Fällen:', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('•Wenn Sie die Richtigkeit Ihrer bei uns gespeicherten personenbezogenen Daten bestreiten, benötigen wir in der Regel Zeit, um dies zu überprüfen. Für die Dauer der Prüfung haben Sie das Recht, die Einschränkung der Verarbeitung Ihrer personenbezogenen Daten zu verlangen.', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('•Wenn die Verarbeitung Ihrer personenbezogenen Daten unrechtmäßig geschah/geschieht, können Sie statt der Löschung die Einschränkung der Datenverarbeitung verlangen.', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('•Wenn wir Ihre personenbezogenen Daten nicht mehr benötigen, Sie sie jedoch zur Ausübung, Verteidigung oder Geltendmachung von Rechtsansprüchen benötigen, haben Sie das Recht, statt der Löschung die Einschränkung der Verarbeitung Ihrer personenbezogenen Daten zu verlangen.', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('•Wenn Sie einen Widerspruch nach Art. 21 Abs. 1 DSGVO eingelegt haben, muss eine Abwägung zwischen Ihren und unseren Interessen vorgenommen werden. Solange noch nicht feststeht, wessen Interessen überwiegen, haben Sie das Recht, die Einschränkung der Verarbeitung Ihrer personenbezogenen Daten zu verlangen.', style: const TextStyle(fontSize: 15.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Wenn Sie die Verarbeitung Ihrer personenbezogenen Daten eingeschränkt haben, dürfen diese Daten – von ihrer Speicherung abgesehen – nur mit Ihrer Einwilligung oder zur Geltendmachung, Ausübung oder Verteidigung von Rechtsansprüchen oder zum Schutz der Rechte einer anderen natürlichen oder juristischen Person oder aus Gründen eines wichtigen öffentlichen Interesses der Europäischen Union oder eines Mitgliedstaats verarbeitet werden.', style: const TextStyle(fontSize: 15.0)),
                ),
              ],
            ),
        ),
      ),
    ),
  );
}