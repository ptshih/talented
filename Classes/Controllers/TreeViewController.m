//
//  TreeViewController.m
//  TalentPad
//
//  Created by Peter Shih on 12/11/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "TreeViewController.h"
#import "TalentViewController.h"
#import "Talent.h"

#define MARGIN_X 15.0
#define MARGIN_Y 15.0
#define SPACING_X 12.0
#define SPACING_Y 12.0
#define T_WIDTH 68.0
#define T_HEIGHT 68.0

@interface TreeViewController (Private)

- (void)prepareTalents;

@end

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
    _talentArray = [[NSArray array] retain];
    _classId = 0;
    _treeNo = 0;
    _state = TreeStateDisabled;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Prepare all the talents for this tree
  [self prepareTalents];
}

#pragma mark Prepare Talents
- (void)prepareTalents {
  for (Talent *talent in self.talentArray) {
    TalentViewController *tvc = [[TalentViewController alloc] initWithNibName:@"TalentViewController" bundle:nil];
    tvc.talent = talent;
    tvc.view.frame = CGRectMake(((SPACING_X + T_WIDTH) * [talent.col integerValue]), ((SPACING_Y + T_HEIGHT) * [talent.tier integerValue]), tvc.view.frame.size.width, tvc.view.frame.size.height);
    [self.view addSubview:tvc.view];
    [tvc release];
  }
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
