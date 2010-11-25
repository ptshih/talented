//
//  TalentViewController.m
//  WoWTalentPro
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "TalentViewController.h"
#import "TalentButtonViewController.h"

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
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
  NSInteger row = 0;
  NSInteger col = 0;
  for(row=0;row<4;row++) {
    for(col=0;col<4;col++) {
      TalentButtonViewController *tbvc = [[TalentButtonViewController alloc] initWithNibName:@"TalentButtonViewController" bundle:nil];
      tbvc.tree = index;
      tbvc.view.frame = CGRectMake(MARGIN_X + 320 * index + ((SPACING_X + 62) * col), MARGIN_Y + ((SPACING_Y + 58) * row), tbvc.view.frame.size.width, tbvc.view.frame.size.height);
      [_scrollView addSubview:tbvc.view];
      [tbvc release];
    }
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
  if(_scrollView) [_scrollView release];
  if(_selectedClass) [_selectedClass release];
  [super dealloc];
}


@end