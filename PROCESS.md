# Process book

## day 2
Vandaag heb ik gewerkt aan het afronden van de Sign Up functie. Hierbij hoorde ook de nodige problemen met de ImagePickerViewController() uit de UIKit. Aangezien dit een programmatisch geinitialiseerde view controller is, zijn segues vanaf die picker onmogelijk te sturen. Ik heb uiteindelijk een tussenschermpje geplaatst voor tijdens het maken van een foto zodat, wanneer deze sluit, er later nog een uitleg van de app ingeplakt kan worden (het liefst in ‘pagina view’).

## day 3
Het implementeren van de Log In functies verliep voorspoedig, het Log Out deel was wat lastiger. Aangezien ik een Nav bar in een Tab bar heb op de pagina waar ik uitlog, was het  een beetje een gedoe om een mooie en succesvolle ‘unwind’ plaats te laten vinden. Heb het uiteindelijk goed gefixed.

## day 4
Vandaag heb ik de database backend gemaakt. Bijna alle ingevulde profiel gegevens (adres en toiletnaam etc.) worden bij het maken van een account opgeslagen in de database.

Ik heb besloten van het 'uitleg-tussenschermpje' een scherm te maken waar de user zijn/haar adres invult. In dezelfde view controller als de camera ligt deze tot na het nemen van de foto nog verborgen.

Morgen ben ik van plan het laatste deel hiervan te doen, dat is het storen van de genomen toilet foto aka profielfoto. Hier moet ik de Firebase Storage gebruiken en het linkje naar de profielfoto in de database opslaan. Verder moet ik ook even beslissen in welke taal ik mijn repo wil presenteren, dit is nu een beetje inconsequent.

