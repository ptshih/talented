//
//  TreeViewController.m
//  TalentPad
//
//  Created by Peter Shih on 12/11/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "TreeViewController.h"
#import "Talent.h"
#import "TalentTree.h"
#import "Constants.h"
#import "UIView+Additions.h"

#define MARGIN_X 15.0
#define MARGIN_Y 15.0
#define SPACING_X 12.0
#define SPACING_Y 12.0
#define T_WIDTH 68.0
#define T_HEIGHT 68.0

@interface TreeViewController (Private)

- (UIImage *)getBackgroundImage;
- (void)updateMasteryGlow;
- (void)prepareArrows;
- (void)prepareBackground;
- (void)prepareTalents;

/**
 Updates the state of all TalentViewController objects
 */
- (void)updateTalentState;

- (void)updateTalentStateFinished;

@end

@implementation TreeViewController

@synthesize talentArray = _talentArray;
@synthesize talentViewArray = _talentViewArray;
@synthesize talentViewDict = _talentViewDict;
@synthesize childDict = _childDict;
@synthesize arrowViewDict = _arrowViewDict;
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
    _talentViewArray = [[NSMutableArray alloc] init];
    _talentViewDict = [[NSMutableDictionary alloc] init];
    _arrowViewDict = [[NSMutableDictionary alloc] init];
    _childDict = [[NSMutableDictionary alloc] init];
    
    // Initialize points in tier for 7 tiers
    for (int i = 0; i < MAX_TIERS; i++) {
      _pointsInTier[i] = 0;
    }
    
    _pointsInTree = 0;
    _characterClassId = 0;
    _treeNo = 0;
    _state = TreeStateDisabled;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self prepareBackground];
  
  // Prepare all the talents for this tree
  [self prepareTalents];
  
  // Prepare arrows
  [self prepareArrows];
  
  [self updateMasteryGlow];
}

- (IBAction)dismissPopover {
  if (self.delegate) {
    [self.delegate dismissPopoverFromTree:self];
  }
}

- (UIImage *)getBackgroundImage {
  return [UIImage imageNamed:[NSString stringWithFormat:@"%d-%d-bg.jpg", self.characterClassId, self.treeNo]];
}

#pragma mark Prepare Talents
- (void)prepareBackground {
  _backgroundView.image = [self getBackgroundImage];
}

- (void)prepareArrows {
  // Read the childDict and generate arrows
//  DLog(@"Preparing arrows for dict: %@ for tree: %d", self.childDict, self.treeNo);

  for (NSString *parentId in [self.childDict allKeys]) {
    NSMutableArray *children = [self.childDict objectForKey:parentId];
    for (NSString *childId in children) {
      TalentViewController *parent = [self.talentViewDict objectForKey:parentId];
      TalentViewController *child = [self.talentViewDict objectForKey:childId];
      
      NSInteger parentTier = [parent.talent.tier integerValue];
      NSInteger childTier = [child.talent.tier integerValue];
      NSInteger parentCol = [parent.talent.col integerValue];
      NSInteger childCol = [child.talent.col integerValue];
      NSInteger dx = childCol - parentCol;
      NSInteger dy = childTier - parentTier;
  //    DLog(@"parent coords tier: %d, col: %d", parentTier, parentCol);
  //    DLog(@"child coords tier: %d, col: %d", childTier, childCol);
  //    DLog(@"dx: %d, dy: %d", dx, dy);
      DLog(@"Arrow: %d-%d-color.png", dx, dy);
      
      UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d-%d-gray.png", dx, dy]] highlightedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d-%d-yellow.png", dx, dy]]];
      arrowView.highlighted = NO;
      
      if (dx < 0) {
        arrowView.top = parent.view.top + floor(parent.view.height / 2) - 9;
        arrowView.left = parent.view.left - arrowView.width + 4;
      } else if (dx == 0) {
        arrowView.top = parent.view.bottom - 8;
        arrowView.left = parent.view.left + floor(parent.view.width / 2) - 9;
      } else {
        arrowView.top = parent.view.top + floor(parent.view.height / 2) - 9;
        arrowView.left = parent.view.right - 7;
      }

      [self.arrowViewDict setObject:arrowView forKey:childId];
      [self.view addSubview:arrowView];
      [arrowView release];
    }
  }
}

- (void)prepareTalents {
  for (Talent *talent in self.talentArray) {
    TalentViewController *tvc = [[TalentViewController alloc] initWithNibName:@"TalentViewController" bundle:nil];
    tvc.talent = talent;
    tvc.delegate = self;
    tvc.view.frame = CGRectMake(8.0 + ((SPACING_X + T_WIDTH) * [talent.col integerValue]), 8.0 + ((SPACING_Y + T_HEIGHT) * [talent.tier integerValue]), tvc.view.frame.size.width, tvc.view.frame.size.height);
    [self.view addSubview:tvc.view];
    [self.talentViewArray addObject:tvc];
    [self.talentViewDict setObject:tvc forKey:[talent.talentId stringValue]];
    if (talent.req) {
      // A talent may have multiple children
      // Need to store an array in the value
      NSMutableArray *valueArray = [self.childDict valueForKey:[talent.req stringValue]];
      if (valueArray) {
        [valueArray addObject:[talent.talentId stringValue]];
        [self.childDict setObject:valueArray forKey:[talent.req stringValue]];
      } else {
        [self.childDict setObject:[NSMutableArray arrayWithObject:[talent.talentId stringValue]] forKey:[talent.req stringValue]];
      }

//      [self.childDict setObject:[talent.talentId stringValue] forKey:[talent.req stringValue]];
    }
    [tvc release];
  }
  
  // Update state for all buttons
  [self updateTalentState];
}

