//
//  TDAudioManager.h
//  Tied2
//
//  Created by Jon Como on 3/6/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TDAudioClip.h"

@class TDAudioManager;

@protocol TDAudioManagerDelegate <NSObject>

-(void)audioManager:(TDAudioManager *)manager recordedClip:(TDAudioClip *)clip;

@end

@interface TDAudioManager : NSObject

@property (nonatomic, weak) id <TDAudioManagerDelegate> delegate;
@property BOOL isRecording;

+(TDAudioManager *)sharedManager;
+(NSURL *)uniqueWithName:(NSString *)name;

-(void)enableAudioSession;
-(void)record:(BOOL)record;

-(void)playClip:(TDAudioClip *)clip;

@end