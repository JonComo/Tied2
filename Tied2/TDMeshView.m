//
//  TDMeshView.m
//  Tied2
//
//  Created by Jon Como on 3/5/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "TDMeshView.h"
#import "TDPeerView.h"
#import "TDLineView.h"

#import "JCMath.h"

@import MultipeerConnectivity;

@implementation TDMeshView
{
    NSMutableArray *peerViews;
    TDLineView *lineView;
    
    UIDynamicAnimator *animator;
    UIDynamicItemBehavior *itemBehavior;
    UICollisionBehavior *collision;
    
    UIAttachmentBehavior *touchJoint;
    
    TDPeerView *centerPeer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self){
        // Initialization code
        peerViews = [NSMutableArray array];
        
        animator = [UIDynamicAnimator new];
        
        collision = [UICollisionBehavior new];
        
        itemBehavior = [UIDynamicItemBehavior new];
        itemBehavior.allowsRotation = NO;
        itemBehavior.resistance = 0.95;
        
        [animator addBehavior:collision];
        [animator addBehavior:itemBehavior];
        
        _nodeSize = CGSizeMake(90, 90);
        
        
        lineView = [[TDLineView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:lineView];
        lineView.peerViews = peerViews;
    }
    return self;
}

-(void)setName:(NSString *)name
{
    _name = name;
    
    if (!centerPeer)
        centerPeer = [self addCenterPeerWithName:name];
    
    centerPeer.name = name;
    lineView.centerPeer = centerPeer;
}

-(void)addPeerId:(MCPeerID *)peerId
{
    [self addPeerViewWithId:peerId attachedToPeerView:centerPeer];
}

-(TDPeerView *)addCenterPeerWithName:(NSString *)name
{
    TDPeerView *peerView = [self addPeerViewWithId:nil attachedToPeerView:nil];
    
    peerView.name = name;
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    peerView.frame = CGRectMake(center.x - self.nodeSize.width/2, center.y - self.nodeSize.height/2, self.nodeSize.width, self.nodeSize.height);
    
    //Connect it to the center
    
    UIAttachmentBehavior *joint = [[UIAttachmentBehavior alloc] initWithItem:peerView attachedToAnchor:center];
    joint.damping = 0.9;
    joint.frequency = 0.5;
    [animator addBehavior:joint];
    peerView.joint = joint;
    
    [collision addItem:peerView];
    
    return peerView;
}

-(TDPeerView *)addPeerViewWithId:(MCPeerID *)peerId attachedToPeerView:(TDPeerView *)anchorView
{
    TDPeerView *newPeer = [[TDPeerView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - self.nodeSize.width/2, self.frame.size.height/2 - self.nodeSize.height/2, self.nodeSize.width, self.nodeSize.height)];
    
    newPeer.peerId = peerId;
    
    [self addSubview:newPeer];
    [peerViews addObject:newPeer];
    
    //Dynamics
    [collision addItem:newPeer];
    [itemBehavior addItem:newPeer];
    
    if (anchorView){
        UIAttachmentBehavior *joint = [[UIAttachmentBehavior alloc] initWithItem:newPeer attachedToItem:anchorView];
        joint.length = self.nodeSize.width * 3/2;
        joint.damping = 0.8;
        joint.frequency = 2;
        [animator addBehavior:joint];
        newPeer.joint = joint;
    }
    
    return newPeer;
}

-(void)removePeerId:(MCPeerID *)peerId
{
    TDPeerView *peerViewToRemove;
    
    for (TDPeerView *peerView in peerViews){
        if (peerView.peerId == peerId){
            //remove this one
            peerViewToRemove = peerView;
        }
    }
    
    [peerViews removeObject:peerViewToRemove];
    
    [itemBehavior removeItem:peerViewToRemove];
    [collision removeItem:peerViewToRemove];
    [animator removeBehavior:peerViewToRemove.joint];
    
    [peerViewToRemove removeFromSuperview];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    
    TDPeerView *touchedPeer;
    
    float dist = FLT_MAX;
    for (TDPeerView *peerView in peerViews){
        float testDist = [JCMath distanceBetweenPoint:location andPoint:CGPointMake(peerView.frame.origin.x + peerView.frame.size.width/2, peerView.frame.origin.y + peerView.frame.size.height/2) sorting:NO];
        if (testDist > 100) continue;
        if (testDist < dist){
            dist = testDist;
            touchedPeer = peerView;
        }
    }
    
    if (touchedPeer)
    {
        touchJoint = [[UIAttachmentBehavior alloc] initWithItem:touchedPeer attachedToAnchor:location];
        [animator addBehavior:touchJoint];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    [touchJoint setAnchorPoint:location];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touchJoint){
        [animator removeBehavior:touchJoint];
        touchJoint = nil;
    }
}

@end
