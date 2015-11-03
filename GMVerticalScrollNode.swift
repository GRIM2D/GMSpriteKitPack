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

class GMVerticalScrollNode: SKNode {
    var size:CGSize {
        get {
            return self._cropper._size
        }
        
        set {
            self._cropper._size = newValue
            self.validate()
        }
    }
    
    private let _cropper:_GMCropper
    init(size:CGSize) {
        _cropper = _GMCropper(withSize: size)
        super.init()
        
        super.addChild(_cropper)
    }
    
    func validate() {
        self._cropper.validate()
    }
    
    
    
    
    //  MARK: API
    override func addChild(node: SKNode) {
        self._cropper.group.addChild(node)
    }
    
    override func removeAllChildren() {
        self._cropper.group.removeAllChildren()
    }
    
    override func removeChildrenInArray(nodes: [SKNode]) {
        self._cropper.group.removeChildrenInArray(nodes)
    }
    
    override var children:[SKNode] {
        get {
            return self._cropper.group.children
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class _GMCropper:SKCropNode {
    var _size:CGSize
    let mask:SKSpriteNode
    let group:SKNode
    init(withSize size:CGSize) {
        self._size = size
        self.mask = SKSpriteNode(texture: nil, color: UIColor.redColor(), size: size)
        self.mask.anchorPoint = CGPoint(x: 0, y: 0)
        
        self.group = SKNode()
        
        super.init()
        self.maskNode = mask
        self.userInteractionEnabled = true
        self.addChild(self.group)
    }
    
    func validate() {
        self.mask.size = self._size
        
        group.removeAllActions()
        let action = SKAction.customActionWithDuration(1, actionBlock: self.inert)
        group.runAction(action)
    }
    
    //  MARK: TouchHandlers
    var touchPos:CGPoint = CGPoint(x: 0, y: 0)
    var isScrolling:Bool = false
    var scrollPos2:CGPoint?
    var scrollPos1:CGPoint?
    override private func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let pos = touches.first!.locationInNode(self.parent!)
        touchPos.x = pos.y - group.position.y
        touchPos.y = pos.y
        scrollPos2 = pos
        isScrolling = false
        self.group.removeAllActions()
    }
    
    override private func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let pos = touches.first!.locationInNode(self.parent!)
        
        if !isScrolling {
            if abs(pos.y - touchPos.y) > 10 {
                isScrolling = true
            }
            return
        }
        
        scrollPos1 = scrollPos2
        scrollPos2 = pos
        
        group.position.y = pos.y - touchPos.x
    }
    
    override private func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !isScrolling {
            return
        }
        
        let action = SKAction.customActionWithDuration(1, actionBlock: self.inert)
        group.runAction(action)
    }
    
    func _slideToEnd(node:SKNode, time:CGFloat) {
        let rect = node.calculateAccumulatedFrame()
        if rect.height < self._size.height {
            return
        }
        if rect.minY < 0 {
            return
        }
        
//        node.removeAllActions()
        node.position.y += (0 - rect.minY) * time
    }
    
    func _slideToTop(node:SKNode, time:CGFloat) {
        let rect = node.calculateAccumulatedFrame()
        if rect.height < self._size.height {
            node.position.y += (self._size.height - rect.maxY) * time
            return
        }
        if rect.maxY > self._size.height {
            return
        }
        
//        node.removeAllActions()
        node.position.y += (self._size.height - rect.maxY) * time
    }
    
    func _inert(node:SKNode, time:CGFloat) {
        guard let pos1 = scrollPos1 else {
            return
        }
        guard let pos2 = scrollPos2 else {
            return
        }
        
        node.position.y += (pos2.y - pos1.y) * (1 - time)
    }
    
    func inert(node:SKNode, time:CGFloat) {
        _slideToTop(node, time: time)
        _slideToEnd(node, time: time)
        _inert(node, time: time)
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
