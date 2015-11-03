//    Copyright 2015 Shakhzod Ikromov (aka GRiM2D)
//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

import SpriteKit

class GMMultiLineLabel:SKNode {
    
    var lineNodes:[SKLabelNode] = []
    
    var verticalAlignmentMode: SKLabelVerticalAlignmentMode
    var horizontalAlignmentMode: SKLabelHorizontalAlignmentMode
    
    private var _fontName: String?
    var fontName: String? {
        get {
            return self._fontName
        }
        
        set {
            self._fontName = newValue
            self.validate()
        }
    }
    
    private var _text: String?
    var text: String? {
        get {
            return self._text
        }
        
        set {
            self._text = newValue
            self.validate()
        }
    }
    
    private var _fontSize: CGFloat
    var fontSize: CGFloat {
        get {
            return self._fontSize
        }
        set {
            self._fontSize = newValue
            self.validate()
        }
    }
    
    private var _fontColor: UIColor?
    var fontColor: UIColor? {
        get {
            return self._fontColor
        }
        
        set {
            self._fontColor = newValue
            self.validate()
        }
    }
    
    var size:CGSize {
        get {
            return self.calculateAccumulatedFrame().size
        }
    }
    
    init(fontNamed fontName:String?) {
        self._fontName = fontName
        self.verticalAlignmentMode = .Top
        self.horizontalAlignmentMode = .Left
        self._fontSize = UIFont.systemFontSize()
        
        super.init()
        
        self.validate()
    }
    
    func validate() {
        self.removeChildrenInArray(self.lineNodes)
        self.lineNodes.removeAll()
        self.text?.enumerateLines(self.enumeate)
    }
    
    private func enumeate(line:String, inout stop:Bool) {
        let lineNode = SKLabelNode(fontNamed: self.fontName)
        lineNode.verticalAlignmentMode = self.verticalAlignmentMode
        lineNode.horizontalAlignmentMode = self.horizontalAlignmentMode
        lineNode.fontColor = self.fontColor
        lineNode.fontSize = self.fontSize
        lineNode.text = line
        lineNode.position = CGPoint(x: 0, y: -CGFloat(self.lineNodes.count) * (self.fontSize + 5))
        
        self.addChild(lineNode)
        self.lineNodes.append(lineNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
