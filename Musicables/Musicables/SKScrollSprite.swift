//
//  SKScrollSprite.swift
//  Musicables
//
//  Created by Isaías Lima on 28/05/15.
//  Copyright (c) 2015 Fantastic 4. All rights reserved.
//

import SpriteKit

@objc protocol SKScrollSpriteDelegate {
    
    optional func scrollSpriteDidScroll(scrollSprite: SKScrollSprite)
    
}

class SKScrollSprite: SKSpriteNode, UIScrollViewDelegate {
    
    private var contentSprite: SKSpriteNode!
    
    private func validContentOffsetFromContentOffset(contentOffset: CGPoint) -> CGPoint {
        return CGPointMake(min(max(self.minimumContentOffset.x, contentOffset.x), self.maximumContentOffset.x), min(max(self.minimumContentOffset.y, contentOffset.y), self.maximumContentOffset.y))
    }
    
    private var contentSpriteDefaultPosition: CGPoint!
    private var contentSpriteCurrentPosition: CGPoint!
   
// MARK - initialization

    convenience init(size: CGSize, contentSize: CGSize) {
        self.init(color: nil, size: size)
        self.contentSprite = SKSpriteNode(color: nil, size: contentSize)
        self.contentSize = contentSize
        self.contentSprite.position = self.contentSpriteDefaultPosition
        self.addChild(self.contentSprite)
        self.userInteractionEnabled = true
    }
    
    func scrollSpriteWithSize(size: CGSize, contentSize: CGSize) -> SKScrollSprite {
        var scroll = SKScrollSprite(size: size, contentSize: contentSize)
        return scroll
    }
    
// MARK - hierarchy overloading
    
    override func addChild(node: SKNode) {
        if node == self.contentSprite {
            super.addChild(node)
        } else {
            self.contentSprite.addChild(node)
        }
    }
    
// MARK - managing the display of content
    
    var contentSize: CGSize!
    var contentOffset: CGPoint!
    
    func setContentSize(contentSize: CGSize) {
        if !CGSizeEqualToSize(self.contentSize, contentSize) {
            self.contentSize = CGSizeMake(max(self.size.width, contentSize.width), min(self.size.height, contentSize.height))
        }
    }
    
    func setContentOffset(contentOffset: CGPoint) {
        if !CGPointEqualToPoint(self.contentOffset, contentOffset) {
            self.setContentOffset(contentOffset, animated: false)
        }
    }
    
    func setContentOffset(contentOffset: CGPoint, animated: Bool) {
        if !CGPointEqualToPoint(self.contentOffset, contentOffset) {
            self.contentOffset = self.validContentOffsetFromContentOffset(contentOffset)
            if animated {
                self.contentSprite.runAction(SKAction.moveTo(self.contentSpriteCurrentPosition, duration: 0.5))
            } else {
                self.contentSprite.position = self.contentSpriteCurrentPosition
            }
        }
    }
    
    var maximumContentOffset: CGPoint!
    var minimumContentOffset: CGPoint!
    
    func minContentOffset() -> CGPoint {
        return CGPointZero
    }
    
    func maxContentOffset() -> CGPoint {
        return CGPointMake(self.contentSize.width - self.size.width, self.contentSize.height - self.size.height)
    }
    
    func contentSpriteCurPosition() -> CGPoint {
        return CGPointMake(self.contentSpriteDefaultPosition.x + self.contentOffset.x, self.contentSpriteDefaultPosition.y + self.contentOffset.y)
    }
    
    func contentSpriteDefPosition() -> CGPoint {
        return CGPointMake(-(self.contentSize.width - self.size.width)/2, -(self.contentSize.height - self.size.height)/2)
    }
    
// MARK - managing scrolling
    
    func scrollRectToVisible(rect: CGRect, animated: Bool) {
        
    }
    
// MARK - responding to touch events
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        
        let touch = touches.first as! UITouch
        var location = touch.locationInNode(self)
        var previousLocation = touch.previousLocationInNode(self)
        
        var contentOffset = self.contentOffset
        var deltaX = location.x - previousLocation.x
        var deltaY = location.y - previousLocation.y
        contentOffset.x = contentOffset.x + deltaX
        contentOffset.y = contentOffset.y + deltaY
        self.contentOffset = contentOffset
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        super.touchesCancelled(touches, withEvent: event)
    }
    
// MARK - managing the delegate
    
    weak var delegate: SKScrollSpriteDelegate?
    
}


