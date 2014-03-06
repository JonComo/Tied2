//
//  TDAudioClip.h
//  Tied2
//
//  Created by Jon Como on 3/6/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDAudioClip : NSObject

@property (nonatomic, copy) NSString *groupId; //groups short clips together so they play in order
@property (nonatomic, strong) NSURL *URL;

@end