//
//  CalculatorViewController.m
//  TalentPad
//
//  Created by Peter Shih on 12/11/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "CalculatorViewController.h"
#import "TooltipViewController.h"
#import "SMACoreDataStack.h"
#import "TalentTree.h"
#import "TalentTree+Fetch.h"
#import "Talent.h"
#import "Constants.h"
#import "UIView+Additions.h"

#define SPACING_X 16.0
#define SPACING_Y 16.0
#define MARGIN_X 16.0
#define TOOLTIP_MARGIN_Y 6.0

#define MAX_POINTS 41
#define SPEC_POINTS_LIMIT 31

@interface CalculatorViewController (Private)

- (void)resetTreeAtIndex:(NSInteger)index;
- (NSInteger)getRequiredLevel;
- (void)updateFooterLabels;
- (void)updateHeaderPoints;
- (void)updateHeaderState;
- (void)setupHeader;
- (void)setSwapButtonTitle;
- (void)fetchTrees;
- (void)prepareSummaries;
- (void)prepareTrees;
- (void)updateStateFromTreeNo:(NSInteger)treeNo;
- (void)updateTreeStateForTree:(NSInteger)treeNo;
- (void)showTooltipForTalentView:(TalentViewController *)talentView inTree:(TreeViewController *)treeView;

@end

@implementation CalculatorViewController

@synthesize tooltipViewController = _tooltipViewController;
@synthesize treeArray = _treeArray;
@synthesize summaryViewArray = _summaryViewArray;
@synthesize treeViewArray = _treeViewArray;
@synthesize characterClassId = _characterClassId;
@synthesize specTreeNo = _specTreeNo;
@synthesize totalPoints = _totalPoints;
@synthesize state = _state;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _summaryViewArray = [[NSMutableArray alloc] init];
    _treeViewArray = [[NSMutableArray alloc] init];
    _characterClassId = 0;
    _specTreeNo = -1;
    _totalPoints = 0;
    _state = CalculatorStateEnabled;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Fetch trees from core data
  [self fetchTrees];
  
  // Prepare Summaries
  [self prepareSummaries];
  
  // Add Trees to View
  [self prepareTrees];
  
  // Setup Footer
  [self setSwapButtonTitle];
  
  // Setup Header
  [self setupHeader];
  [self updateHeaderState];
  [self updateHeaderPoints];
  
  // Setup Footer
  [self updateFooterLabels];
}

#pragma mark IBAction
- (IBAction)resetLeft {
  [self resetTreeAtIndex:0];
}

- (IBAction)resetMiddle {
  [self resetTreeAtIndex:1];
}

- (IBAction)resetRight {
  [self resetTreeAtIndex:2];
}

