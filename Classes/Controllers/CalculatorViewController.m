//
//  CalculatorViewController.m
//  TalentPad
//
//  Created by Peter Shih on 12/11/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "CalculatorViewController.h"


@implementation CalculatorViewController

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
  [super dealloc];
}


@end
