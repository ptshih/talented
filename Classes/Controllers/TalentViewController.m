//
//  TalentViewController.m
//  TalentPad
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "TalentViewController.h"
#import "Talent.h"

@interface TalentViewController (Private)

@end

@implementation TalentViewController

@synthesize talent = _talent;
@synthesize delegate = _delegate;
@synthesize state = _state;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _state = TalentStateDisabled;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}


- (void)dealloc {
  if(_talentBorderView) [_talentBorderView release];
  if(_talentLabel) [_talentLabel release];
  [super dealloc];
}


@end