- (void)resetTreeAtIndex:(NSInteger)index {
  // If we are resetting the spec tree, make sure we aren't in EnabledAll state
  // If the side two trees are enabled, we have to reset the side trees also
  if (self.specTreeNo == index && self.state == CalculatorStateAllEnabled) {
    // LOGIC NEEDED
    UIAlertView *resetAlertView = [[UIAlertView alloc] initWithTitle:@"Can't Rest Tree" message:@"Can't reset specialization tree until other two talent trees have 0 points allocated!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [resetAlertView show];
    [resetAlertView autorelease];
    return;
  }
  
  TreeViewController *tvc = [self.treeViewArray objectAtIndex:index];
  self.totalPoints -= tvc.pointsInTree;
  self.state = CalculatorStateEnabled;
  
  [self hideTooltip];
  [tvc resetTree];
  
  [self updateStateFromTreeNo:index];
}

- (IBAction)resetAll {
  self.totalPoints = 0;
  self.state = CalculatorStateEnabled;
  self.specTreeNo = -1;
  
  [self hideTooltip];
  
  for (TreeViewController *tvc in self.treeViewArray) {
    tvc.isSpecTree = NO;
    [tvc resetState];
    [tvc updateState];
  }
  
  [self updateHeaderState];
  [self updateHeaderPoints];
  [self updateFooterLabels];
  
  // Go back to summary view if on talentView
  UIView *activeView = [self.view.subviews objectAtIndex:1];
  if ([activeView isEqual:_talentTreeView]) {
    [self swapViews];
  }
  
}

- (IBAction)swapViews {
  [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
  [self setSwapButtonTitle];
}

- (void)setSwapButtonTitle {
  UIView *activeView = [self.view.subviews objectAtIndex:1];
  if ([activeView isEqual:_talentTreeView]) {
    [_swapButton setTitle:NSLocalizedString(@"View Summaries", @"View Summaries") forState:UIControlStateNormal];
  } else {
    [_swapButton setTitle:NSLocalizedString(@"View Talents", @"View Summaries") forState:UIControlStateNormal];
  }
}

- (void)setupHeader {
  NSURL *imageUrl = [[NSURL alloc] initWithString:WOW_ICON_URL([[self.treeArray objectAtIndex:0] icon])];
  NSURLRequest *myRequest = [[NSURLRequest alloc] initWithURL:imageUrl];
  NSData *returnData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:nil error:nil];
  UIImage *myImage  = [[UIImage alloc] initWithData:returnData];
  
  _leftIcon.image = myImage;
  _leftLabel.text = [[self.treeArray objectAtIndex:0] talentTreeName];
  
  imageUrl = [[NSURL alloc] initWithString:WOW_ICON_URL([[self.treeArray objectAtIndex:1] icon])];
  myRequest = [[NSURLRequest alloc] initWithURL:imageUrl];
  returnData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:nil error:nil];
  myImage  = [[UIImage alloc] initWithData:returnData];
  
  _middleIcon.image = myImage;
  _middleLabel.text = [[self.treeArray objectAtIndex:1] talentTreeName];
  
  imageUrl = [[NSURL alloc] initWithString:WOW_ICON_URL([[self.treeArray objectAtIndex:2] icon])];
  myRequest = [[NSURLRequest alloc] initWithURL:imageUrl];
  returnData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:nil error:nil];
  myImage  = [[UIImage alloc] initWithData:returnData];
  
  _rightIcon.image = myImage;
  _rightLabel.text = [[self.treeArray objectAtIndex:2] talentTreeName];
}

#pragma mark Fetch Trees from CoreData
- (void)fetchTrees {
  NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"TalentTree" inManagedObjectContext:context];
  
  NSFetchRequest *request = [TalentTree fetchRequestForTalentTreesWithCharacterClassId:self.characterClassId];
  [request setEntity:entity];
  
  // Set an ASC sort on treeNo
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"treeNo" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  [sortDescriptor release];
  [request setSortDescriptors:sortDescriptors];
  
  NSError *error;
  NSArray *array = [context executeFetchRequest:request error:&error];
  if(array) {
    self.treeArray = array;
  }
  
  DLog(@"Loaded at index 0: %@", [[self.treeArray objectAtIndex:0] talentTreeName]);
  DLog(@"Loaded at index 1: %@", [[self.treeArray objectAtIndex:1] talentTreeName]);
  DLog(@"Loaded at index 2: %@", [[self.treeArray objectAtIndex:2] talentTreeName]);

}

- (void)prepareSummaries {
  NSInteger treeNo = 0;
  for (TalentTree *talentTree in self.treeArray) {
    treeNo = [[talentTree treeNo] integerValue];
    SummaryViewController *svc = [[SummaryViewController alloc] initWithNibName:@"SummaryViewController" bundle:nil];
    svc.talentTree = talentTree;
    svc.delegate = self;
    svc.view.frame = CGRectMake(SPACING_X + (SPACING_X * treeNo) + (320 * treeNo), 0, svc.view.frame.size.width, svc.view.frame.size.height);
    [_summaryView addSubview:svc.view];
    [self.summaryViewArray addObject:svc];
    [svc release];
  }
}

