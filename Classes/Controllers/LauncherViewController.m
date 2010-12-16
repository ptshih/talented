//
//  LauncherViewController.m
//  TalentPad
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "LauncherViewController.h"
#import "CalculatorViewController.h"

@interface LauncherViewController (Private)

- (void)selectClassWithId:(NSInteger)characterClassId;

@end

@implementation LauncherViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"TalentPad";
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

#pragma mark Class Selection
- (void)selectClassWithId:(NSInteger)characterClassId {
  CalculatorViewController *cvc = [[CalculatorViewController alloc] initWithNibName:@"CalculatorViewController" bundle:nil];
  cvc.characterClassId = characterClassId;
  [self presentModalViewController:cvc animated:YES];
  [cvc release];
}

- (IBAction)warrior {
  [self selectClassWithId:1];
}
- (IBAction)paladin {
  [self selectClassWithId:2];
}
- (IBAction)hunter {
  [self selectClassWithId:3];
}
- (IBAction)rogue {
  [self selectClassWithId:4];
}
- (IBAction)priest {
  [self selectClassWithId:5];
}
- (IBAction)deathknight {
  [self selectClassWithId:6];
}
- (IBAction)shaman {
  [self selectClassWithId:7];
}
- (IBAction)mage {
  [self selectClassWithId:8];
}
- (IBAction)warlock {
  [self selectClassWithId:9];
}
- (IBAction)druid {
  [self selectClassWithId:11];
}


// Override to allow orientations other than the default portrait orientation.
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
