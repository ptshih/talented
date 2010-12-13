//
//  DismissView.m
//  TalentPad
//
//  Created by Peter Shih on 3/15/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "DismissView.h"

@implementation DismissView

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
  }
  return self;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
  // Dismiss the tooltip
	[super touchesBegan:touches withEvent:event];
	[self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	[super touchesMoved:touches withEvent:event];
	[self.nextResponder touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	[self.nextResponder touchesEnded:touches withEvent:event];
}

- (void)dealloc {
  [super dealloc];
}

@end