#pragma mark Prepare Trees
- (void)prepareTrees {
  for (TalentTree *talentTree in self.treeArray) {
    TreeViewController *tvc = [[TreeViewController alloc] initWithNibName:@"TreeViewController" bundle:nil];
    tvc.talentTree = talentTree;
    tvc.delegate = self;
    tvc.talentArray = [[talentTree talents] allObjects];
    tvc.treeNo = [[talentTree treeNo] integerValue];
    tvc.isSpecTree = (tvc.treeNo == self.specTreeNo) ? YES : NO;
    tvc.view.frame = CGRectMake(SPACING_X + (SPACING_X * tvc.treeNo) + (320 * tvc.treeNo), 0, tvc.view.frame.size.width, tvc.view.frame.size.height);
    [_talentTreeView addSubview:tvc.view];
    [self.treeViewArray addObject:tvc];
    [tvc release];
  }
  
  [self updateTreeStateForTree:0];
  [self updateTreeStateForTree:1];
  [self updateTreeStateForTree:2];
}

#pragma mark Calculator Logic
- (void)updateStateFromTreeNo:(NSInteger)treeNo {
  // Check for max points in calculator
  if (self.totalPoints == MAX_POINTS) {
    self.state = CalculatorStateFinished;
  } else {
    if (self.state != CalculatorStateAllEnabled) {
      self.state = CalculatorStateEnabled;
    }
  }
  
  // Check to see if spec tree has reached 31
  if ([[self.treeViewArray objectAtIndex:self.specTreeNo] pointsInTree] >= SPEC_POINTS_LIMIT && self.state == CalculatorStateEnabled) {
    self.state = CalculatorStateAllEnabled;
    [self updateTreeStateForTree:0];
    [self updateTreeStateForTree:1];
    [self updateTreeStateForTree:2];
  } else if ([[self.treeViewArray objectAtIndex:self.specTreeNo] pointsInTree] < SPEC_POINTS_LIMIT) {
    self.state = CalculatorStateEnabled;
    [self updateTreeStateForTree:0];
    [self updateTreeStateForTree:1];
    [self updateTreeStateForTree:2];
  } else {
    [self updateTreeStateForTree:treeNo];
  }
  
  [self updateHeaderState];
  [self updateHeaderPoints];
  [self updateFooterLabels];
}

- (void)updateTreeStateForTree:(NSInteger)treeNo {
  // If calculator is disabled, then tell all trees
  if (self.state == CalculatorStateFinished) {
    for (TreeViewController *tvc in self.treeViewArray) {
      tvc.state = TreeStateFinished;
      [tvc updateState];
    }
    return;
  }
  
  BOOL isSpecLimitReached = NO;
  
  // Check to see if spec tree has reached 31
  if (self.specTreeNo >= 0) {
    if ([[self.treeViewArray objectAtIndex:self.specTreeNo] pointsInTree] >= SPEC_POINTS_LIMIT) {
      isSpecLimitReached = YES;
    }
  }
  
  for (TreeViewController *tvc in self.treeViewArray) {
    // If we have reached 31pts in spec tree, enable all 3 trees
    if (isSpecLimitReached) {
      tvc.state = TreeStateEnabled;
    } else {
      if (tvc.treeNo == self.specTreeNo) {
        tvc.state = TreeStateEnabled;
      } else {
        tvc.state = TreeStateDisabled;
      }
    }

    [tvc updateState];
  }
  
}

#pragma mark TreeDelegate
- (void)dismissPopoverFromTree:(TreeViewController *)treeView {
  [self hideTooltip];
}

- (void)talentTappedForTree:(TreeViewController *)treeView andTalentView:(TalentViewController *)talentView {
  [self showTooltipForTalentView:talentView inTree:treeView];
}

- (void)treeAdd:(TreeViewController *)treeView forTalentView:(TalentViewController *)talentView {
  DLog(@"Adding a point for tree: %d", treeView.treeNo);
  self.totalPoints++;
  
  [self updateStateFromTreeNo:treeView.treeNo];
}

- (void)treeSubtract:(TreeViewController *)treeView forTalentView:(TalentViewController *)talentView {
  DLog(@"Subtracting a point for tree: %d", treeView.treeNo);
  self.totalPoints--;

  [self updateStateFromTreeNo:treeView.treeNo];
}

