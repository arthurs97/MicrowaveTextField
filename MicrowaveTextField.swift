/*
MicrowaveTextField.swift
Arthur Shi
1 August, 2017

An auto-formatting textfield for time entry
*/

import UIKit

///Main class
class MicrowaveTextField: UITextField {
    //MARK: Properties
    var shouldShowHundredths: Bool = false {
        didSet { placeholder = placeholderStr }
    }
    var shouldShowHours: Bool = false {
        didSet { placeholder = placeholderStr }
    }
    
    var value: Double = 0.0
    var color: UIColor = .blue
    
    fileprivate var placeholderStr: String {
        var ph = "0:00"
        if shouldShowHundredths { ph = ph + ".00" }
        if shouldShowHours { ph = "0:0" + ph }
        return ph
    }
    
    //MARK: Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        delegate = self
        placeholder = placeholderStr
    }
}

///Delegate
extension MicrowaveTextField: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        keyboardType = .numberPad
        addToolBar()
        return true
    }
    
     func textFieldDidEndEditing(_ textField: UITextField) {
         value = Double.timeFromString(string: self.text ?? "0:00")
     }
}

///Helper functions
extension MicrowaveTextField {
    /*
    String formatting functions
    */
    func textFieldDidChange(_ sender: UITextField) {
        let currText = sender.text ?? placeholderStr
        let formattedTime = updateWithFormat(text: currText)
        self.text = formattedTime
        self.value = Double.timeFromString(string: formattedTime)
    }

    fileprivate func updateWithFormat(text: String) -> String {
        let digitsOnly = text.numOnlyString()
        return reformatTime(str: digitsOnly)
    }

    private func reformatTime(str: String) -> String {
        var modString = str
        let phLen = placeholderStr.numOnlyString().length
        
        //prepend 0's if necessary
        if str.length < phLen {
            for _ in str.length..<phLen {
                modString = "0" + modString
            }
        }
        
        //trim prefix 0 if necessary
        if modString.length > phLen && modString.characters.first == "0" {
            modString = modString.substring(from: 1)
        }

        var idx = modString.length
        //insert . before hundredths if necessary
        if shouldShowHundredths {
            idx -= 2
            modString = modString.substring(to: idx) + "." + modString.substring(from: idx)
        }
        
        //insert : to separate minutes and seconds
        idx -= 2
        modString = modString.substring(to: idx) + ":" + modString.substring(from: idx)

        //insert : to separate hours and minutes.
        if shouldShowHours {
            idx -= 2
            modString = modString.substring(to: idx) + ":" + modString.substring(from: idx)
        }
        
        return modString
    }
    //End string formatting functions

    /*
    Creates and adds a toolbar with a done button to the keyboard
    */
    fileprivate func addToolBar() {
        //create the done button
        let keyboardDoneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                        target: self,
                                                        action: #selector(donePressed))
        keyboardDoneBarButtonItem.tintColor = color
        
        //create the toolbar 
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.tintColor = color
        keyboardToolbar.barStyle = .default
        keyboardToolbar.sizeToFit()
        
        //add the button to the toolbar
        keyboardToolbar.setItems([keyboardDoneBarButtonItem], animated: true)

        //add a separating bar to the toolbar
        let bottomBorderLayer = CALayer()
        bottomBorderLayer.frame = CGRect(x: 0,
                                         y: keyboardToolbar.bounds.size.height - 2,
                                         width: keyboardToolbar.bounds.size.width,
                                         height: 2)
        bottomBorderLayer.backgroundColor = color.cgColor
        keyboardToolbar.layer.addSublayer(bottomBorderLayer)

        //add the toolbar
        inputAccessoryView = keyboardToolbar
    }

    /*
    Dismiss the keyboard
    */
    func donePressed() {
        endEditing(true)
    }
}

/*
Extensions for internal use only
*/
fileprivate extension String {
    var length: Int {
        return self.characters.count
    }

    func numOnlyString() -> String {
        return self.characters.reduce("") { (c1, c2) -> String in
            guard c2.isDigit() else { return c1 }
            return "\(c1)\(c2)"
        }
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

fileprivate extension Character {
    func isDigit() -> Bool {
        return "0"..."9" ~= self
    }
}

fileprivate extension Double {
    static func timeFromString(string: String) -> Double {
        let components = string.trimmingCharacters(in: .whitespaces).components(separatedBy: ":")
        
        if components.count > 3 || components.count <= 0 {
            print("there were too many or too few time components (timeInSeconds(string:))")
            return 0.0
        }

        switch components.count {
        case 1:
            return Double(components[0])!
        case 2:
            let minutes = Double(components[0]), seconds = Double(components[1])
            return minutes! * 60.0 + seconds!
        case 3:
            let hours = Double(components[0]), minutes = Double(components[1]), seconds = Double(components[2])
            return hours! * 3600.0 + minutes! * 60.0 + seconds!
        default:
            return 0.0
        }
    }
}

