# Final Report 

01-02-2018 - Eindproject voor de ‘Minor Programmeren’

## DingDung

DingDung is een app waar je je toilet op kunt zetten, zodat mensen met hoge nood daar, mits het jou uitkomt, gebruik van kunnen maken. Ook wanneer jij zelf in nood bent kun je een toilet ‘request’ doen bij een toilet in de buurt, welk geaccepteerd of geweigerd kan worden door de eigenaar. 

![](https://github.com/StefanBonestroo/DingDung/blob/master/doc/App%20demo.png)

### App Design

#### LogInViewController

![](https://github.com/StefanBonestroo/DingDung/blob/master/doc/LogInViewController.PNG)

Dit is het eerste scherm dat je te zien krijgt bij het opstarten, hier loggen de users in.

De authenticatie van een user gebeurt met behulp van Google’s [Firebase](https://firebase.google.com/).

Deze ‘UIViewController’ class bevat de volgende belangrijke onderdelen:

* @IBAction - *submitButtonPressed*

	Met het drukken op ‘submit’ wordt eerst gecheckt of er aan alle voorwaarden voldaan worden. Vervolgens wordt met deze informatie naar Firebase een request gestuurd, welk ons verteld of een user succesvol is ingelogd.
	
* func *signUpAlert*

	Maakt het mogelijk om een pop-upje met error informatie weer te geven, ook Firebase error beschrijvingen (user bestaat niet etc.). Deze specifieke functie wordt in een paar andere viewControllers ook gebruikt.
	
* “Don’t have an account? SIGN UP”. Het klikken op SIGN UP triggert een segue naar de SignUpViewController.

### SignUpViewController

![](https://github.com/StefanBonestroo/DingDung/blob/master/doc/SignUpViewController.PNG)

Hier kunnen users een account aanmaken. 

Op een gelijkmatige wijze wordt Firebase weer gerequest om een nieuwe user aan te maken, mits de ingevoerde informatie correct is.

Deze ‘UIViewController’ class bevat de volgende belangrijke onderdelen:

* @IBAction - *createNewAccount*

	Met het drukken op deze ‘submit’ worden er een aantal checks uitgevoerd en wordt de functie ‘makeNewUser()’ aangeroepen.
	
* func *makeNewUser()*

	Instrueert Firebase een nieuwe user aan te maken, wanneer dit goed gaat wordt de segue naar de CreateProfileViewController getriggerd.

### CreateProfileViewController

![](https://github.com/StefanBonestroo/DingDung/blob/master/doc/CreateProfileViewController.PNG)

Een user zal in 3 verschillende text velden zijn/haar ‘Username’, ‘Toilet Name’, en ‘Toilet Description’ moeten invoeren.

De ‘UIViewController’ class bevat de volgende belangrijke onderdelen:

* een *prepare(for: segue)* met de identifier “toCamera”

	Hier worden checks voor correcte data invoer gerund (min/max lengte Toilet Description etc.), en wanneer correct wordt ‘storeData()’ aangeroepen
	
* func *storeData*

	Dit is het eerste moment dat er gebruik gemaakt wordt van de ‘Firebase database’, in een grote ‘users’ tree wordt de tak met het unieke ‘userID’ van de huidig ingelogde geupdate met de ingevoerde waarden uit dit scherm.

### CameraViewController (ook een CreateAddressViewController)

![](https://github.com/StefanBonestroo/DingDung/blob/master/doc/CameraViewController.PNG) ![](https://github.com/StefanBonestroo/DingDung/blob/master/doc/CameraPicker.PNG)

Hier kan de user zowel een profielfoto nemen, als zijn/haar adres informatie invoeren. Deze adres informatie wordt bij een geaccepteerde request verstrekt aan de zender.

De ‘UIViewController’ en ‘UIImagePickerController class bevatten de volgende belangrijke onderdelen:

* func *setUpCamera* 

	Deze functie maakt ‘UIImagePickerController()’ object welk modally over de ‘UIViewController’ wordt weergegeven.
	
* func *imagePickerController( picker, didFinishPickingMediaWithInfo: …)*

	Wanneer de ‘Use Photo’ knop wordt ingedrukt, heeft de user een photo gemaakt en gekozen. Vervolgens wordt ‘saveImage()’ aangeroepen.
	
* func *saveImage*

	De genomen foto wordt gecomprimeerd en geupload naar de ‘Firebase storage’. De path naar deze foto in de storage wordt vervolgens opgeslagen in de database. Vervolgens wordt de ImagePicker gedismissed en wordt ‘viewWillAppear()’ aangeroepen. De foto is al genomen, dus wordt showAddressScreen aangeroepen
	
* func *showAddressScreen*

	Alle benodigde onderdelen voor dit scherm worden ge un-hide en de user kan zijn/haar adres invoeren. De informatie wordt, voor dat het wordt verstuurd, tot coordinaten omgezet om geldigheid te checken, en om deze op te slaan in de database. Ook het adres wordt opgeslagen in de database

### ToiletMapViewController

![](https://github.com/StefanBonestroo/DingDung/blob/master/doc/ToiletMapViewController.PNG)

### ToiletDetailsViewController

![](https://github.com/StefanBonestroo/DingDung/blob/master/doc/ToiletDetailsViewController.PNG)

### MyRequestViewController

![](https://github.com/StefanBonestroo/DingDung/blob/master/doc/MyRequestViewController.PNG)

### RequestedViewController

![](https://github.com/StefanBonestroo/DingDung/blob/master/doc/RequestedViewController.PNG)

#### RequestTableViewCell

### Models:

#### Toilet

#### Request

#### mapStyle

## Database tree
![](https://github.com/StefanBonestroo/DingDung/blob/master/doc/completTree.PNG)




