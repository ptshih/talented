//
//  LauncherViewController.m
//  TalentPad
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "LauncherViewController.h"
#import "TalentViewController.h"

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
- (IBAction)deathKnight {
  TalentViewController *tvc = [[TalentViewController alloc] initWithNibName:@"TalentViewController_iPhone" bundle:nil];
  tvc.selectedClass = @"deathknight";
  [self.navigationController pushViewController:tvc animated:YES];
  [tvc release];
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
