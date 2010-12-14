//
//  TooltipViewController.m
//  TalentPad
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "TooltipViewController.h"
#import "TalentViewController.h"
#import "TreeViewController.h"
#import "Talent.h"
#import "TalentTree.h"
#import "Rank.h"
#import "UIView+Additions.h"
#import "Constants.h"
#import "InfoTextView.h"

#define TOOLTIP_WIDTH 270.0
#define BUTTON_WIDTH 45.0
#define BUTTON_HEIGHT 34.0
#define TOOLTIP_CAP 15
#define MARGIN_X 15.0
#define MARGIN_Y 15.0
#define MARGIN_Y_SM 2.0
#define POPOVER_WIDTH 300.0

static UIImage *_plusButtonOn = nil;
static UIImage *_plusButtonOff = nil;
static UIImage *_minusButtonOn = nil;
static UIImage *_minusButtonOff = nil;

@interface TooltipViewController (Private)

- (void)setupButtons;
- (void)setupBackground;
- (void)setupTooltip;
- (void)setupLabels;

- (void)prepareLabels;
- (void)prepareTooltip;

@end

@implementation TooltipViewController

@synthesize treeView = _treeView;
@synthesize talentView = _talentView;
@synthesize bgImageView = _bgImageView;

@synthesize availableHeight = _availableHeight;

@synthesize plusButton = _plusButton;
@synthesize minusButton = _minusButton;
@synthesize tooltipLabel = _tooltipLabel;

@synthesize nameLabel = _nameLabel;
@synthesize rankLabel = _rankLabel;
@synthesize depReqLabel = _depReqLabel;
@synthesize tierReqLabel = _tierReqLabel;

@synthesize costLabel = _costLabel;
@synthesize rangeLabel = _rangeLabel;
@synthesize castTimeLabel = _castTimeLabel;
@synthesize cooldownLabel = _cooldownLabel;
@synthesize requiresLabel = _requiresLabel;

+ (void)initialize {
  _plusButtonOn = [[UIImage imageNamed:@"points_plus_on.png"] retain];
  _plusButtonOff = [[UIImage imageNamed:@"points_plus_off.png"] retain];
  _minusButtonOn = [[UIImage imageNamed:@"points_minus_on.png"] retain];
  _minusButtonOff = [[UIImage imageNamed:@"points_minus_off.png"] retain];
}

- (id)init {
  self = [super init];
  if (self) {
    _availableHeight = 564.0;
    _desiredHeight = 15.0; // 75px after buttons and top border spacing
    
    // Base View
    self.view.width = POPOVER_WIDTH;
    self.view.height = 0.0;
    
    [self setupButtons];
    [self setupBackground];
    [self setupTooltip];
    [self setupLabels];
  }
  return self;
}

