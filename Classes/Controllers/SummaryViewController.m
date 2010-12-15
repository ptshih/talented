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
#import "Mastery.h"
#import "MasteryView.h"
#import "Constants.h"
#import "UIView+Additions.h"

#define PRIMARY_SPELL_MARGIN_X 30.0
#define PRIMARY_SPELL_MARGIN_Y 10.0
#define PRIMARY_SPELL_OFFSET_Y 180.0

@interface SummaryViewController (Private)

- (void)setupPrimarySpells;
- (void)setupMasteries;
- (void)setupTooltipLabel;

@end

@implementation SummaryViewController

@synthesize primarySpells = _primarySpells;
@synthesize mastery = _mastery;

@synthesize tooltipViewController = _tooltipViewController;

@synthesize tooltipLabel = _tooltipLabel;

@synthesize talentTree = _talentTree;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _desiredHeight = 0.0;
  }
  return self;
}

- (void)viewDidLoad {
  [_redButton setTitle:self.talentTree.talentTreeName forState:UIControlStateNormal];
  
  NSURL *imageUrl = [[NSURL alloc] initWithString:WOW_ICON_URL(self.talentTree.icon)];
  NSURLRequest *myRequest = [[NSURLRequest alloc] initWithURL:imageUrl];
  NSData *returnData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:nil error:nil];
  UIImage *myImage  = [[UIImage alloc] initWithData:returnData];
  
  [_primarySpellButton setImage:myImage forState:UIControlStateNormal];
  
  [self setupPrimarySpells];
  
  [self setupMasteries];
  
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
    // Temp
    NSURL *imageUrl = [[NSURL alloc] initWithString:WOW_ICON_URL(spell.icon)];
    NSURLRequest *myRequest = [[NSURLRequest alloc] initWithURL:imageUrl];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:nil error:nil];
    UIImage *myImage  = [[UIImage alloc] initWithData:returnData];

    PrimarySpellView *primarySpellView = (PrimarySpellView *)[[[NSBundle mainBundle] loadNibNamed:@"PrimarySpellView" owner:self options:nil] objectAtIndex:0];
    
    [primarySpellView.primarySpellIcon setImage:myImage forState:UIControlStateNormal];
    primarySpellView.primarySpellIcon.primarySpellIndex = i;
    primarySpellView.primarySpellIcon.parentView = primarySpellView;
    
    primarySpellView.primarySpellNameLabel.text = spell.primarySpellName;
    primarySpellView.top = PRIMARY_SPELL_OFFSET_Y + (i * (primarySpellView.height + PRIMARY_SPELL_MARGIN_Y));
    primarySpellView.left = PRIMARY_SPELL_MARGIN_X;
    _desiredHeight = primarySpellView.bottom;
    [self.view addSubview:primarySpellView];
    i++;
  }
}

- (void)setupMasteries {
  _mastery = [[self.talentTree.masteries anyObject] retain];
  DLog(@"found masteries: %@ in tree:%@", self.mastery, self.talentTree.talentTreeName);
  
//  NSURL *imageUrl = [[NSURL alloc] initWithString:WOW_ICON_URL(self.mastery.icon)];
//  NSURLRequest *myRequest = [[NSURLRequest alloc] initWithURL:imageUrl];
//  NSData *returnData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:nil error:nil];
//  UIImage *myImage  = [[UIImage alloc] initWithData:returnData];
  
  MasteryView *masteryView = (MasteryView *)[[[NSBundle mainBundle] loadNibNamed:@"MasteryView" owner:self options:nil] objectAtIndex:0];
  
//  [masteryView.masteryIcon setImage:myImage forState:UIControlStateNormal]; // Currently using default mastery icon
  masteryView.masteryNameLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Mastery", @"Mastery"), self.mastery.masteryName];
  masteryView.top = _desiredHeight + PRIMARY_SPELL_MARGIN_Y + 2.0;
  masteryView.left = PRIMARY_SPELL_MARGIN_X;
  _desiredHeight = masteryView.bottom;
  [self.view addSubview:masteryView];
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
  self.tooltipViewController.tooltipSource = TooltipSourcePrimarySpell;

  [self.tooltipViewController reloadTooltipData];
  
  
  NSInteger tooltipOffset = [sender parentView].bottom;
  
  CGRect tooltipFrame = CGRectMake(10.0, tooltipOffset + 6.0, self.view.width, self.tooltipViewController.view.height);
  //  [_tooltipPopoverController presentPopoverFromRect:popoverFrame inView:_talentTreeView permittedArrowDirections:NO animated:YES];
  //  
  self.tooltipViewController.view.frame = tooltipFrame;
  
  self.tooltipViewController.view.alpha = 0.0f;
  [self.view addSubview:self.tooltipViewController.view];
  [UIView beginAnimations:@"TooltipTransition" context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveLinear];  
  [UIView setAnimationDuration:0.2f];
  self.tooltipViewController.view.alpha = 1.0f;
  [UIView commitAnimations];
  
}

- (IBAction)masteryTapped:(id)sender {
  if (!self.tooltipViewController) {
    _tooltipViewController = [[TooltipViewController alloc] init];
  } else {
    [self hideTooltip];
  }
  
  self.tooltipViewController.availableHeight = self.view.height - _desiredHeight;
  
  self.tooltipViewController.mastery = self.mastery;
  self.tooltipViewController.tooltipSource = TooltipSourceMastery;
  
  [self.tooltipViewController reloadTooltipData];
  
  
  NSInteger tooltipOffset = _desiredHeight;
  
  CGRect tooltipFrame = CGRectMake(10.0, tooltipOffset + 6.0, self.view.width, self.tooltipViewController.view.height);
  //  [_tooltipPopoverController presentPopoverFromRect:popoverFrame inView:_talentTreeView permittedArrowDirections:NO animated:YES];
  //  
  self.tooltipViewController.view.frame = tooltipFrame;
  
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
  if (_mastery) [_mastery release];
  if (_tooltipViewController) [_tooltipViewController release];
  if (_tooltipLabel) [_tooltipLabel release];
  if (_dismissButton) [_dismissButton release];
  [super dealloc];
}


@end