#pragma mark Tree Logic
- (BOOL)canAddPoint:(TalentViewController *)talentView {
  // Check to see if tree is enabled
  if (self.state != TreeStateEnabled) {
    return NO;
  }
  
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
      DLog(@"Talent: %@ found a req: %@", talentView.talent.talentName, [[[self.talentViewDict valueForKey:[talentView.talent.req stringValue]] talent] talentName]);
      
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
  // Ask Calculator if we can subtract points based on points spent in other trees
  if (self.isSpecTree) {
    if (![self.delegate canSubtract:self]) {
      if (self.pointsInTree <= 31) {
        return NO;
      }
    }
  }
  
  // Check to see if talent is at zero
  if (talentView.currentRank == 0) {
    return NO;
  }
  
  
  // Tier point requirement check
  // If pointsInTier of all the next tiers summed is not 0
  // Then we can't reduce this tier by less than 5
  NSInteger tier = [talentView.talent.tier integerValue];
  NSInteger sumOfNextTiers = 0;
  NSInteger maxTier = 0;
  for (int i = tier + 1; i < MAX_TIERS; i++) {
    if (_pointsInTier[i] > 0) {
      sumOfNextTiers += _pointsInTier[i];
      maxTier = i;
    }
  }
  
//  if (sumOfNextTiers > 0 && _pointsInTier[tier] <= 5) return NO;

  // If there are points after our tier, check again
  // Otherwise proceed
  NSInteger pointsToTier = 0;
  NSInteger pointsRequiredAtTier = tier * 5 + 5;
  NSInteger pointsRequiredAtMaxTier = maxTier * 5;
  NSInteger sumOfAllTiersToMaxTier = 0;
  if (sumOfNextTiers > 0) {
    // Check our own tier to see if we satisfy the minimum point req
    for (int k = 0; k <= tier; k++) {
      pointsToTier += _pointsInTier[k];
    }
    if (pointsToTier <= pointsRequiredAtTier) return NO;
    
    // If we are tier 0
    if (_pointsInTier[tier] <= 5 && pointsToTier <= pointsRequiredAtTier) return NO;
    
    // Sum all points until the farthest tier with points
    for (int j = 0; j < maxTier; j++) {
      sumOfAllTiersToMaxTier += _pointsInTier[j];
    }
    
    // If sum of all points to farthest tier is <= points needed for farthest tier to be active, we can't subtract
    if (sumOfAllTiersToMaxTier <= pointsRequiredAtMaxTier) {
      return NO;
    }
  }
  
  // Check for parent requirement if exist
  // Look in the inverse dependency requirement dictionary to see if this talent has children
  // IF this talent has children, make sure all children have no points
  NSMutableArray *children = [self.childDict objectForKey:[talentView.talent.talentId stringValue]];
  
  for (NSString *childId in children) {
    if (childId) {
      TalentViewController *childTalentViewController = [self.talentViewDict valueForKey:childId];
      if (childTalentViewController) {
        DLog(@"Child: %@ found for Parent: %@", childTalentViewController.talent.talentName, talentView.talent.talentName);
        
        // If the child's current rank is not 0, return NO
        if (childTalentViewController.currentRank != 0) {
          return NO;
        }
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
    } else if (self.state == TreeStateFinished) {
      // do nothing
    } else {
      talentView.state = TalentStateDisabled;
    }
    
    // Check to see if any arrows need to be updated
    // If tier points are satisfied and req is maxed, turn arrow yellow
    UIImageView *arrowView = [self.arrowViewDict objectForKey:[talentView.talent.talentId stringValue]];
    if (arrowView) {
      TalentViewController *req = [self.talentViewDict objectForKey:[talentView.talent.req stringValue]];
      if (req) {
        if (req.currentRank == [req.talent.ranks count] && self.pointsInTree >= 5 * [talentView.talent.tier integerValue]) {
          // maxed, enable arrow
          arrowView.highlighted = YES;
        } else {
          // not maxed, disable arrow
          arrowView.highlighted = NO;
        }
      }
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
  [self updateMasteryGlow];
  
  // Tell tree to update state for all talents
  [self updateTalentState];
  
  // If we are finished, perform finish update state
  if (self.state == TreeStateFinished) {
    [self updateTalentStateFinished];
  }
}

- (void)resetState {
  self.state = TreeStateDisabled;
  
  self.pointsInTree = 0;
  
  for (int i = 0; i < MAX_TIERS; i++) {
    _pointsInTier[i] = 0;
  }
  
  // Reset all Talents
  for (TalentViewController *tvc in [self.talentViewDict allValues]) {
    [tvc resetState];
  }
  
  [self updateMasteryGlow];
}

- (void)resetTree {
  self.pointsInTree = 0;
  
  for (int i = 0; i < MAX_TIERS; i++) {
    _pointsInTier[i] = 0;
  }
  
  // Reset all Talent points
  for (TalentViewController *tvc in [self.talentViewDict allValues]) {
    [tvc resetTalent];
  }
}

- (void)updateMasteryGlow {
  if (self.isSpecTree) {
    _masteryGlow.hidden = NO;
  } else {
    _masteryGlow.hidden = YES;
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
  DLog(@"Trying to add a point for talent: %@", talentView.talent.talentName);
  
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
  DLog(@"Trying to subtract a point for talent: %@", talentView.talent.talentName);
  
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
  // IBOutlet
  if (_backgroundView) [_backgroundView release];
  if (_masteryGlow) [_masteryGlow release];
  
  if (_talentArray) [_talentArray release];
  if (_talentViewArray) [_talentViewArray release];
  if (_talentViewDict) [_talentViewDict release];
  if (_arrowViewDict) [_arrowViewDict release];
  if (_childDict) [_childDict release];
  [super dealloc];
}

@end
