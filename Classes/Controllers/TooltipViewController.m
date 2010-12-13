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

#define TOOLTIP_WIDTH 250.0
#define BUTTON_WIDTH 79.0
#define BUTTON_HEIGHT 38.0
#define TOOLTIP_CAP 15

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
    _desiredHeight = 75.0; // 75px after buttons and top border spacing
    
    // Base View
    self.view.width = 280.0;
    self.view.height = 0.0;
    
    
    [self setupButtons];
    [self setupBackground];
    [self setupTooltip];
    [self setupLabels];
    
    // Add to subview
    [self.view addSubview:self.bgImageView];    
    [self.view addSubview:self.plusButton];
    [self.view addSubview:self.minusButton];
    [self.view addSubview:self.tooltipLabel];
    
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.rankLabel];
  }
  return self;
}

#pragma mark UI Initialization and Setup
- (void)setupButtons {
  // Add and Subtract Buttons
  _plusButton = [[UIButton alloc] initWithFrame:CGRectMake(140, 15, BUTTON_WIDTH, BUTTON_HEIGHT)];
  _minusButton = [[UIButton alloc] initWithFrame:CGRectMake(61, 15, BUTTON_WIDTH, BUTTON_HEIGHT)];
  [self.plusButton addTarget:self action:@selector(addPoint:) forControlEvents:UIControlEventTouchUpInside];
  [self.minusButton addTarget:self action:@selector(removePoint:) forControlEvents:UIControlEventTouchUpInside];
  [self.plusButton setImage:_plusButtonOn forState:UIControlStateNormal];
  [self.minusButton setImage:_minusButtonOn forState:UIControlStateNormal];
}

- (void)setupBackground {
  // Background
  UIImage *tooltipBg = [[UIImage imageNamed:@"tooltip_bg.png"] stretchableImageWithLeftCapWidth:TOOLTIP_CAP topCapHeight:TOOLTIP_CAP];
  _bgImageView = [[UIImageView alloc] initWithImage:tooltipBg];
  self.bgImageView.top = 60.0; 
}

- (void)setupTooltip {
  // Tooltip Text View
  _tooltipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.tooltipLabel.numberOfLines = INT_MAX;
  self.tooltipLabel.font = [UIFont systemFontOfSize:14.0];
  self.tooltipLabel.textColor = [UIColor colorWithRed:0.9 green:0.746 blue:0.082 alpha:1.0];
  self.tooltipLabel.backgroundColor = [UIColor clearColor];
}

- (void)setupLabels {
  _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.nameLabel.font = [UIFont systemFontOfSize:14.0];
  self.nameLabel.textColor = [UIColor whiteColor];
  self.nameLabel.backgroundColor = [UIColor clearColor];
  
  _rankLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.rankLabel.font = [UIFont systemFontOfSize:14.0];
  self.rankLabel.textColor = [UIColor whiteColor];
  self.rankLabel.backgroundColor = [UIColor clearColor];
  
}

#pragma mark UI Layout
- (void)prepareLabels {
  // Add name label
  self.nameLabel.text = self.talentView.talent.talentName;
  [self.nameLabel sizeToFit];
  
  // Add rank label
  NSInteger maxRank = [self.talentView.talent.ranks count];
  self.rankLabel.text = [NSString stringWithFormat:@"Rank %d/%d",self.talentView.currentRank , maxRank];
  [self.rankLabel sizeToFit];
  
  self.nameLabel.top = _desiredHeight;
  self.nameLabel.left = 15.0;
  
  _desiredHeight = self.nameLabel.bottom + 2.0;
  
  self.rankLabel.top = _desiredHeight;
  self.rankLabel.left = 15.0;
  
  _desiredHeight = self.rankLabel.bottom + 2.0;
  
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

//  [self.tooltipLabel.text stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
  
  // Tooltip TextView size
	CGSize tooltipSize = [self.tooltipLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(TOOLTIP_WIDTH, INT_MAX) lineBreakMode:UILineBreakModeWordWrap];
  self.tooltipLabel.top = _desiredHeight;
  self.tooltipLabel.left = 15.0;
  self.tooltipLabel.width = tooltipSize.width;
  self.tooltipLabel.height = tooltipSize.height;
  
  _desiredHeight = self.tooltipLabel.bottom;
  
  DLog(@"Preparing tooltip with width: %f, height: %f", tooltipSize.width, tooltipSize.height);
}

