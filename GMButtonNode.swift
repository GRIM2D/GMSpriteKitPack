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

class GMButtonNode:SKSpriteNode {
    
    let upTexture:SKTexture
    let pressedTexture:SKTexture?
    let disabledTexture:SKTexture?
    let labelNode:SKLabelNode
    
    var alphaWhenPressed:CGFloat = 0.8
    var alphaWhenDisabled:CGFloat = 0.5
    var onClick:(() -> Void)?
    
    init(upTexture:SKTexture, pressedTexture:SKTexture?, disabledTexture:SKTexture?) {
        self.upTexture = upTexture
        self.pressedTexture = pressedTexture
        self.disabledTexture = disabledTexture
        
        self.labelNode = SKLabelNode(fontNamed: FONT_HEAVY)
        
        super.init(texture: upTexture, color: UIColor.clearColor(), size: upTexture.size())
        
        self.labelNode.position = CGPoint(x: 0, y: -self.upTexture.size().height / 2)
        self.labelNode.verticalAlignmentMode = .Center
        self.labelNode.horizontalAlignmentMode = .Center
        self.addChild(self.labelNode)
        
        self.userInteractionEnabled = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchPos = touches.first!.locationInNode(self.parent!)
        guard self.containsPoint(touchPos) else {
            return
        }
        
        self.alpha *= self.alphaWhenPressed
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.alpha /= self.alphaWhenPressed
        let touchPos = touches.first!.locationInNode(self.parent!)
        guard self.containsPoint(touchPos) else {
            return
        }
        
        self.onClick?()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
   
}
