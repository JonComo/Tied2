//
//  TDLineView.m
//  Tied2
//
//  Created by Jon Como on 3/5/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "TDLineView.h"

#import "TDPeerView.h"

@implementation TDLineView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //init
        self.backgroundColor = [UIColor clearColor];
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
    }
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
    //connect nodes
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] setStroke];
    
    for (TDPeerView *peerView in self.peerViews)
    {
        CGContextMoveToPoint(ref, self.centerPeer.frame.origin.x + self.centerPeer.frame.size.width/2, self.centerPeer.frame.origin.y + self.centerPeer.frame.size.height/2);
        
        CGContextAddLineToPoint(ref, peerView.frame.origin.x + peerView.frame.size.width/2, peerView.frame.origin.y + peerView.frame.size.height/2);
    }
    
    CGContextSetLineWidth(ref, 3);
    CGContextStrokePath(ref);
}

@end
