    //
//  SummaryViewController.m
//  TalentPad
//
//  Created by Peter Shih on 12/13/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "SummaryViewController.h"
#import "TalentTree.h"
#import "Constants.h"
#import "UIView+Additions.h"

@interface SummaryViewController (Private)

- (void)setupTooltip;

@end

@implementation SummaryViewController

@synthesize tooltipLabel = _tooltipLabel;

@synthesize talentTree = _talentTree;
@synthesize delegate = _delegate;

- (void)viewDidLoad {
  [_redButton setTitle:self.talentTree.talentTreeName forState:UIControlStateNormal];
  
  NSURL *imageUrl = [[NSURL alloc] initWithString:WOW_ICON_URL(self.talentTree.icon)];
  NSURLRequest *myRequest = [[NSURLRequest alloc] initWithURL:imageUrl];
  NSData *returnData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:nil error:nil];
  UIImage *myImage  = [[UIImage alloc] initWithData:returnData];
  
  [_primarySpellButton setImage:myImage forState:UIControlStateNormal];
  
  [self setupTooltip];
}

- (void)setupTooltip {
  _tooltipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.tooltipLabel.font = [UIFont systemFontOfSize:14.0];
  self.tooltipLabel.numberOfLines = 20.0;
  self.tooltipLabel.textAlignment = UITextAlignmentCenter;
  self.tooltipLabel.textColor = [UIColor whiteColor];
  self.tooltipLabel.backgroundColor = [UIColor clearColor];
  
  self.tooltipLabel.text = self.talentTree.tooltip;
  self.tooltipLabel.text = [self.tooltipLabel.text stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
  
  // Tooltip size
	CGSize tooltipSize = [self.tooltipLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(260.0, INT_MAX) lineBreakMode:UILineBreakModeWordWrap];
  
  self.tooltipLabel.top = self.view.height - tooltipSize.height - 30.0;
  self.tooltipLabel.left = 30.0;
  self.tooltipLabel.width = tooltipSize.width;
  self.tooltipLabel.height = tooltipSize.height;
  
  [self.view addSubview:self.tooltipLabel];
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
  if (_tooltipLabel) [_tooltipLabel release];
  [super dealloc];
}


@end
