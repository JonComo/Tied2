//
//  TDPeerView.m
//  Tied2
//
//  Created by Jon Como on 3/5/14.
//  Copyright (c) 2014 Jon Como. All rights reserved.
//

#import "TDPeerView.h"
#import "TDGraphics.h"

@import MultipeerConnectivity;

@implementation TDPeerView
{
    UILabel *labelName;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        //Add label
        float p = 6;
        labelName = [[UILabel alloc] initWithFrame:CGRectMake(p, p, frame.size.width - p*2, frame.size.height - p*2)];
        [labelName setTextAlignment:NSTextAlignmentCenter];
        [labelName setFont:[UIFont systemFontOfSize:12]];
        labelName.adjustsFontSizeToFitWidth = YES;
        labelName.lineBreakMode = NSLineBreakByWordWrapping;
        labelName.numberOfLines = 20;
        [self addSubview:labelName];
        [labelName setTextColor:[TDGraphics light]];
    }
    return self;
}

-(void)setPeerId:(MCPeerID *)peerId
{
    _peerId = peerId;
    
    //update UI
    labelName.text = peerId.displayName;
}

-(void)setName:(NSString *)name
{
    _name = name;
    
    labelName.text = name;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *circle = [UIBezierPath new];
    
    [circle addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.height/2) radius:rect.size.width/2-2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    circle.lineWidth = 3;
    
    CGContextSetStrokeColorWithColor(context, [TDGraphics light].CGColor);
    
    [circle stroke];
}

@end