- (void)loadTooltipPopup {
  _desiredHeight = 75.0;
  [self prepareLabels];
  [self prepareTooltip];
  
  
  // Set tooltip bg height
  self.view.height = _desiredHeight + 15.0;
  self.bgImageView.height = self.view.height - 60.0;

}

- (void)updateLabels {
  // Update Rank Label
  NSInteger maxRank = [self.talentView.talent.ranks count];
  self.rankLabel.text = [NSString stringWithFormat:@"Rank %d/%d",self.talentView.currentRank , maxRank];
  [self.rankLabel sizeToFit];
  
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
}

#pragma mark Add/Remove Point
- (void)addPoint:(id)sender {
  if ([self.talentView talentAdd]) {
    [self updateLabels];
  }
}

- (void)removePoint:(id)sender {
  if ([self.talentView talentSubtract]) {
    [self updateLabels];
  }
}

// create and setup the tooltip frame
//- (void)setTooltip {
//	// Calculate frame size and positioning based on button held
//	//	self.view.frame = CGRectMake(15 + (80 * button.col), 10 + (64 * button.row), self.view.frame.size.width, self.view.frame.size.height);
//	
//  //	NSLog(@"button col: %d, row: %d",self.button.col, self.button.row);
//	
//	NSInteger top, left, width, height, bottom; //, invHeight;
//	width = 260; // width of tooltip
//	height = 0; // dynamic calc height
//	//invHeight = 0;
//  
//  // Access talent properties
//  NSInteger tier = [self.talentView.talent.tier integerValue];
//  NSInteger treeNo = [self.talentView.talent.talentTree.treeNo integerValue];
//  
//  top = tier * 64 + 74;
//  bottom = (10 - tier) * 64 + 74;
//  
//  left = ((320 - width) / 2) + treeNo * 320;
//  
//  
//	
//	// First set the frame to a large size
//	self.view.frame = CGRectMake(left, top, width, self.view.frame.size.height);
//	
//	//	infoPage.view.frame = CGRectMake(infoPage.view.frame.origin.x, infoPage.view.frame.origin.y, infoPage.view.frame.size.width, infoPage.view.frame.size.height);
//	[self setInfo]; // Because this view is persistent, can't use init/viewdidload
//	
//  BOOL canAdd = [self.treeView canAddPoint:self.talentView];
//  
//	BOOL dependMet = YES;
//	BOOL depend2Met = YES;
//	NSInteger treePointReq = [delegate.data pointsRequiredForButton:button];
//	if(!canAdd) {
//		// if dependency is met, remove the requirement
//		if(button.depend == nil || button.depend.max == button.depend.rank) {
//			depend2Met = YES;
//		} 
//		// if points spent is met, remove the requirement
//		if([delegate.data pointsSpentInTree:button.tree] >= treePointReq) {
//			dependMet = YES;
//		}
//	} else { // if the point can be added, then we always remove the requirements no matter what
//		depend2Met = YES;
//		dependMet = YES;
//	}
//  
//	
//  //	NSLog(@"canadd: %d, d1: %d, d2: %d",canAdd, dependMet, depend2Met);
//	
//	// height calc
//	height += 45; // add 45px for -/+ buttons
//	height += 15; // add 15px for top tooltip_bg
//	//invHeight += 15;
//	
//	// Deal with name Label first
//	CGSize nameSize = [self.nameLabel sizeThatFits:CGSizeMake(226, 1000)];
//	NSInteger nameOffset = height;
//	height += nameSize.height; // add nameLabel's height
//	//invHeight += nameSize.height;
//	
//	// Rank
//  //	CGSize rankSize = [self.rankLabel sizeThatFits:CGSizeMake(226, 1000)];
//	CGSize rankSize = CGSizeMake(226, 16);
//	NSInteger rankOffset = height;
//	height += rankSize.height; // add rankLabel's height
//	//invHeight += rankSize.height;
//	
//  //	NSLog(@"height so far: %d",height);
//	
//	// Reqs 1
//	NSInteger reqsOffset = 0;
//	CGSize reqsSize;
//	if(([self.reqsLabel.text length] > 0) && (!dependMet)) {
//    //		NSLog(@"wtf");
//    //		reqsSize = [self.reqsLabel sizeThatFits:CGSizeMake(226, 1000)];
//		reqsSize = CGSizeMake(226, 16);
//		reqsOffset = height;
//		height += reqsSize.height; // add requirements height
//		//invHeight += reqsSize.height;
//	}
//	else {
//		reqsSize = CGSizeMake(0, 0);
//	}
//	
//	// Reqs 2
//	NSInteger req2Offset = 0;
//	CGSize req2Size;
//	if([self.req2Label.text length] > 0 && (!depend2Met)) {
//    //		req2Size = [self.req2Label sizeThatFits:CGSizeMake(226, 1000)];
//		req2Size = CGSizeMake(226, 16);
//		req2Offset = height;
//		height += req2Size.height; // add requirements 2 height
//		//invHeight += req2Size.height;
//	}
//	else {
//		req2Size = CGSizeMake(0, 0);
//	}
//  
//	// TL and TR
//	NSInteger topLevelOffset = 0;
//	NSInteger topLevelHeight = 0;
//	if([self.TLLabel.text length] > 0 || [self.TRLabel.text length] > 0) {
//		topLevelOffset = height;
//		topLevelHeight = 16;
//		height += 16;
//		//invHeight += 15;
//	}
//	
//	// BL and BR
//	NSInteger botLevelOffset = 0;
//	NSInteger botLevelHeight = 0;
//	if([self.BLLabel.text length] > 0 || [self.BRLabel.text length] > 0) {
//		botLevelOffset = height;
//		botLevelHeight = 16;
//		height += 16;
//		//invHeight += 15;
//	}
//	
//	// Description size
//	CGSize descSize = CGSizeMake(0, 0);
//	NSInteger descSpacer = 2;
//	NSInteger descOffset = height + descSpacer;
//	height += (descSize.height + descSpacer); // add description height;
//	//invHeight += descSize.height + descSpacer;
//	
//	// Add bottom tooltip bg
//	NSInteger bottomOffset = height;
//	height += 15; // add 15px for bottom tooltip bg
//	//invHeight += 15;
//	
//  //	NSLog(@"final height: %d, inverted: %d",height,invHeight);
//  //	NSLog(@"desc: %@",self.description.text);
//  //	NSLog(@"req: %@, req2: %@",reqsLabel.text, req2Label.text);
//	
//	NSInteger adjDescHeight;
//	NSInteger descHeightDiff;
//	NSInteger diffHeight;
//	NSInteger invertThreshold = 6;
//	
//	// If row is 6 or above, invert tooltip
//	
//	if(tier >= invertThreshold) {
//		if(height > (self.treeView.view.frame.size.height - bottom)) {
//			diffHeight = height - (self.treeView.view.frame.size.height - bottom);
//			adjDescHeight = descSize.height - diffHeight;
//			descHeightDiff = descSize.height - adjDescHeight;
//		} else {
//			adjDescHeight = descSize.height;
//			descHeightDiff = 0;
//			diffHeight = 0;
//		}
//		// Set new frame height
//    //		NSLog(@"top: %d, parent: %g",top, parent.pageView.frame.size.height - top - height + diffHeight);
//		[self.view setFrame:CGRectMake(left, self.treeView.view.frame.size.height - bottom - height + diffHeight, width, height - diffHeight)];
//		
//		// Set Desc Frame
//		[self.bgTop setFrame:CGRectMake(self.bgTop.frame.origin.x, self.bgTop.frame.origin.y - 45, width, 15)];
//		[self.bgImage setFrame:CGRectMake(self.bgImage.frame.origin.x, self.bgImage.frame.origin.y - 45, width, adjDescHeight + descSpacer + rankSize.height + nameSize.height + reqsSize.height + req2Size.height + topLevelHeight + botLevelHeight)];
//		[self.nameLabel setFrame:CGRectMake(self.nameLabel.frame.origin.x, nameOffset - 45, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height)];
//		[self.rankLabel setFrame:CGRectMake(self.rankLabel.frame.origin.x, rankOffset - 45, self.rankLabel.frame.size.width, self.rankLabel.frame.size.height)];
//		if(reqsOffset > 0) [self.reqsLabel setFrame:CGRectMake(self.reqsLabel.frame.origin.x, reqsOffset - 45, self.reqsLabel.frame.size.width, self.reqsLabel.frame.size.height)];
//		else [self.reqsLabel removeFromSuperview];
//		if(req2Offset > 0) [self.req2Label setFrame:CGRectMake(self.req2Label.frame.origin.x, req2Offset - 45, self.req2Label.frame.size.width, self.req2Label.frame.size.height)];
//		else [self.req2Label removeFromSuperview];
//		if(topLevelOffset > 0) {
//			[self.TLLabel setFrame:CGRectMake(self.TLLabel.frame.origin.x, topLevelOffset - 45, self.TLLabel.frame.size.width, self.TLLabel.frame.size.height)];
//			[self.TRLabel setFrame:CGRectMake(self.TRLabel.frame.origin.x, topLevelOffset - 45, self.TRLabel.frame.size.width, self.TRLabel.frame.size.height)];
//		}
//		else {
//			[self.TLLabel removeFromSuperview];
//			[self.TRLabel removeFromSuperview];
//		}
//		if(botLevelOffset > 0) {
//			[self.BLLabel setFrame:CGRectMake(self.BLLabel.frame.origin.x, botLevelOffset - 45, self.BLLabel.frame.size.width, self.BLLabel.frame.size.height)];
//			[self.BRLabel setFrame:CGRectMake(self.BRLabel.frame.origin.x, botLevelOffset - 45, self.BRLabel.frame.size.width, self.BRLabel.frame.size.height)];
//		}
//		else {
//			[self.BLLabel removeFromSuperview];
//			[self.BRLabel removeFromSuperview];
//		}
//		[_tooltip setFrame:CGRectMake(_tooltip.frame.origin.x, descOffset - 45, _tooltip.frame.size.width, adjDescHeight)];
//		[self.bgBottom setFrame:CGRectMake(self.bgBottom.frame.origin.x, bottomOffset - descHeightDiff - 45, width, 15)];
//		[self.addButton setFrame:CGRectMake(self.addButton.frame.origin.x, self.view.frame.size.height - 45, self.addButton.frame.size.width, self.addButton.frame.size.height)];
//		[self.delButton setFrame:CGRectMake(self.delButton.frame.origin.x, self.view.frame.size.height - 45, self.delButton.frame.size.width, self.delButton.frame.size.height)];
//	} else {
//		if(height > (self.treeView.view.frame.size.height - 74)) {
//			diffHeight = height - (self.treeView.view.frame.size.height - 74);
//			adjDescHeight = descSize.height - diffHeight;
//			descHeightDiff = descSize.height - adjDescHeight;
//		} else {
//			adjDescHeight = descSize.height;
//			descHeightDiff = 0;
//			diffHeight = 0;
//		}
//		
//		// Set new frame height
//		[self.view setFrame:CGRectMake(left, top, width, height - diffHeight)];
//		
//		// Set Desc Frame
//		[self.bgTop setFrame:CGRectMake(self.bgTop.frame.origin.x, self.bgTop.frame.origin.y, width, 15)];
//		[self.bgImage setFrame:CGRectMake(self.bgImage.frame.origin.x, self.bgImage.frame.origin.y, width, adjDescHeight + descSpacer + rankSize.height + nameSize.height + reqsSize.height + req2Size.height + topLevelHeight + botLevelHeight)];
//		[self.nameLabel setFrame:CGRectMake(self.nameLabel.frame.origin.x, nameOffset, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height)];
//		[self.rankLabel setFrame:CGRectMake(self.rankLabel.frame.origin.x, rankOffset, self.rankLabel.frame.size.width, self.rankLabel.frame.size.height)];
//		if(reqsOffset > 0) [self.reqsLabel setFrame:CGRectMake(self.reqsLabel.frame.origin.x, reqsOffset, self.reqsLabel.frame.size.width, self.reqsLabel.frame.size.height)];
//		else [self.reqsLabel removeFromSuperview];
//		if(req2Offset > 0) [self.req2Label setFrame:CGRectMake(self.req2Label.frame.origin.x, req2Offset, self.req2Label.frame.size.width, self.req2Label.frame.size.height)];
//		else [self.req2Label removeFromSuperview];
//		if(topLevelOffset > 0) {
//			[self.TLLabel setFrame:CGRectMake(self.TLLabel.frame.origin.x, topLevelOffset, self.TLLabel.frame.size.width, self.TLLabel.frame.size.height)];
//			[self.TRLabel setFrame:CGRectMake(self.TRLabel.frame.origin.x, topLevelOffset, self.TRLabel.frame.size.width, self.TRLabel.frame.size.height)];
//		}
//		else {
//			[self.TLLabel removeFromSuperview];
//			[self.TRLabel removeFromSuperview];
//		}
//		if(botLevelOffset > 0) {
//			[self.BLLabel setFrame:CGRectMake(self.BLLabel.frame.origin.x, botLevelOffset, self.BLLabel.frame.size.width, self.BLLabel.frame.size.height)];
//			[self.BRLabel setFrame:CGRectMake(self.BRLabel.frame.origin.x, botLevelOffset, self.BRLabel.frame.size.width, self.BRLabel.frame.size.height)];
//		}
//		else {
//			[self.BLLabel removeFromSuperview];
//			[self.BRLabel removeFromSuperview];
//		}
//		[_tooltip setFrame:CGRectMake(_tooltip.frame.origin.x, descOffset, _tooltip.frame.size.width, adjDescHeight)];
//		[self.bgBottom setFrame:CGRectMake(self.bgBottom.frame.origin.x, bottomOffset - descHeightDiff, width, 15)];
//	}
//}
//
//- (void)updateInfo {
//  NSInteger maxRank = [self.talentView.talent.ranks count];
//  NSInteger currentRank = self.talentView.currentRank;
//	rankLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"rank", @"Rank word used in descriptions"), [NSString stringWithFormat:@"%i/%i", currentRank, maxRank]];
//	[self updateDesc];
//	//	NSLog(@"text: %@",button.text);
//  
//	[delButton setEnabled:([self.treeView canAddPoint:self.talentView]) ? true : false];
//	[addButton setEnabled:([self.treeView canAddPoint:self.talentView]) ? true : false];
//}
//
//- (void)updateLabels {
//  TalentViewController *reqTalentView = [self.treeView.talentViewDict objectForKey:[self.talentView.talent.req stringValue]];
//  NSInteger reqMaxRank = [reqTalentView.talent.ranks count];
//  NSInteger reqCurrentRank = reqTalentView.currentRank;
//  NSInteger tier = [self.talentView.talent.tier integerValue];
//  
//	BOOL canAdd = [self.treeView canAddPoint:self.talentView];
//	NSInteger treePointReq = 5 * tier;
//	if (canAdd) {
//		[reqsLabel setTextColor:[UIColor whiteColor]];
//		[req2Label setTextColor:[UIColor whiteColor]];
//	} else {
//		if (!self.talentView.talent.req || reqMaxRank == reqCurrentRank) {
//			[req2Label setTextColor:[UIColor whiteColor]];
//		} else {
//			[req2Label setTextColor:[UIColor redColor]];
//		}
//		if (self.treeView.pointsInTree >= treePointReq) {
//			[reqsLabel setTextColor:[UIColor whiteColor]];
//		} else {
//			[reqsLabel setTextColor:[UIColor redColor]];
//		}
//	}
//	
//	if (tier > 0) {
//		reqsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"requires_tier",@"required points tier"),treePointReq, self.treeView.talentTree.talentTreeName];
//		//		reqsLabel.text = [NSString stringWithFormat:@"Requires %i points in %@", treePointReq, [data getNameForTree:button.tree]];
//	} else {
//		reqsLabel.text = @"";
//	}
//	if (self.talentView.talent.req) {
//		req2Label.text = [NSString stringWithFormat:NSLocalizedString(@"requires_dependency",@"required points dependency"), reqMaxRank, (reqMaxRank > 1) ? "s" : "", reqTalentView.talent.talentName];
//		//		req2Label.text = [NSString stringWithFormat:@"Requires %i point%s in %@", button.depend.max, (button.depend.max > 1) ? "s" : "", button.depend.name];
//	} else {
//		req2Label.text = @"";
//	}
//	
//	TLLabel.text = [[self.talentView.talent.ranks anyObject] cost];
//	TRLabel.text = [[self.talentView.talent.ranks anyObject] spellRange];
//	BLLabel.text = [[self.talentView.talent.ranks anyObject] castTime];
//	BRLabel.text = [[self.talentView.talent.ranks anyObject] cooldown];
//	
//}
//
//- (void)updateDesc {
//  // Set an ASC sort on treeNo
//  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rank" ascending:YES];
//  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
//  [sortDescriptor release];
//  NSArray *ranks = [self.talentView.talent.ranks sortedArrayUsingDescriptors:sortDescriptors];
//  
//	if (self.talentView.currentRank > 0) {
//		_tooltip.text = [[ranks objectAtIndex:self.talentView.currentRank - 1] tooltip];
//	} else {
//		_tooltip.text = [[ranks objectAtIndex:self.talentView.currentRank] tooltip];
//	}
//	_tooltip.text = [_tooltip.text stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
//}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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