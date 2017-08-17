internal extension String {
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

internal extension Character {
    func isDigit() -> Bool {
        return "0"..."9" ~= self
    }
}

internal extension Double {
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
