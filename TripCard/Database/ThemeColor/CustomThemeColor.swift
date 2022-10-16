//
//  CustomThemeColor.swift
//  TripCard
//
//  Created by 신동희 on 2022/10/13.
//

import UIKit
import RealmSwift


final class CustomThemeColor: Object {
    @Persisted var title: String
    @Persisted var backgroundColor: Data
    @Persisted var cellBackgroundColor: Data
    @Persisted var textColor: Data
    @Persisted var buttonColor: Data
    @Persisted var selectedColor: Data
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    
    convenience init(title: String, background: UIColor, cellBackground: UIColor, textColor: UIColor, buttonColor: UIColor, selectedColor: UIColor) {
        self.init()
        
        self.title = title
        self.backgroundColor = colorToData(color: background)
        self.cellBackgroundColor = colorToData(color: cellBackground)
        self.textColor = colorToData(color: textColor)
        self.buttonColor = colorToData(color: buttonColor)
        self.selectedColor = colorToData(color: buttonColor)
    }
    
    
    func colorToData(color: UIColor) -> Data {
        return (try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)) ?? Data()
    }
}
