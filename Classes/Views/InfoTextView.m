//
//  InfoTextView.m
//  WoWTalent
//
//  Created by Peter Shih on 12/18/09.
//  Copyright 2009 OrzWare. All rights reserved.
//

#import "InfoTextView.h"


@implementation InfoTextView


- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    // Initialization code
  }
  return self;
}

- (BOOL)canBecomeFirstResponder {
	return NO;
}


// Disable copy cut and paste
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	BOOL retValue = YES;	
	if (action == @selector(paste:) || action == @selector(cut:) || action == @selector(copy:))
		retValue = NO;
	else
		retValue = YES;
	return retValue;
}

- (void)dealloc {
  [super dealloc];
}


@end
