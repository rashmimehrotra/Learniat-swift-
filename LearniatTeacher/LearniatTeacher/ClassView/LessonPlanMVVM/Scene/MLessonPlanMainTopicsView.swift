//
//  MLessonPlanMainTopicsView.swift
//  Learniat Teacher
//
//  Created by Deepak on 10/13/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
import UIKit

class MLessonPlanMainTopicsView: UIView {
    
    let mViewModel = MLessonPlanMainTopicsViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func LoadMainTopicsForClassId(classId:String) {
        
    }
}