#pragma mark UI Initialization and Setup
- (void)setupButtons {
  // Add and Subtract Buttons
  _plusButton = [[UIButton alloc] initWithFrame:CGRectMake(POPOVER_WIDTH - MARGIN_X - BUTTON_WIDTH, 15, BUTTON_WIDTH, BUTTON_HEIGHT)];
  _minusButton = [[UIButton alloc] initWithFrame:CGRectMake(POPOVER_WIDTH - MARGIN_X - BUTTON_WIDTH - BUTTON_WIDTH, 15, BUTTON_WIDTH, BUTTON_HEIGHT)];
  [self.plusButton addTarget:self action:@selector(addPoint:) forControlEvents:UIControlEventTouchUpInside];
  [self.minusButton addTarget:self action:@selector(removePoint:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.plusButton];
  [self.view addSubview:self.minusButton];
}

- (void)setupBackground {
  // Background
  UIImage *tooltipBg = [[UIImage imageNamed:@"tooltip_bg.png"] stretchableImageWithLeftCapWidth:TOOLTIP_CAP topCapHeight:TOOLTIP_CAP];
  _bgImageView = [[UIImageView alloc] initWithImage:tooltipBg];
  self.bgImageView.top = 0.0;
  self.bgImageView.width = POPOVER_WIDTH;
  [self.view addSubview:self.bgImageView];
}

- (void)setupTooltip {
  // Tooltip Text View
//  _tooltipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  _tooltipLabel = [[InfoTextView alloc] initWithFrame:CGRectZero];
  self.tooltipLabel.contentInset = UIEdgeInsetsMake(-6, -8, -6, -8);
//  self.tooltipLabel.numberOfLines = INT_MAX;
  self.tooltipLabel.font = [UIFont systemFontOfSize:14.0];
  self.tooltipLabel.textColor = [UIColor colorWithRed:0.9 green:0.746 blue:0.082 alpha:1.0];
  self.tooltipLabel.backgroundColor = [UIColor clearColor];
  [self.view addSubview:self.tooltipLabel];
}

- (void)setupLabels {
  _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.nameLabel.numberOfLines = 2;
  self.nameLabel.font = [UIFont systemFontOfSize:14.0];
  self.nameLabel.textColor = [UIColor whiteColor];
  self.nameLabel.backgroundColor = [UIColor clearColor];
  
  _rankLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.rankLabel.numberOfLines = 2;
  self.rankLabel.font = [UIFont systemFontOfSize:14.0];
  self.rankLabel.textColor = [UIColor whiteColor];
  self.rankLabel.backgroundColor = [UIColor clearColor];
  
  // optional labels for child req and tier req
  _depReqLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.depReqLabel.numberOfLines = 2;
  self.depReqLabel.font = [UIFont systemFontOfSize:14.0];
  self.depReqLabel.textColor = TOOLTIP_COLOR_RED;
  self.depReqLabel.backgroundColor = [UIColor clearColor];
  
  _tierReqLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.tierReqLabel.numberOfLines = 2;
  self.tierReqLabel.font = [UIFont systemFontOfSize:14.0];
  self.tierReqLabel.textColor = TOOLTIP_COLOR_RED;
  self.tierReqLabel.backgroundColor = [UIColor clearColor];
  
  _costLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.costLabel.font = [UIFont systemFontOfSize:14.0];
  self.costLabel.textColor = [UIColor whiteColor];
  self.costLabel.backgroundColor = [UIColor clearColor];
  
  _rangeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.rangeLabel.font = [UIFont systemFontOfSize:14.0];
  self.rangeLabel.textColor = [UIColor whiteColor];
  self.rangeLabel.backgroundColor = [UIColor clearColor];
  
  _castTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.castTimeLabel.font = [UIFont systemFontOfSize:14.0];
  self.castTimeLabel.textColor = [UIColor whiteColor];
  self.castTimeLabel.backgroundColor = [UIColor clearColor];
  
  _cooldownLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.cooldownLabel.font = [UIFont systemFontOfSize:14.0];
  self.cooldownLabel.textColor = [UIColor whiteColor];
  self.cooldownLabel.backgroundColor = [UIColor clearColor];
  
  _requiresLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.requiresLabel.font = [UIFont systemFontOfSize:14.0];
  self.requiresLabel.textColor = [UIColor whiteColor];
  self.requiresLabel.backgroundColor = [UIColor clearColor];
  
  [self.view addSubview:self.nameLabel];
  [self.view addSubview:self.rankLabel];
  [self.view addSubview:self.depReqLabel];
  [self.view addSubview:self.tierReqLabel];
  [self.view addSubview:self.costLabel];
  [self.view addSubview:self.rangeLabel];
  [self.view addSubview:self.castTimeLabel];
  [self.view addSubview:self.cooldownLabel];
  [self.view addSubview:self.requiresLabel];
}

#pragma mark Prepare Methods
// Prepare methods are called whenever the controller gets new or changed data
// When loading a new tooltip or adding/removing a point refresh
- (void)prepareButtons {
  if ([self.treeView canAddPoint:self.talentView]) {
    [self.plusButton setImage:_plusButtonOn forState:UIControlStateNormal];
  } else {
    [self.plusButton setImage:_plusButtonOff forState:UIControlStateNormal];
  }
  if ([self.treeView canSubtractPoint:self.talentView]) {
    [self.minusButton setImage:_minusButtonOn forState:UIControlStateNormal];
  } else {
    [self.minusButton setImage:_minusButtonOff forState:UIControlStateNormal];
  }
}

- (void)prepareLabels {
  CGSize labelSize;
  
  // Add name label
  self.nameLabel.text = self.talentView.talent.talentName;
  labelSize = [self.nameLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(TOOLTIP_WIDTH - BUTTON_WIDTH - BUTTON_WIDTH, INT_MAX) lineBreakMode:UILineBreakModeWordWrap];
  self.nameLabel.top = _desiredHeight;
  self.nameLabel.left = MARGIN_X;
  self.nameLabel.width = labelSize.width;
  self.nameLabel.height = labelSize.height;
  
  _desiredHeight = self.nameLabel.bottom + MARGIN_Y_SM;
  
  // Add rank label
  NSInteger maxRank = [self.talentView.talent.ranks count];
  self.rankLabel.text = [NSString stringWithFormat:@"%@ %d/%d", NSLocalizedString(@"Rank", @"Rank"), self.talentView.currentRank , maxRank];
  labelSize = [self.rankLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(TOOLTIP_WIDTH - BUTTON_WIDTH - BUTTON_WIDTH, INT_MAX) lineBreakMode:UILineBreakModeWordWrap];
  
  self.rankLabel.top = _desiredHeight;
  self.rankLabel.left = MARGIN_X;
  self.rankLabel.width = labelSize.width;
  self.rankLabel.height = labelSize.height;
  
  _desiredHeight = self.rankLabel.bottom + MARGIN_Y_SM;
  
  // Only show if there is a parent dependency
  NSNumber *reqId = self.talentView.talent.req;
  if (reqId) {
    TalentViewController *req = [self.treeView.talentViewDict objectForKey:[reqId stringValue]];
    if (req.state == TalentStateMaxed) {
      self.depReqLabel.hidden = YES;
    } else {
      self.depReqLabel.hidden = NO;
      self.depReqLabel.text = [NSString stringWithFormat:@"Requires %d point(s) in %@", [req.talent.ranks count], req.talent.talentName];
      
      labelSize = [self.depReqLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(TOOLTIP_WIDTH, INT_MAX) lineBreakMode:UILineBreakModeWordWrap];
      self.depReqLabel.top = _desiredHeight;
      self.depReqLabel.left = MARGIN_X;
      self.depReqLabel.width = labelSize.width;
      self.depReqLabel.height = labelSize.height;
    
      _desiredHeight = self.depReqLabel.bottom + MARGIN_Y_SM;
    }
  } else {
    self.depReqLabel.hidden = YES;
  }
  
  // Only show if tier dependency isn't met
  if (self.treeView.pointsInTree < 5 * [self.talentView.talent.tier integerValue]) {
    self.tierReqLabel.hidden = NO;
    self.tierReqLabel.text = [NSString stringWithFormat:@"Requires %d points in %@ Talents", [self.talentView.talent.tier integerValue] * 5, self.treeView.talentTree.talentTreeName];

    labelSize = [self.tierReqLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(TOOLTIP_WIDTH, INT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    self.tierReqLabel.top = _desiredHeight;
    self.tierReqLabel.left = MARGIN_X;
    self.tierReqLabel.width = labelSize.width;
    self.tierReqLabel.height = labelSize.height;
    
    _desiredHeight = self.tierReqLabel.bottom + MARGIN_Y_SM;
  } else {
    self.tierReqLabel.hidden = YES;
  }

  // Spell Detail Labels, these are conditional also
  if ([[self.talentView.talent.ranks anyObject] cost] || [[self.talentView.talent.ranks anyObject] spellRange]) {
    if ([[self.talentView.talent.ranks anyObject] cost]) {
      self.costLabel.hidden = NO;
      self.costLabel.text = [[self.talentView.talent.ranks anyObject] cost];
      [self.costLabel sizeToFit];
      self.costLabel.top = _desiredHeight;
      self.costLabel.left = MARGIN_X;
    } else {
      self.costLabel.hidden = YES;
    }
    if ([[self.talentView.talent.ranks anyObject] spellRange]) {
      self.rangeLabel.hidden = NO;
      self.rangeLabel.text = [[self.talentView.talent.ranks anyObject] spellRange];
      [self.rangeLabel sizeToFit];
      self.rangeLabel.top = _desiredHeight;
      self.rangeLabel.left = POPOVER_WIDTH - self.rangeLabel.width - MARGIN_X;
    } else {
      self.rangeLabel.hidden = YES;
    }
    if (!self.costLabel.hidden) {
      _desiredHeight = self.costLabel.bottom + MARGIN_Y_SM;
    } else {
      _desiredHeight = self.rangeLabel.bottom + MARGIN_Y_SM;
    }
  } else {
    self.costLabel.hidden = YES;
    self.rangeLabel.hidden = YES;
  }
  
  if ([[self.talentView.talent.ranks anyObject] castTime] || [[self.talentView.talent.ranks anyObject] cooldown]) {
    if ([[self.talentView.talent.ranks anyObject] castTime]) {
      self.castTimeLabel.hidden = NO;
      self.castTimeLabel.text = [[self.talentView.talent.ranks anyObject] castTime];
      [self.castTimeLabel sizeToFit];
      self.castTimeLabel.top = _desiredHeight;
      self.castTimeLabel.left = MARGIN_X;
    } else {
      self.castTimeLabel.hidden = YES;
    }
    if ([[self.talentView.talent.ranks anyObject] cooldown]) {
      self.cooldownLabel.hidden = NO;
      self.cooldownLabel.text = [[self.talentView.talent.ranks anyObject] cooldown];
      [self.cooldownLabel sizeToFit];
      self.cooldownLabel.top = _desiredHeight;
      self.cooldownLabel.left = POPOVER_WIDTH - self.cooldownLabel.width - MARGIN_X;
    } else {
      self.cooldownLabel.hidden = YES;
    }
    if (!self.castTimeLabel.hidden) {
      _desiredHeight = self.castTimeLabel.bottom + MARGIN_Y_SM;
    } else {
      _desiredHeight = self.cooldownLabel.bottom + MARGIN_Y_SM;
    }
  } else {
    self.castTimeLabel.hidden = YES;
    self.cooldownLabel.hidden = YES;
  }
  
  // Requires (optional) label
  if ([[self.talentView.talent.ranks anyObject] requires]) {
    self.requiresLabel.hidden = NO;
    self.requiresLabel.text = [[self.talentView.talent.ranks anyObject] requires];
    [self.requiresLabel sizeToFit];
    self.requiresLabel.top = _desiredHeight;
    self.requiresLabel.left = MARGIN_X;
    _desiredHeight = self.requiresLabel.bottom + MARGIN_Y_SM;
  } else {
    self.requiresLabel.hidden = YES;
  }

}

- (void)prepareTooltip {  
  // Populate tooltip text
  // Set an ASC sort on treeNo
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rank" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  [sortDescriptor release];
  NSArray *ranks = [self.talentView.talent.ranks sortedArrayUsingDescriptors:sortDescriptors];
  
  // If currently at rank 0, we show rank 1 text
  // Else we show the current rank's text
  if (self.talentView.currentRank > 0) {
    self.tooltipLabel.text = [[ranks objectAtIndex:self.talentView.currentRank - 1] tooltip];
  } else {
    self.tooltipLabel.text = [[ranks objectAtIndex:self.talentView.currentRank] tooltip];
  }

  self.tooltipLabel.text = [self.tooltipLabel.text stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
  
  // Tooltip TextView size
	CGSize tooltipSize = [self.tooltipLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(TOOLTIP_WIDTH, self.availableHeight - _desiredHeight - MARGIN_Y * 2 - MARGIN_Y_SM * 2) lineBreakMode:UILineBreakModeWordWrap];
  self.tooltipLabel.top = _desiredHeight;
  self.tooltipLabel.left = MARGIN_X;
  self.tooltipLabel.width = tooltipSize.width + 8;
  self.tooltipLabel.height = tooltipSize.height + 4;
  
  _desiredHeight = self.tooltipLabel.bottom;
  
  DLog(@"Preparing tooltip with width: %f, height: %f", tooltipSize.width, tooltipSize.height);
}

- (void)reloadTooltipData {
  _desiredHeight = 15.0;
  [self prepareButtons];
  [self prepareLabels];
  [self prepareTooltip];
  
  // Bring buttons to front
  [self.view bringSubviewToFront:self.plusButton];
  [self.view bringSubviewToFront:self.minusButton];
  
  // Set tooltip bg height
  self.view.height = _desiredHeight + MARGIN_Y;
  self.bgImageView.height = self.view.height;

}

#pragma mark Add/Remove Point
- (void)addPoint:(id)sender {
  if ([self.talentView talentAdd]) {
    [self reloadTooltipData];
  }
}

- (void)removePoint:(id)sender {
  if ([self.talentView talentSubtract]) {
    [self reloadTooltipData];
  }
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
  if (_bgImageView) [_bgImageView release];
  if (_tooltipLabel) [_tooltipLabel release];
  if (_plusButton) [_plusButton release];
  if (_minusButton) [_minusButton release];
  
  if (_nameLabel) [_nameLabel release];
  if (_rankLabel) [_rankLabel release];
  if (_depReqLabel) [_depReqLabel release];
  if (_tierReqLabel) [_tierReqLabel release];
  
  if (_costLabel) [_costLabel release];
  if (_rangeLabel) [_rangeLabel release];
  if (_castTimeLabel) [_castTimeLabel release];
  if (_cooldownLabel) [_cooldownLabel release];
  if (_requiresLabel) [_requiresLabel release];
  
  [super dealloc];
}

@end