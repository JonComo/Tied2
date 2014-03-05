//
//  TDMeshView.h
//  Tied2
//
//  Created by Jon Como on 3/5/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCPeerID;
@class TDPeerView;

@interface TDMeshView : UIView

@property (nonatomic, copy) NSString *name;
@property CGSize nodeSize;

-(void)addPeerId:(MCPeerID *)peerId;
-(void)removePeerId:(MCPeerID *)peerId;

@end