#pragma mark SummaryDelegate
- (void)specTreeSelected:(NSInteger)treeNo {
  // Update the primary spec tree
  self.specTreeNo = treeNo;
  for (TreeViewController *tree in self.treeViewArray) {
    if (tree.treeNo == treeNo) {
      tree.isSpecTree = YES;
    } else {
      tree.isSpecTree = NO;
    }
    [self updateTreeStateForTree:tree.treeNo];
  }
  [self updateHeaderState];
  [self swapViews];
}


#pragma mark Header Updates
- (void)updateHeaderPoints {
  _leftPoints.text = [NSString stringWithFormat:@"%d", [[self.treeViewArray objectAtIndex:0] pointsInTree]];
  _middlePoints.text = [NSString stringWithFormat:@"%d", [[self.treeViewArray objectAtIndex:1] pointsInTree]];
  _rightPoints.text = [NSString stringWithFormat:@"%d", [[self.treeViewArray objectAtIndex:2] pointsInTree]];
}

- (void)updateHeaderState { 
  // Update Borders and Points
  if (self.state == CalculatorStateAllEnabled || self.state == CalculatorStateFinished) {
    _leftPoints.hidden = NO;
    _middlePoints.hidden = NO;
    _rightPoints.hidden = NO;
    
    _leftBorder.image = [UIImage imageNamed:@"icon-border-header-circle-gray.png"];
    _middleBorder.image = [UIImage imageNamed:@"icon-border-header-circle-gray.png"];
    _rightBorder.image = [UIImage imageNamed:@"icon-border-header-circle-gray.png"];
  } else {
    switch (self.specTreeNo) {
      case 0:
        _leftPoints.hidden = NO;
        _middlePoints.hidden = YES;
        _rightPoints.hidden = YES;
        
        _leftBorder.image = [UIImage imageNamed:@"icon-border-header-circle-gray.png"];
        _middleBorder.image = [UIImage imageNamed:@"icon-border-header-lock.png"];
        _rightBorder.image = [UIImage imageNamed:@"icon-border-header-lock.png"];
        break;
      case 1:
        _leftPoints.hidden = YES;
        _middlePoints.hidden = NO;
        _rightPoints.hidden = YES;
        
        _leftBorder.image = [UIImage imageNamed:@"icon-border-header-lock.png"];
        _middleBorder.image = [UIImage imageNamed:@"icon-border-header-circle-gray.png"];
        _rightBorder.image = [UIImage imageNamed:@"icon-border-header-lock.png"];
        break;
      case 2:
        _leftPoints.hidden = YES;
        _middlePoints.hidden = YES;
        _rightPoints.hidden = NO;
        
        _leftBorder.image = [UIImage imageNamed:@"icon-border-header-lock.png"];
        _middleBorder.image = [UIImage imageNamed:@"icon-border-header-lock.png"];
        _rightBorder.image = [UIImage imageNamed:@"icon-border-header-circle-gray.png"];
        break;
      default:
        // Reset state (-1)
        _leftPoints.hidden = YES;
        _middlePoints.hidden = YES;
        _rightPoints.hidden = YES;
        
        _leftBorder.image = [UIImage imageNamed:@"icon-border-header-lock.png"];
        _middleBorder.image = [UIImage imageNamed:@"icon-border-header-lock.png"];
        _rightBorder.image = [UIImage imageNamed:@"icon-border-header-lock.png"];
        break;
    }
  }
}

#pragma mark Footer Updates
- (void)updateFooterLabels {
  _requiredLevel.text = [NSString stringWithFormat:@"Required Level: %d", [self getRequiredLevel]];
  _pointsLeft.text = [NSString stringWithFormat:@"Points Left: %d", MAX_POINTS - self.totalPoints];
  _pointsSpent.text = [NSString stringWithFormat:@"Points Spent: %d / %d / %d", [[self.treeViewArray objectAtIndex:0] pointsInTree], [[self.treeViewArray objectAtIndex:1] pointsInTree], [[self.treeViewArray objectAtIndex:2] pointsInTree]];
}

