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

/**
 Updates the state of all TalentViewController objects
 */
- (void)updateTalentState;

- (void)updateTalentStateFinished;

@end

@implementation TreeViewController

@synthesize talentArray = _talentArray;
@synthesize talentViewDict = _talentViewDict;
@synthesize childDict = _childDict;
//@synthesize pointsInTier = _pointsInTier;
@synthesize pointsInTree = _pointsInTree;
@synthesize characterClassId = _characterClassId;
@synthesize treeNo = _treeNo;
@synthesize state = _state;
@synthesize isSpecTree = _isSpecTree;

@synthesize talentTree = _talentTree;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _talentArray = [[NSArray array] retain];
    _talentViewDict = [[NSMutableDictionary alloc] init];
    _childDict = [[NSMutableDictionary alloc] init];
    
    // Initialize points in tier for 7 tiers
    for (int i = 0; i < MAX_TIERS; i++) {
      _pointsInTier[i] = 0;
    }
//    _pointsInTier = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInteger:0], [NSNumber numberWithInteger:0], [NSNumber numberWithInteger:0], [NSNumber numberWithInteger:0], [NSNumber numberWithInteger:0], [NSNumber numberWithInteger:0], [NSNumber numberWithInteger:0], nil];
    
    _pointsInTree = 0;
    _characterClassId = 0;
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
    if (talent.req) [self.childDict setObject:[talent.talentId stringValue] forKey:[talent.req stringValue]];
    [tvc release];
  }
  
  // Update state for all buttons
  [self updateTalentState];
}

#pragma mark Tree Logic
- (BOOL)canAddPoint:(TalentViewController *)talentView {
  // Check to see if talent is already maxed
  NSInteger maxRank = [talentView.talent.ranks count];
  if (talentView.currentRank == maxRank) {
    return NO;
  }
  
  // Tier point requirement check
  // Points required in tree to add a point into a tier is = tier * 5
  NSInteger tier = [talentView.talent.tier integerValue];
  if (!(self.pointsInTree >= (tier * 5))) {
    return NO;
  }
  
  // Check for parent requirement if exist
  if (talentView.talent.req) {
    TalentViewController *reqTalentViewController = [self.talentViewDict valueForKey:[talentView.talent.req stringValue]];
    if (reqTalentViewController) {
      DLog(@"Talent: %@ found a req: %@", talentView.talent, [[self.talentViewDict valueForKey:[talentView.talent.req stringValue]] talent]);
      
      // Check to see if parent is maxed out
      NSInteger reqMaxRank = [[reqTalentViewController.talent ranks] count];
      if (!(reqTalentViewController.currentRank == reqMaxRank)) {
        return NO;
      }
    }
  }
  
  return YES;
}

- (BOOL)canSubtractPoint:(TalentViewController *)talentView {
  // Check to see if talent is at zero
  if (talentView.currentRank == 0) {
    return NO;
  }
  
  // Tier point requirement check
  // If pointsInTier of all the next tiers summed is not 0
  // Then we can't reduce this tier by less than 5
  NSInteger tier = [talentView.talent.tier integerValue];
  NSInteger sumOfNextTiers = 0;
  for (int i = tier + 1; i < MAX_TIERS; i++) {
    sumOfNextTiers += _pointsInTier[i];
  }
  
  if (sumOfNextTiers > 0) {
    if (_pointsInTier[tier] <= 5) return NO;
  } 
  
  // Check for parent requirement if exist
  // Look in the inverse dependency requirement dictionary to see if this talent has a child
  // IF this talent has a child, make sure child has no points
  NSString *childId = [self.childDict objectForKey:[talentView.talent.talentId stringValue]];
  if (childId) {
    TalentViewController *childTalentViewController = [self.talentViewDict valueForKey:childId];
    if (childTalentViewController) {
      DLog(@"Child: %@ found for Parent: %@", childTalentViewController, talentView);
      
      // If the child's current rank is not 0, return NO
      if (childTalentViewController.currentRank != 0) {
        return NO;
      }
    }
  }
  
  return YES;
}

- (void)updateTalentState {
  // Update state for all talents in this tree
  for (TalentViewController *talentView in [self.talentViewDict allValues]) {
    if (self.state == TreeStateDisabled) {
      talentView.state = TalentStateDisabled;
    } else if (talentView.currentRank == [talentView.talent.ranks count]) {    // Check for max
      talentView.state = TalentStateMaxed;
    } else if ([self canAddPoint:talentView]) {
      talentView.state = TalentStateEnabled;
    } else {
      talentView.state = TalentStateDisabled;
    }
    [talentView updateState];
  }
}

- (void)updateTalentStateFinished {
  for (TalentViewController *talentView in [self.talentViewDict allValues]) {
    [talentView updateStateFinished];
  }
}

- (void)updateState {
  // Tell tree to update state for all talents
  if (self.state == TreeStateEnabled) {
    [self updateTalentState];
  }
  
  // If we are finished, perform finish update state
  if (self.state == TreeStateFinished) {
    [self updateTalentStateFinished];
  }
}

#pragma mark TalentDelegate
- (void)talentTapped:(TalentViewController *)talentView {
  // Tell Calculator
  if (self.delegate) {
    [self.delegate talentTappedForTree:self andTalentView:talentView];
  }
}

- (BOOL)talentAdd:(TalentViewController *)talentView {
  DLog(@"Trying to add a point for talent: %@", talentView.talent);
  
  if (self.state == TreeStateFinished) {
    return NO;
  }
  
  if (self.state == TreeStateDisabled) {
    return NO;
  }
  
  if ([self canAddPoint:talentView]) {
    // Update Tree's points
    self.pointsInTree++;
    
    _pointsInTier[[talentView.talent.tier integerValue]]++;
    
    // Update Talent's current rank
    talentView.currentRank++;
    
    // Tell Calculator
    if (self.delegate) {
      [self.delegate treeAdd:self forTalentView:talentView];
    }
    return YES;
  }
  return NO;
}

- (BOOL)talentSubtract:(TalentViewController *)talentView {
  DLog(@"Trying to subtract a point for talent: %@", talentView.talent);
  
  if ([self canSubtractPoint:talentView]) {
    self.pointsInTree--;
    
    _pointsInTier[[talentView.talent.tier integerValue]]--;
    
    talentView.currentRank--;
    
    // Tell Calculator
    if (self.delegate) {
      [self.delegate treeSubtract:self forTalentView:talentView];
    }
    return YES;
  }
  return NO;
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
  if (_talentArray) [_talentArray release];
//  if (_pointsInTier) [_pointsInTier release];
  if (_talentViewDict) [_talentViewDict release];
  if (_childDict) [_childDict release];
  [super dealloc];
}


@end
