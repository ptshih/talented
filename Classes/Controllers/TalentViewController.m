//
//  TalentViewController.m
//  TalentPad
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "TalentViewController.h"

#define MARGIN_X 15.0
#define MARGIN_Y 15.0
#define SPACING_X 14.0
#define SPACING_Y 14.0

// IMG WIDTH = 62
// 72

@interface TalentViewController (Private)

/**
 Creates a UIImageView background for a tree given an index (0~2)
 */
- (void)prepareBackgroundAtIndex:(NSInteger)index;

/**
 Renders UIButtons for a tree given an index (0~2)
 */
- (void)prepareTreeAtIndex:(NSInteger)index;

@end

@implementation TalentViewController

@synthesize selectedClass = _selectedClass;
@synthesize talentButtonArray = _talentButtonArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _talentButtonArray = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Create the scrollView frame for the 3 talent panes
  _scrollView.contentSize = CGSizeMake(960, 704);
  _scrollView.contentOffset = CGPointMake(320, 0);
  
  // Render the 3 backgrounds
  [self prepareBackgroundAtIndex:0];
  [self prepareBackgroundAtIndex:1];
  [self prepareBackgroundAtIndex:2];
  
  // Render the 3 talent trees
  [self prepareTreeAtIndex:0];
  [self prepareTreeAtIndex:1];
  [self prepareTreeAtIndex:2];
}

- (void)prepareBackgroundAtIndex:(NSInteger)index {
  UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%d.png", self.selectedClass, index]]];
  backgroundImageView.frame = CGRectMake(320 * index, 0, 320, 704);
  [_scrollView addSubview:backgroundImageView];
  [backgroundImageView release];
}

- (void)prepareTreeAtIndex:(NSInteger)index {
  NSInteger tier = 0;
  NSInteger col = 0;
  for(tier=0;tier<1;tier++) {
    for(col=0;col<1;col++) {
      TalentButtonViewController *tbvc = [[TalentButtonViewController alloc] initWithNibName:@"TalentButtonViewController" bundle:nil];
      tbvc.delegate = self;
      tbvc.tree = index;
      tbvc.tier = tier;
      tbvc.col = col;
      tbvc.max = 2;
      tbvc.view.frame = CGRectMake(MARGIN_X + 320 * index + ((SPACING_X + 62) * col), MARGIN_Y + ((SPACING_Y + 58) * tier), tbvc.view.frame.size.width, tbvc.view.frame.size.height);
      [_scrollView addSubview:tbvc.view];
      [self.talentButtonArray addObject:tbvc];
      [tbvc release];
    }
  }
}

#pragma mark TalentButtonDelegate
- (void)talentButtonTapped:(id)sender {
  // check state
  
  // update global/tree state based on the button's tier/col/value
  
  // update all talent buttons with nsnotification
  
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
  if(_talentButtonArray) [_talentButtonArray release];
  if(_scrollView) [_scrollView release];
  if(_selectedClass) [_selectedClass release];
  [super dealloc];
}


@end