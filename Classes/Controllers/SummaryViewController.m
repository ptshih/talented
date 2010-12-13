    //
//  SummaryViewController.m
//  TalentPad
//
//  Created by Peter Shih on 12/13/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "SummaryViewController.h"
#import "TalentTree.h"

@implementation SummaryViewController

@synthesize talentTree = _talentTree;
@synthesize delegate = _delegate;

- (void)viewDidLoad {
  [_redButton setTitle:self.talentTree.talentTreeName forState:UIControlStateNormal];
}

#pragma mark IBAction
- (IBAction)selectSpecTree {
  if (self.delegate) {
    [self.delegate specTreeSelected:[self.talentTree.treeNo integerValue]];
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
  [super dealloc];
}


@end
