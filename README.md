# DingDung
[![BCH compliance](https://bettercodehub.com/edge/badge/StefanBonestroo/DingDung?branch=master)](https://bettercodehub.com/)

Stefan Bonestroo - 10500790

[![](https://img.youtube.com/vi/IP22FeanJfg/hqdefault.jpg)](https://www.youtube.com/watch?v=IP22FeanJfg)

## App Goals
* Mensen toiletten in de buurt laten vinden, openbaar of bij mensen thuis
* Mensen de mogelijkheid geven een toilet profiel te maken, en hun toilet beschikbaar te stellen voor gasten.
* Mensen connecten en een community bouwen

### Het Probleem
*“Geerte Piening (23) kreeg de boete tijdens een stapavond in 2015. Nadat ze de kroeg had verlaten, moest ze op straat plotseling nodig plassen. Ze mocht het café niet meer in. Er waren in de omgeving nergens openbare toiletten voor vrouwen te vinden. Daarom besloot ze haar behoefte te doen achter een betonblok. Drie politieagenten zagen het en slingerden Piening op de bon.”* - [Source - NRC Handelsblad](https://www.nrc.nl/nieuws/2017/09/18/rechter-handhaaft-boete-voor-wildplassen-a1573866)

Recent werd iedereen door dit relletje weer even herinnert aan die behoeften waar wij als mens aan geketend zijn. Met name in de stad, en met name voor vrouwen, zijn er onvoldoende openbare toiletten waar de grote en kleine behoeften gedaan kunnen worden. Google Maps heeft wel wat openbare toiletten geregistreerd, maar dit zijn vaak enkel de plaskrullen (althans, in Amsterdam). Ook de kinderen (en hun ouders) zijn vaak de dupe van ons chronisch tekort aan wc’s, zij kunnen immers niet zo lang ophouden als volwassenen dat kunnen. Zou het niet fijn zijn als mensen hun toilet beschikbaar kunnen stellen voor de medemens met hoge nood? DingDung wil hier uitkomst te bieden.

### De Oplossing
Met DingDung kunnen in hun omgeving zoeken naar beschikbare toiletten. Op een kaart kun je, naast de beschikbare openbare toiletten die Google Maps heeft geregistreerd, ook kleine kamertjes in je omgeving zoeken die bij mensen thuis, in restaurants, of op kantoor gebruikt mogen worden. Als het toilet open voor gebruik is. Kun je een aanvraag doen die de eigenaar van het toilet kan accepteren (of afwijzen). Vervolgens kun je na gebruik je ervaring met het toilet en diens eigenaren delen met andere gebruikers door een ‘rating’ te geven en/of een comment achter te laten.

### Het Motto
DingDung hoopt uitkomst te bieden op de vervelende momenten, en het ‘dagje uit’ zorgeloos te laten verlopen. Daar bovenop wil DingDung een community van toilet-gebruikers creëren en verbinden, en het poep-en-pies-taboe te doorbreken.

### Technische Verduidelijking

#### Data Bronnen & Externe Componenten 
* [Google Maps API](https://developers.google.com/maps/solutions/store-locator/nyc-subway-locator) - om toiletten in te laden en weer te geven

* [Google Firebase](https://firebase.google.com/) - om users te laten inloggen en weergeven samen met hun ratings, comments, en nabijheid.

#### Vergelijkbare Apps
* [Couchsurfing](https://www.couchsurfing.com/mobile-hangouts) - De request en rating componenten zijn vergelijkbaar met de componenten die in deze app te vinden zijn.

* [Roamler](https://itunes.apple.com/nl/app/roamler/id440588804) - Hier kunnen requests gedaan worden, daarnaast krijg je op acceptatie van de request verder info. Op een (Google Maps?) kaartje wordt ook de nabijheid van een bepaalde plek weergegeven. Poeper zal een vergelijkbaar systeem gebruiken.
