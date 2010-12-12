//
//  CalculatorViewController.m
//  TalentPad
//
//  Created by Peter Shih on 12/11/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "CalculatorViewController.h"
#import "TreeViewController.h"
#import "SMACoreDataStack.h"
#import "TalentTree.h"
#import "TalentTree+Fetch.h"
#import "Constants.h"

#define SPACING_X 16.0
#define SPACING_Y 60.0 + 16.0

@interface CalculatorViewController (Private)

- (void)fetchTrees;
- (void)prepareTrees;

@end

@implementation CalculatorViewController

@synthesize treeArray = _treeArray;
@synthesize classId = _classId;
@synthesize specTreeNo = _specTreeNo;
@synthesize totalPoints = _totalPoints;
@synthesize state = _state;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _classId = 0;
    _specTreeNo = 0;
    _totalPoints = 0;
    _state = CalculatorStateDisabled;
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
  
  NSFetchRequest *request = [TalentTree fetchRequestForTalentTreesWithClassId:self.classId];
  [request setEntity:entity];
  
  NSError *error;
  NSArray *array = [context executeFetchRequest:request error:&error];
  if(array) {
    self.treeArray = array;
  }
  
//  DLog(@"name: %@", [[[self.treeArray objectAtIndex:0] talents] allObjects]);

}

#pragma mark Prepare Trees
- (void)prepareTrees {
  for (TalentTree *talentTree in self.treeArray) {
    TreeViewController *tvc = [[TreeViewController alloc] initWithNibName:@"TreeViewController" bundle:nil];
    tvc.talentArray = [[talentTree talents] allObjects];
    tvc.treeNo = [[talentTree treeNo] integerValue];
    tvc.view.frame = CGRectMake(SPACING_X + (SPACING_X * tvc.treeNo) + (320 * tvc.treeNo), SPACING_Y, tvc.view.frame.size.width, tvc.view.frame.size.height);
    [self.view addSubview:tvc.view];
    [tvc release];
  }
}

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
  if(_treeArray) [_treeArray release];
  [super dealloc];
}


@end
