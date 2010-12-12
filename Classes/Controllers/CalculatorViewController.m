//
//  CalculatorViewController.m
//  TalentPad
//
//  Created by Peter Shih on 12/11/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "CalculatorViewController.h"
#import "TreeViewController.h"

#define SPACING_X 16.0
#define SPACING_Y 60.0

@interface CalculatorViewController (Private)

- (void)prepareTreeAtIndex:(NSInteger)index;

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
  
  // Add Trees to View
  [self prepareTreeAtIndex:0];
  [self prepareTreeAtIndex:1];
  [self prepareTreeAtIndex:2];
}

#pragma mark Prepare Trees
- (void)prepareTreeAtIndex:(NSInteger)index {
  TreeViewController *tvc = [[TreeViewController alloc] initWithNibName:@"TreeViewController" bundle:nil];
  tvc.view.frame = CGRectMake(SPACING_X + (SPACING_X * index) + (320 * index), SPACING_Y, tvc.view.frame.size.width, tvc.view.frame.size.height);
  switch (index) {
    case 0:
      tvc.view.backgroundColor = [UIColor redColor];
      break;
    case 1:
      tvc.view.backgroundColor = [UIColor greenColor];
      break;
    case 2:
      tvc.view.backgroundColor = [UIColor blueColor];
      break;
    default:
      break;
  }
  [self.view addSubview:tvc.view];
  [self.treeArray addObject:tvc];
  [tvc release];
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
