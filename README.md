# MicrowaveTextField
An auto-formatting text field for time entry (iOS)

MicrowaveTextField is a UITextField subclass that supports auto-formatting, right to left time entry (as a microwave does). It shows minutes and seconds (m:ss) by default.<br/> 

MTF can be customized to your use case by setting the following properties in its parent view controller's viewDidLoad(): <br/>
MTF.shouldShowHundredths: Bool - If set to true, the MTF displays and formats with two decimal places (m:ss.hh). False by default. <br/>
MTF.shouldShowHours: Bool - If set to true, the MTF displays and formats with hours (h:mm:ss). False by default. Both shouldShowHundredths and shouldShowHours can be true (h:mm:ss.hh). <br/>
MTF.color: UIColor - Sets the color of the separating bar on the keyboard's 'done' button toolbar. UIColor.blue by default. <br/>

The user's entered value in seconds (as a Double) can be accessed through the MTF.value property. <br/>
If the user's time is needed as a formatted string, simply use the MTF.text property inherited from UITextField. <br/>
