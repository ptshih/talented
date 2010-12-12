//
//  TreeViewController.m
//  TalentPad
//
//  Created by Peter Shih on 12/11/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "TreeViewController.h"
#import "TalentViewController.h"

@implementation TreeViewController

@synthesize talentArray = _talentArray;
@synthesize pointsInTier = _pointsInTier;
@synthesize classId = _classId;
@synthesize treeNo = _treeNo;
@synthesize state = _state;
@synthesize isSpecTree = _isSpecTree;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _classId = 0;
    _treeNo = 0;
    _state = TreeStateDisabled;
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
  if(_talentArray) [_talentArray release];
  if(_pointsInTier) [_pointsInTier release];
  [super dealloc];
}


@end
