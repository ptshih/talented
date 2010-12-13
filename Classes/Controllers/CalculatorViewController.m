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

#define SPACING_X 16.0
#define SPACING_Y 60.0 + 16.0

#define MAX_POINTS 41
#define SPEC_POINTS_LIMIT 31

@interface CalculatorViewController (Private)

- (void)fetchTrees;
- (void)prepareTrees;
- (void)updateStateFromTreeNo:(NSInteger)treeNo;
- (void)updateTreeStateForTree:(NSInteger)treeNo;
- (void)showTooltipForTalentView:(TalentViewController *)talentView inTree:(TreeViewController *)treeView;

@end

@implementation CalculatorViewController

@synthesize tooltipViewController = _tooltipViewController;
@synthesize treeArray = _treeArray;
@synthesize treeViewArray = _treeViewArray;
@synthesize characterClassId = _characterClassId;
@synthesize specTreeNo = _specTreeNo;
@synthesize totalPoints = _totalPoints;
@synthesize state = _state;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _treeViewArray = [[NSMutableArray alloc] init];
    _characterClassId = 0;
    _specTreeNo = 1;
    _totalPoints = 0;
    _state = CalculatorStateEnabled;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Fetch trees from core data
  [self fetchTrees];
  
  // Add Trees to View
  [self prepareTrees];
}

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

#pragma mark Prepare Trees
- (void)prepareTrees {
  for (TalentTree *talentTree in self.treeArray) {
    TreeViewController *tvc = [[TreeViewController alloc] initWithNibName:@"TreeViewController" bundle:nil];
    tvc.talentTree = talentTree;
    tvc.delegate = self;
    tvc.talentArray = [[talentTree talents] allObjects];
    tvc.treeNo = [[talentTree treeNo] integerValue];
    tvc.isSpecTree = (tvc.treeNo == self.specTreeNo) ? YES : NO;
    tvc.view.frame = CGRectMake(SPACING_X + (SPACING_X * tvc.treeNo) + (320 * tvc.treeNo), SPACING_Y, tvc.view.frame.size.width, tvc.view.frame.size.height);
    [self.view addSubview:tvc.view];
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
    self.state = CalculatorStateDisabled;
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
  
}

- (void)updateTreeStateForTree:(NSInteger)treeNo {
  // If calculator is disabled, then tell all trees
  if (self.state == CalculatorStateDisabled) {
    for (TreeViewController *tvc in self.treeViewArray) {
      tvc.state = TreeStateFinished;
      [tvc updateState];
    }
    return;
  }
  
  BOOL isSpecLimitReached = NO;
  
  // Check to see if spec tree has reached 31
  if ([[self.treeViewArray objectAtIndex:self.specTreeNo] pointsInTree] >= SPEC_POINTS_LIMIT) {
    isSpecLimitReached = YES;
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
- (void)treeAdd:(TreeViewController *)treeView forTalentView:(TalentViewController *)talentView {
  DLog(@"Adding a point for tree: %d", treeView.treeNo);
  self.totalPoints++;
  
  [self showTooltipForTalentView:talentView inTree:treeView];
  
  [self updateStateFromTreeNo:treeView.treeNo];
}

- (void)treeSubtract:(TreeViewController *)treeView forTalentView:(TalentViewController *)talentView {
  DLog(@"Subtracting a point for tree: %d", treeView.treeNo);
  self.totalPoints--;
  
  [self updateStateFromTreeNo:treeView.treeNo];
}

#pragma mark Tooltip Methods
- (void)showTooltipForTalentView:(TalentViewController *)talentView inTree:(TreeViewController *)treeView {
  if (!self.tooltipViewController) {
    _tooltipViewController = [[TooltipViewController alloc] initWithNibName:@"TooltipViewController" bundle:nil];
  }
  
  self.tooltipViewController.treeView = treeView;
  self.tooltipViewController.talentView = talentView;
	
	// First set the frame to a large size
  self.tooltipViewController.view.frame = CGRectMake(0, 0, 260, self.view.frame.size.height);
  
	
	[self.tooltipViewController setInfo]; // Because this view is persistent, can't use init/viewdidload
	
	[self.tooltipViewController setTooltip]; // create the tooltip and setup frames
  
  NSInteger tier = [talentView.talent.tier integerValue];
  
	NSInteger scrollTop = (64 * tier);
	
  
	NSInteger invertThreshold = 6;
		
	self.tooltipViewController.view.alpha = 0.0f;
	[self.view addSubview:self.tooltipViewController.view];
	[UIView beginAnimations:@"TooltipTransition" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];  
	[UIView setAnimationDuration:0.2f];
	self.tooltipViewController.view.alpha = 1.0f;
	[UIView commitAnimations];
}


- (void)hideTooltip {
	if(self.tooltipViewController != nil) {
		[self.tooltipViewController.view removeFromSuperview];
	}
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
  if (_tooltipViewController) [_tooltipViewController release];
  if (_treeViewArray) [_treeViewArray release];
  if (_treeArray) [_treeArray release];
  [super dealloc];
}


@end
