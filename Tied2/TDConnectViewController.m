//
//  TDConnectViewController.m
//  Tied2
//
//  Created by Jon Como on 3/5/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "TDConnectViewController.h"

#import "TDSessionManager.h"
#import "TDMeshView.h"

@interface TDConnectViewController () <TDSessionManagerDelegate>
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
    
    sessionManager = [[TDSessionManager alloc] initWithDelegate:self];
    [sessionManager start];
    
    meshView = [[TDMeshView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    meshView.name = [UIDevice currentDevice].name;
    [self.view addSubview:meshView];
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
