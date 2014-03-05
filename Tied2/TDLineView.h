//
//  TDLineView.h
//  Tied2
//
//  Created by Jon Como on 3/5/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDPeerView;

@interface TDLineView : UIView

@property (nonatomic, weak) TDPeerView *centerPeer;
@property (nonatomic, weak) NSMutableArray *peerViews;

@end