![](https://github.com/StefanBonestroo/DingDung/blob/master/doc/cameraViewController.png)

## day 5
De implementatie van de hele database/storage backend is nu compleet en klaar om opgehaald te worden in andere views. Een referentie naar storage locatie van de profielfoto wordt ook opgeslagen in de database. Verder heb ik gebruik gemaakt van de CLGeocoder( ) om het ingevulde adres om te zetten in coordinaten, zodat het adres zelf enkel bij een geaccepteerde request opgehaald hoeft te worden (coordinaten zijn hier voor het weergeven op de map).

Ik twijfel alleen nog over de camera viewcontroller, die nu een view deelt met het adres-invul schermpje (misschien moet ik die voor overzicht splitsen). Ik moet nog even uitvinden hoe ik die opgehaalde data tijdelijk in het geheugen van de telefoon kan houden, zodat deze niet bij elke segue opgehaald moet worden.

## day 6
Vandaag heb ik de mapView verder uitgebreid met een 'eigen locatie' marker op de map. Het ophalen van de toiletten heb ik een beginnetje mee gemaakt, morgen ga ik daar mee verder. 

## day 7
Deze dag heb ik gewerkt aan het plaatsen van markers op de map. Dit bleek nog een uitdaging, omdat ik nog moest leren werken met het MVC structuur concept. Ik wil namelijk wel dat extra info niet opgehaald hoeft te worden in het 'details' scherm. 

Hiermee los ik ook het probleem op dat ik op dag 5 had, in het 'Toilet()' model worden nu alle toiletten op het scherm opgeslagen.

## day 8
Alle toiletten worden nu correct weergegeven op de map in een overzichtelijke view. Morgen ga ik werken aan het user profile, dit zodat de beschikbaarheid van een toilet snel geimplementeerd kan worden

## day 9
Het user profiel wordt nu op 1 van de tabs weergegeven met een 'availability schakelaar', zodat mensen ervoor kunnen kiezen hun toilet op onbeschikbaar te zetten. 

Verder heb ik kleine detail pop-upjes aan de map toegevoegd, die openen als je op een toilet klikt. Hierop staat de naam van het toilet en username van de user. Ik heb een klein beginnetje gemaakt met het detail scherm, hier wil ik namelijk heen als ik op 1 zo'n infoWindow (pop-upje) druk.

## day 10
Het klikken op de pop-upjes blijkt een lastige taak. Er is weinig documentatie beschikbaar wat betreft de uitleg en hoe/wanneer de delegate van de mapView gerund wordt. Er is een didTapInfoWindow of functie waar ik de segue naar het detail scherm in zet, maar deze voert niet uit.

## day 11
Vandaag kwam ik er achter dat het initializen met 'mapView.delegate = self' niet in de viewDidLoad() moest gebeuren, maar in de viewWillAppear(). Volgensmij is het namelijk zo dat de delegate + code eerder vastgelegd wordt dan viewDidLoad(), aldus viewWillAppear() (welk eerder uitvoerd).

Verder heb ik het detailscherm + segues geimplementeerd. Dit scherm geeft nu de details van het betreffende toilet weer, en de data van dit toilet wordt met de segue meegegeven.

## day 12
Het indienen van een request in het details scherm creeërt een nieuwe request in de database. Dit heb ik in een transactieachtige structuur gezet, in een andere tabel als de users.

![](https://github.com/StefanBonestroo/DingDung/blob/master/doc/transactions.png)

Het ophalen van de statussen van de requests en de verwerking daarvan (hoe negeer je verlopen transacties zonder veel tijd te verliezen etc.) wordt nog lastig te implementeren

## day 13
Het ophalen van een request die de user heeft ingediend in de MyRequestViewController() verloopt ok, maar ik heb mijn twijfels bij de scalability van de huidige implementatie. Een search naar de huidige transactie zou onderaan moeten beginnen, aangezien de requests op chronologische volgorde in de database staan (childByAutoId() door Firebase), maar dit blijkt niet te kunnen met Firebase. 

Ik moet de hele lijst ophalen en die vervolgens sorteren (wat tot nu toe ook niet gaat, het sorten van een lijst van dicts lukt niet) of de lijst doorspitten en children die vallen onder 'history' negeren. 

## day 14 
Ik heb besloten om inderdaad een aparte history aan te maken, dit is eigenlijk ook wel handig voor implementatie in de toekomst.
![](https://github.com/StefanBonestroo/DingDung/blob/master/doc/database.png)

De tableView is nu af en het senden van requests werkt op 1 dingetje na: Wanneer iemand in 1 sessie een request heeft gestuurd, heeft gecancelled, en vervolgens een andere request wil sturen, wordt deze nieuwe gelijk gecancelled. Ik weet nog niet precies waardoor dit komt.

## day 15
Ik kwam er achter dat de cancel button actie werd geactiveerd omdat er nog een observer op stond: Bij het indienen van een nieuwe request merkt deze .observe(.childAdded...) dat er een kind bijgekomen is en cancelled deze gelijk. Ik heb eerst een hele tijd geprobeerd ipv .observe, .observeSingleEvent(of: .value...) te gebruiken, maar hier kon ik om een of andere manier niet door heen loopen... Verder kon ik ook geen .observeSingleEvent(of: .childAdded...) gebruiken, want deze pakt maar 1 enkel kind.

Uiteindelijk heb ik besloten wel .observe te gebruiken in combinatie met .childAdded, alleen heb zet ik de observers gelijk stop na het uitvoeren van de database request (netjes is het niet, maar het werkt goed):

![](https://github.com/StefanBonestroo/DingDung/blob/master/doc/exitObserver.png)

## day 16
De laatste kleine bugs en lay-out dingetjes heb ik verholpen. Ook heb ik wat kleine toevoegingen gemaakt zoals:
* Een mogelijkheid om het aanmaken van je account te hervatten, mocht deze vroegtijdig zijn afgebroken. Een simpele database check na het inloggen kijkt of de benodigde children (.hasChild) aanwezig zijn, en segued naar daar waar info ontbreekt.
* Een mogelijkheid om plaatjes aan te klikken en ze hiermee te vergrootten (meer een lay-out dingetje)

## day 17 
Ik ben er van overtuigd dat mijn app nu af is. Er zijn nog heel wat leuke dingen die ik extra had kunnen implementeren, had ik meer tijd gehad (en wellicht ook genomen) zoals bijv.:
* De mogelijkheid voor users om openingstijden voor hun toilet in te stellen, en hiermee de beschikbaarheid te automatiseren
* De mogelijkheid om andere users te raten voor het gebruik van jouw toilet (en hun gezelligheid), en de mogelijkheid om gerate te worden voor de kwaliteit van jouw toilet
* Een 'History' scherm in de ontvangen requests lijst <- De back-end hiervan heb ik al bijna afgeschreven.
* De mogelijkheid om een user een 'max requests per day' te laten instellen, zodat die niet overspoelt wordt door aanvragen.
