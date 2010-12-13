//
//  TooltipLabel.m
//  WoWTalent
//
//  Created by Peter Shih on 3/17/10.
//  Copyright 2010 OrzWare. All rights reserved.
//

#import "TooltipLabel.h"


@implementation TooltipLabel


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
//	[[NSNotificationCenter defaultCenter] postNotificationName:kDismissPopup object:nil];
//	NSLog(@"touch began label");
//	[super touchesBegan:touches withEvent:event];
//	[self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
//	[super touchesMoved:touches withEvent:event];
//	[self.nextResponder touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//	[super touchesEnded:touches withEvent:event];
//	[self.nextResponder touchesEnded:touches withEvent:event];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
