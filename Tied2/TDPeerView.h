//
//  TDPeerView.h
//  Tied2
//
//  Created by Jon Como on 3/5/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCPeerID;

@interface TDPeerView : UIView

@property (nonatomic, weak) MCPeerID *peerId;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, weak) UIAttachmentBehavior *joint;

@end