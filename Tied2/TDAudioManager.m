//
//  TDAudioManager.m
//  Tied2
//
//  Created by Jon Como on 3/6/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "TDAudioManager.h"

#import "TDSessionManager.h"

#define DOCUMENTS [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0]

@import AVFoundation;

@interface TDAudioManager () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    AVAudioRecorder *recorder;
    AVAudioPlayer *audioPlayer;
    
    BOOL isNewGroup;
    TDAudioClip *clipRecording;
}

@end

@implementation TDAudioManager

+(TDAudioManager *)sharedManager
{
    static TDAudioManager *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

+(NSURL *)uniqueWithName:(NSString *)name
{
    int count = 0;
    NSURL *URL;
    do {
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%i", DOCUMENTS, name, count]];
        
        count ++;
    } while ([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]);
    
    return URL;
}

-(id)init
{
    if (self = [super init]) {
        //init
        _isRecording = NO;
    }
    
    return self;
}

-(void)enableAudioSession
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                        error:nil];
    
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    
    [audioSession setActive:YES error:nil];
}

-(void)record:(BOOL)record
{
    self.isRecording = record;
    
    if (record){
        isNewGroup = YES;
        [self recordAudioClip];
    }else{
        [recorder stop]; //stop recording
        NSLog(@"END OF GROUP ___________ UNIQUE ID");
    }
}

-(void)playClip:(TDAudioClip *)clip
{
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:clip.URL error:&error];
    
    if (error) NSLog(@"Error: %@", error);
    
    [audioPlayer play];
}

-(void)recordAudioClip
{
    if (isNewGroup){
        isNewGroup = NO;
        
        NSLog(@"RECORDING NEW GROUP ___________ UNIQUE ID");
    }
    
    NSURL *outputURL = [TDAudioManager uniqueWithName:@"audio"];
    
    clipRecording = [TDAudioClip new];
    clipRecording.URL = outputURL;
    clipRecording.groupId = @"UNIQUEGRP";
    
    NSLog(@"Recording to %@", outputURL);
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    
    [recordSettings setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSettings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSettings setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    
    [recordSettings setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSettings setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSettings setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    NSError *error = nil;
    
    recorder = [[AVAudioRecorder alloc]
                initWithURL:outputURL
                settings:recordSettings
                error:&error];
    
    recorder.delegate = self;
    
    if (error)
        NSLog(@"AUDIO ERROR: %@", error);
    
    [recorder recordForDuration:3];
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    //Send this clip out
    if ([self.delegate respondsToSelector:@selector(audioManager:recordedClip:)])
        [self.delegate audioManager:self recordedClip:clipRecording];
    
    if (self.isRecording){
        [self recordAudioClip];
    }
}

@end