//
//  myCustomSlider.swift
//  WIT
//
//  Created by Shay Kremer on 1/9/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import Foundation

import UIKit

public class myCustomSlider: UISlider {
    
    var label: UILabel
    var labelXMin: CGFloat?
    var labelXMax: CGFloat?
    var labelText: ()->String = { "" }
    
    required public init?(coder aDecoder: NSCoder) {
        label = UILabel()
        super.init(coder: aDecoder)
        self.addTarget(self, action: Selector(("onValueChanged:")), for: .valueChanged)
        
    }
    func setup(){
        labelXMin = frame.origin.x + 16
        labelXMax = frame.origin.x + self.frame.width - 14
        let labelXOffset: CGFloat = labelXMax! - labelXMin!
        let valueOffset: CGFloat = CGFloat(self.maximumValue - self.minimumValue)
        let valueDifference: CGFloat = CGFloat(self.value - self.minimumValue)
        let valueRatio: CGFloat = CGFloat(valueDifference/valueOffset)
        let labelXPos = CGFloat(labelXOffset*valueRatio + labelXMin!)
        label.frame = CGRectMake(labelXPos,self.frame.origin.y - 25, 200, 25)
        label.text = self.value.description
        self.superview!.addSubview(label)
        
    }
    func updateLabel(){
        label.text = labelText()
        let labelXOffset: CGFloat = labelXMax! - labelXMin!
        let valueOffset: CGFloat = CGFloat(self.maximumValue - self.minimumValue)
        let valueDifference: CGFloat = CGFloat(self.value - self.minimumValue)
        let valueRatio: CGFloat = CGFloat(valueDifference/valueOffset)
        let labelXPos = CGFloat(labelXOffset*valueRatio + labelXMin!)
        label.frame = CGRectMake(labelXPos - label.frame.width/2,self.frame.origin.y - 25, 200, 25)
        label.textAlignment = NSTextAlignment.center
        self.superview!.addSubview(label)
    }
    public override func layoutSubviews() {
        labelText = { self.value.description }
        setup()
        updateLabel()
        super.layoutSubviews()
        super.layoutSubviews()
    }
    func onValueChanged(sender: myCustomSlider){
        updateLabel()
    }
}
