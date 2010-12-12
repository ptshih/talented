//
//  TreeViewController.m
//  TalentPad
//
//  Created by Peter Shih on 12/11/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "TreeViewController.h"
#import "Talent.h"
#import "Constants.h"

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
@synthesize talentViewDict = _talentViewDict;
@synthesize pointsInTier = _pointsInTier;
@synthesize pointsInTree = _pointsInTree;
@synthesize classId = _classId;
@synthesize treeNo = _treeNo;
@synthesize state = _state;
@synthesize isSpecTree = _isSpecTree;

@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _talentArray = [[NSArray array] retain];
    _talentViewDict = [[NSMutableDictionary alloc] init];
    
    // Initialize points in tier for 7 tiers
    _pointsInTier = [[NSArray alloc] initWithObjects:[NSNumber numberWithInteger:0], [NSNumber numberWithInteger:0], [NSNumber numberWithInteger:0], [NSNumber numberWithInteger:0], [NSNumber numberWithInteger:0], [NSNumber numberWithInteger:0], [NSNumber numberWithInteger:0], nil];
    
    _pointsInTree = 0;
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
    tvc.delegate = self;
    tvc.view.frame = CGRectMake(((SPACING_X + T_WIDTH) * [talent.col integerValue]), ((SPACING_Y + T_HEIGHT) * [talent.tier integerValue]), tvc.view.frame.size.width, tvc.view.frame.size.height);
    [self.view addSubview:tvc.view];
    [self.talentViewDict setObject:tvc forKey:[talent.talentId stringValue]];
    [tvc updateState];
    [tvc release];
  }
}

#pragma mark Tree Logic
- (BOOL)canAddPoint:(Talent *)talent {
  // Tier point requirement check
  // Points required in tree to add a point into a tier is = tier * 5
  NSInteger tier = [talent.tier integerValue];
  if (!(self.pointsInTree >= (tier * 5))) {
    return NO;
  }
  
  // Check for parent requirement if exist
  if (talent.req) {
    TalentViewController *reqTalentViewController = [self.talentViewDict valueForKey:[talent.req stringValue]];
    if (reqTalentViewController) {
      DLog(@"Talent: %@ found a req: %@", talent, [[self.talentViewDict valueForKey:[talent.req stringValue]] talent]);
      
      // Check to see if parent is maxed out
      NSInteger maxRank = [[reqTalentViewController.talent ranks] count];
      if (!(reqTalentViewController.currentRank == maxRank)) {
        return NO;
      }
    }
  }
  
  return YES;
}

- (BOOL)canSubtractPoint:(Talent *)talent {
  return NO;
}

#pragma mark TalentDelegate
- (void)talentAdd:(TalentViewController *)sender {
  DLog(@"talent add in Tree");
  if ([self canAddPoint:sender.talent]) {
    // Update Tree's points
    self.pointsInTree++;
    
    sender.currentRank++;
    [sender updateState];
  }
}

- (void)talentSubtract:(id)sender {
  DLog(@"talent subtract in Tree");
  [sender updateState];
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
  if(_talentViewDict) [_talentViewDict release];
  [super dealloc];
}


@end
