# Process book

## day 2
Vandaag heb ik gewerkt aan het afronden van de Sign Up functie. Hierbij hoorde ook de nodige problemen met de ImagePickerViewController() uit de UIKit. Aangezien dit een programmatisch geinitialiseerde view controller is, zijn segues vanaf die picker onmogelijk te sturen. Ik heb uiteindelijk een tussenschermpje geplaatst voor tijdens het maken van een foto zodat, wanneer deze sluit, er later nog een uitleg van de app ingeplakt kan worden (het liefst in ‘pagina view’).

## day 3
Het implementeren van de Log In functies verliep voorspoedig, het Log Out deel was wat lastiger. Aangezien ik een Nav bar in een Tab bar heb op de pagina waar ik uitlog, was het  een beetje een gedoe om een mooie en succesvolle ‘unwind’ plaats te laten vinden. Heb het uiteindelijk goed gefixed.

## day 4
Vandaag heb ik de database backend gemaakt. Bijna alle ingevulde profiel gegevens (adres en toiletnaam etc.) worden bij het maken van een account opgeslagen in de database.

Ik heb besloten van het 'uitleg-tussenschermpje' een scherm te maken waar de user zijn/haar adres invult. In dezelfde view controller als de camera ligt deze tot na het nemen van de foto nog verborgen.

Morgen ben ik van plan het laatste deel hiervan te doen, dat is het storen van de genomen toilet foto aka profielfoto. Hier moet ik de Firebase Storage gebruiken en het linkje naar de profielfoto in de database opslaan. Verder moet ik ook even beslissen in welke taal ik mijn repo wil presenteren, dit is nu een beetje inconsequent

# Design ideetjes:

* Openingstijden toilet
* Users/Owners raten
* Max requests instellen
