    //
//  TalentButtonViewController.m
//  WoWTalentPro
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "TalentButtonViewController.h"

@interface TalentButtonViewController (Private)

- (void)updateState;

@end

@implementation TalentButtonViewController

@synthesize tree = _tree;
@synthesize tier = _tier;
@synthesize col = _col;
@synthesize max = _max;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _current = 0;
    _max = 0;
  }
  return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  [_talentButton setImage:[UIImage imageNamed:@"0000.png"] forState:UIControlStateNormal];
  
  // Update labels, border image, graying out
  [self updateState];
}

- (void)updateState {
  _talentLabel.text = [NSString stringWithFormat:@"%d/%d", _current, _max];
}

- (IBAction)talentAction {
  // Check points spent
  // Check max
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
  if(_talentButton) [_talentButton release];
  if(_talentBorderView) [_talentBorderView release];
  if(_talentLabel) [_talentLabel release];
  [super dealloc];
}


@end
