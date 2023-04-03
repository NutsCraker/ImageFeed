
import UIKit
extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
extension UIColor {
   // static let yPGray = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
   // static let yPRed = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1)
    static var ypBlack: UIColor { UIColor(named: "YPBlack") ?? UIColor.black }
    static var ypBlue: UIColor { UIColor(named: "YPBlue") ?? UIColor.blue }
    static var ypRed: UIColor { UIColor(named: "YPRed") ?? UIColor.red }
    static var ypBlackGround: UIColor { UIColor(named: "YPBlackGround") ?? UIColor.darkGray }
    static var ypGray: UIColor { UIColor(named: "YPGray") ?? UIColor.gray }
    static var ypWhite: UIColor { UIColor(named: "YPWhite") ?? UIColor.white }
}
