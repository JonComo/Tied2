//
//  TDSessionManager.m
//  Tied2
//
//  Created by Jon Como on 3/1/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "TDSessionManager.h"

#define TDServiceType @"joncomo-tied"

@import MultipeerConnectivity;

@interface TDSessionManager () <MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate>

@end

@implementation TDSessionManager
{
    MCPeerID *_peerId;
    MCSession *session;
    MCNearbyServiceAdvertiser *advertiser;
    MCNearbyServiceBrowser *_browser;
}

-(id)initWithDelegate:(id<TDSessionManagerDelegate>)delegate
{
    if (self = [super init]) {
        //init
        _delegate = delegate;
        
        _peerId = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
        session = [[MCSession alloc] initWithPeer:_peerId];
        session.delegate = self;
        
        advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_peerId discoveryInfo:nil serviceType:TDServiceType];
        advertiser.delegate = self;
        
        _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_peerId serviceType:TDServiceType];
        _browser.delegate = self;
        
        _allPeers = [NSMutableArray array];
        _connectedPeers = [NSMutableArray array];
    }
    
    return self;
}

-(void)start
{
    [advertiser startAdvertisingPeer];
    [_browser startBrowsingForPeers];
}

#pragma MCNearbyServiceAdvertiserDelegate

-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler
{
    NSLog(@"Should auto connect");
    invitationHandler(YES, session);
}

-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"Error advertising: %@", error);
}

#pragma MCNearbyServiceBrowserDelegate

-(void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"Error browsing");
}

-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSLog(@"Found peer: %@", peerID);
    
    if (![self.allPeers containsObject:peerID])
        [self.allPeers addObject:peerID];
    
    if ([self.delegate respondsToSelector:@selector(sessionManager:foundPeer:)])
        [self.delegate sessionManager:self foundPeer:peerID];
    
    [browser invitePeer:peerID toSession:session withContext:NULL timeout:30];
}

-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    if ([self.allPeers containsObject:peerID])
        [self.allPeers removeObject:peerID];
    
    if ([self.delegate respondsToSelector:@selector(sessionManager:lostPeer:)])
        [self.delegate sessionManager:self lostPeer:peerID];
    
    NSLog(@"Lost peer: %@", peerID);
}

#pragma MCSessionDelegate

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSLog(@"Session state changed! %i", state);
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSLog(@"Got data");
}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

@end
