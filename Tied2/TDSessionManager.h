//
//  TDSessionManager.h
//  Tied2
//
//  Created by Jon Como on 3/1/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MultipeerConnectivity;

@class TDSessionManager;
@class TDAudioClip;

@protocol TDSessionManagerDelegate <NSObject>

-(void)sessionManager:(TDSessionManager *)manager foundPeer:(MCPeerID *)peerId;
-(void)sessionManager:(TDSessionManager *)manager lostPeer:(MCPeerID *)peerId;
-(void)sessionManagerStateChanged:(TDSessionManager *)manager;

@end

@interface TDSessionManager : NSObject

@property (nonatomic, weak) id <TDSessionManagerDelegate> delegate;

@property (nonatomic, strong) MCSession *session;

-(id)initWithDelegate:(id<TDSessionManagerDelegate>)delegate;
-(void)start;

-(void)sendClip:(TDAudioClip *)clip;

@end