//
//  PrimarySpellButton.m
//  TalentPad
//
//  Created by Peter Shih on 12/14/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "PrimarySpellButton.h"


@implementation PrimarySpellButton

@synthesize primarySpellIndex = _primarySpellIndex;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _primarySpellIndex = 0;
  }
  return self;
}


- (void)dealloc {
  [super dealloc];
}


@end
