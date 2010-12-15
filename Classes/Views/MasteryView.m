//
//  MasteryView.m
//  TalentPad
//
//  Created by Peter Shih on 12/14/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "MasteryView.h"
#import "PrimarySpellButton.h"

@implementation MasteryView

@synthesize masteryIcon = _masteryIcon;
@synthesize masteryNameLabel = _masteryNameLabel;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {

  }
  return self;
}

- (void)dealloc {
  if (_masteryIcon) [_masteryIcon release];
  if (_masteryNameLabel) [_masteryNameLabel release];
  [super dealloc];
}

@end
