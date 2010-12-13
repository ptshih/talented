//
//  TalentViewController.m
//  TalentPad
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "TalentViewController.h"
#import "Talent.h"
#import "Constants.h"

@interface TalentViewController (Private)

- (void)prepareTalent;
- (void)updateBorders;

@end

@implementation TalentViewController

@synthesize talent = _talent;
@synthesize delegate = _delegate;
@synthesize state = _state;
@synthesize currentRank = _currentRank;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _state = TalentStateDisabled;
    _currentRank = 0;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self prepareTalent];
}

- (void)prepareTalent {
  NSURL *imageUrl = [[NSURL alloc] initWithString:WOW_ICON_URL(self.talent.icon)];
  NSURLRequest *myRequest = [[NSURLRequest alloc] initWithURL:imageUrl];
  NSData *returnData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:nil error:nil];
  UIImage *myImage  = [[UIImage alloc] initWithData:returnData];
  
  [_talentButton setImage:myImage forState:UIControlStateNormal];
  
  // Setup Frame Border
  [self updateBorders];
}

- (void)updateState {
  DLog(@"Talent: %@ Update State", self.talent);
  _talentLabel.text = [NSString stringWithFormat:@"%d", self.currentRank];
  [self updateBorders];
  
  switch (self.state) {
    case TalentStateDisabled:
      _talentLabel.hidden = YES;
      _talentPointsView.hidden = YES;
      break;
    case TalentStateEnabled:
      _talentLabel.hidden = NO;
      _talentPointsView.hidden = NO;
      break;
    case TalentStateMaxed:
      _talentLabel.hidden = NO;
      _talentPointsView.hidden = NO;
      break;
    default:
      break;
  }
}

- (void)updateStateFinished {
  DLog(@"Talent: %@ Update State Finished", self.talent);
  [self updateState];
  
  // If we are finished, hide all labels for enabled talents with 0 points
  if (self.state == TalentStateEnabled && self.currentRank == 0) {
    _talentLabel.hidden = YES;
    _talentPointsView.hidden = YES;
    if ([self.talent.keyAbility boolValue]) {
      _talentFrameView.image = [UIImage imageNamed:@"ability-frame-gray.png"];
    } else {
      _talentFrameView.image = [UIImage imageNamed:@"icon-frame-gray.png"];
    }
  }
}

- (void)updateBorders {
  // Setup Frame Border
  if ([self.talent.keyAbility boolValue]) {
    if (self.state == TalentStateDisabled) {
      _talentFrameView.image = [UIImage imageNamed:@"ability-frame-gray.png"];
    } else {
      _talentFrameView.image = [UIImage imageNamed:@"ability-frame-yellow.png"];
      _talentPointsView.image = [UIImage imageNamed:@"points-frame-yellow.png"];
      _talentLabel.textColor = LABEL_COLOR_YELLOW;
    }
  } else {
    if (self.state == TalentStateDisabled) {
      _talentFrameView.image = [UIImage imageNamed:@"icon-frame-gray.png"];
    } else if (self.state == TalentStateEnabled) {
      _talentFrameView.image = [UIImage imageNamed:@"icon-frame-green.png"];
      _talentPointsView.image = [UIImage imageNamed:@"points-frame-green.png"];
      _talentLabel.textColor = LABEL_COLOR_GREEN;
    } else {
      _talentFrameView.image = [UIImage imageNamed:@"icon-frame-yellow.png"];
      _talentPointsView.image = [UIImage imageNamed:@"points-frame-yellow.png"];
      _talentLabel.textColor = LABEL_COLOR_YELLOW;
    }
  }
}

// Add a point for now
- (IBAction)talentTapped {
  // Check to see if this talent is disabled
  if (self.state == TalentStateDisabled) {
    return;
  }

  // Check to see if this talent is already maxed
  if (self.state == TalentStateMaxed) {
    return;
  }
      
  if (self.delegate) {
    [self.delegate talentAdd:self];
  }
}

// Need callback for subtract




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
  if (_talentButton) [_talentButton release];
  if (_talentFrameView) [_talentFrameView release];
  if (_talentPointsView) [_talentPointsView release];
  if (_talentLabel) [_talentLabel release];
  [super dealloc];
}


@end