- (NSInteger)getRequiredLevel {
  if (self.totalPoints == 0) return 0;
 
  NSInteger reqLevel = 9;
  NSInteger points = self.totalPoints;
  
  // First 2 points = every 1 level
  NSInteger part = MIN(2, points);
  if (part > 0) {
    reqLevel += part;
    points -= part;
  }
  
  // Next 35 points = every 2 levels
  part = MIN(35, points);
  if (part > 0) {
    reqLevel += part * 2;
    points -= part;
  }
  
  // Last 4 points = every 1 level
  part = MIN(5, points);
  if (part > 0) {
    reqLevel += part;
//    points -= part;
  }
  
  return reqLevel;
}

#pragma mark Tooltip Methods
- (void)showTooltipForTalentView:(TalentViewController *)talentView inTree:(TreeViewController *)treeView {
  if (!self.tooltipViewController) {
    _tooltipViewController = [[TooltipViewController alloc] init];
  } else {
    [self hideTooltip];
  }

  
//  if (!_tooltipPopoverController) {
//    _tooltipPopoverController = [[UIPopoverController alloc] initWithContentViewController:self.tooltipViewController];
//  } else {
//    [_tooltipPopoverController dismissPopoverAnimated:NO];
//  }
  
  // Calculate available height based on tier selected
  CGFloat availableHeight = 0.0;
  if ([talentView.talent.tier integerValue] >= 4) {
    availableHeight = talentView.view.top - TOOLTIP_MARGIN_Y * 2;
  } else {
    availableHeight = _talentTreeView.height - (talentView.view.bottom + TOOLTIP_MARGIN_Y * 2);
  }
  DLog(@"availHeight = %f", availableHeight);
  self.tooltipViewController.availableHeight = availableHeight;
  
  self.tooltipViewController.treeView = treeView;
  self.tooltipViewController.talentView = talentView;
  [self.tooltipViewController reloadTooltipData];
  
//  _tooltipPopoverController.popoverContentSize = self.tooltipViewController.view.frame.size;
//  
//  NSMutableArray *views = [NSMutableArray array];
//  for (TreeViewController *tvc in self.treeViewArray) {
//    [views addObject:tvc.view];
//  }
//  _tooltipPopoverController.passthroughViews = views;
  
  // Calculate Popover positioning
  // Invert, etc...
  // IF tier >= 4, invert
  NSInteger tooltipTop;
  if ([talentView.talent.tier integerValue] >= 4) {
    tooltipTop = talentView.view.top - self.tooltipViewController.view.height - TOOLTIP_MARGIN_Y;
  } else {
    tooltipTop = talentView.view.bottom + TOOLTIP_MARGIN_Y;
  }
  
  CGRect tooltipFrame = CGRectMake(treeView.view.left + 10.0, tooltipTop, treeView.view.width, self.tooltipViewController.view.height);
//  [_tooltipPopoverController presentPopoverFromRect:popoverFrame inView:_talentTreeView permittedArrowDirections:NO animated:YES];
//  
  self.tooltipViewController.view.frame = tooltipFrame;
  
  self.tooltipViewController.view.alpha = 0.0f;
  [_talentTreeView addSubview:self.tooltipViewController.view];
  [UIView beginAnimations:@"TooltipTransition" context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveLinear];  
  [UIView setAnimationDuration:0.2f];
  self.tooltipViewController.view.alpha = 1.0f;
  [UIView commitAnimations];

}


- (void)hideTooltip {
  if (self.tooltipViewController) {
    [self.tooltipViewController.view removeFromSuperview];
  }
//	if(_tooltipPopoverController) {
//    [_tooltipPopoverController dismissPopoverAnimated:animated];
//	}
}

#pragma mark Memory Management
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return UIInterfaceOrientationIsLandscape(interfaceOrientation);
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
//  if (_tooltipPopoverController) [_tooltipPopoverController release];
  if (_tooltipViewController) [_tooltipViewController release];
  if (_summaryViewArray) [_summaryViewArray release];
  if (_treeViewArray) [_treeViewArray release];
  if (_treeArray) [_treeArray release];
  [super dealloc];
}


@end
