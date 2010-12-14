    //
//  SummaryViewController.m
//  TalentPad
//
//  Created by Peter Shih on 12/13/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "SummaryViewController.h"
#import "TooltipViewController.h"
#import "TalentTree.h"
#import "PrimarySpell.h"
#import "PrimarySpellView.h"
#import "PrimarySpellButton.h"
#import "Constants.h"
#import "UIView+Additions.h"

#define PRIMARY_SPELL_MARGIN_X 30.0
#define PRIMARY_SPELL_MARGIN_Y 10.0
#define PRIMARY_SPELL_OFFSET_Y 180.0

@interface SummaryViewController (Private)

- (void)setupPrimarySpells;
- (void)setupTooltipLabel;

@end

@implementation SummaryViewController

@synthesize primarySpells = _primarySpells;

@synthesize tooltipViewController = _tooltipViewController;

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
  
  [self setupPrimarySpells];
  
  [self setupTooltipLabel];
}

- (void)setupPrimarySpells {
  // Find all primary spells
  // Set an ASC sort on index
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  [sortDescriptor release];
  _primarySpells = [[self.talentTree.primarySpells sortedArrayUsingDescriptors:sortDescriptors] retain];
  DLog(@"found primary spells: %@ in tree:%@", self.primarySpells, self.talentTree.talentTreeName);
  
  NSInteger i = 0;
  for (PrimarySpell *spell in self.primarySpells) {
    PrimarySpellView *primarySpellView = (PrimarySpellView *)[[[NSBundle mainBundle] loadNibNamed:@"PrimarySpellView" owner:self options:nil] objectAtIndex:0];

    // Temp
    NSURL *imageUrl = [[NSURL alloc] initWithString:WOW_ICON_URL(spell.icon)];
    NSURLRequest *myRequest = [[NSURLRequest alloc] initWithURL:imageUrl];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:nil error:nil];
    UIImage *myImage  = [[UIImage alloc] initWithData:returnData];
    
    [primarySpellView.primarySpellIcon setImage:myImage forState:UIControlStateNormal];
    primarySpellView.primarySpellIcon.primarySpellIndex = i;
    
    primarySpellView.primarySpellNameLabel.text = spell.primarySpellName;
    primarySpellView.top = PRIMARY_SPELL_OFFSET_Y + (i * (primarySpellView.height + PRIMARY_SPELL_MARGIN_Y));
    primarySpellView.left = PRIMARY_SPELL_MARGIN_X;
    [self.view addSubview:primarySpellView];
    i++;
  }
}

- (void)setupTooltipLabel {
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
- (IBAction)spellTapped:(id)sender {
  if (!self.tooltipViewController) {
    _tooltipViewController = [[TooltipViewController alloc] init];
  } else {
    [self hideTooltip];
  }

  self.tooltipViewController.availableHeight = self.view.height;
  
  self.tooltipViewController.primarySpell = [self.primarySpells objectAtIndex:[sender primarySpellIndex]];
  self.tooltipViewController.isPrimarySpell = YES;

  [self.tooltipViewController reloadTooltipData];
  
  CGRect popoverFrame = CGRectMake(10.0, 10.0, self.view.width, self.tooltipViewController.view.height);
  //  [_tooltipPopoverController presentPopoverFromRect:popoverFrame inView:_talentTreeView permittedArrowDirections:NO animated:YES];
  //  
  self.tooltipViewController.view.frame = popoverFrame;
  
  self.tooltipViewController.view.alpha = 0.0f;
  [self.view addSubview:self.tooltipViewController.view];
  [UIView beginAnimations:@"TooltipTransition" context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveLinear];  
  [UIView setAnimationDuration:0.2f];
  self.tooltipViewController.view.alpha = 1.0f;
  [UIView commitAnimations];
  
}

- (IBAction)hideTooltip {
  if (self.tooltipViewController) {
    [self.tooltipViewController.view removeFromSuperview];
  }
}

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
  if (_primarySpells) [_primarySpells release];
  if (_tooltipViewController) [_tooltipViewController release];
  if (_tooltipLabel) [_tooltipLabel release];
  if (_dismissButton) [_dismissButton release];
  [super dealloc];
}


@end
