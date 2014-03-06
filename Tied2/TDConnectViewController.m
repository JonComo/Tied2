//
//  TDConnectViewController.m
//  Tied2
//
//  Created by Jon Como on 3/5/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "TDConnectViewController.h"

#import "TDAudioManager.h"

#import "TDSessionManager.h"
#import "TDMeshView.h"

@interface TDConnectViewController () <TDSessionManagerDelegate, TDAudioManagerDelegate>
{
    TDSessionManager *sessionManager;
    TDMeshView *meshView;
}

@end

@implementation TDConnectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[TDAudioManager sharedManager] enableAudioSession];
    [[TDAudioManager sharedManager] setDelegate:self];
    
    sessionManager = [[TDSessionManager alloc] initWithDelegate:self];
    [sessionManager start];
    
    meshView = [[TDMeshView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    meshView.name = [UIDevice currentDevice].name;
    [self.view addSubview:meshView];
    
    UIButton *buttonBroadcast = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonBroadcast.frame = CGRectMake(0, self.view.frame.size.height-88, 320, 88);
    [buttonBroadcast setTitle:@"Talk" forState:UIControlStateNormal];
    [buttonBroadcast addTarget:self action:@selector(startBroadcast) forControlEvents:UIControlEventTouchDown];
    [buttonBroadcast addTarget:self action:@selector(endBroadcast) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBroadcast];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)startBroadcast
{
    [[TDAudioManager sharedManager] record:YES];
}

-(void)endBroadcast
{
    [[TDAudioManager sharedManager] record:NO];
}

-(void)audioManager:(TDAudioManager *)manager recordedClip:(TDAudioClip *)clip
{
    [sessionManager sendClip:clip];
}

-(void)sessionManagerStateChanged:(TDSessionManager *)manager
{
    
}

-(void)sessionManager:(TDSessionManager *)manager foundPeer:(MCPeerID *)peerId
{
    [meshView addPeerId:peerId];
}

-(void)sessionManager:(TDSessionManager *)manager lostPeer:(MCPeerID *)peerId
{
    [meshView removePeerId:peerId];
}

@end
