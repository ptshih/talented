//
//  PrimarySpellView.m
//  TalentPad
//
//  Created by Peter Shih on 12/14/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "PrimarySpellView.h"
#import "PrimarySpellButton.h"

@implementation PrimarySpellView

@synthesize primarySpellIcon = _primarySpellIcon;
@synthesize primarySpellNameLabel = _primarySpellNameLabel;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {

  }
  return self;
}

- (void)dealloc {
  if (_primarySpellIcon) [_primarySpellIcon release];
  if (_primarySpellNameLabel) [_primarySpellNameLabel release];
  [super dealloc];
}

@end
