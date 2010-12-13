//
//  TalentViewController.m
//  TalentPad
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "TalentViewController.h"
#import "Talent.h"
#import "UIImage+Manipulation.h"
#import "Constants.h"

static UIImage *_iconYellow = nil;
static UIImage *_iconGreen = nil;
static UIImage *_iconGray = nil;
static UIImage *_pointsGreen = nil;
static UIImage *_pointsYellow = nil;
static UIImage *_abilityGray = nil;
static UIImage *_abilityYellow = nil;

@interface TalentViewController (Private)

- (void)prepareTalent;
- (void)updateBorders;

@end

@implementation TalentViewController

@synthesize talent = _talent;
@synthesize delegate = _delegate;
@synthesize state = _state;
@synthesize currentRank = _currentRank;

+ (void)initialize {
  _iconGray = [[UIImage imageNamed:@"icon-frame-gray.png"] retain];
  _iconGreen = [[UIImage imageNamed:@"icon-frame-green.png"] retain];
  _iconYellow = [[UIImage imageNamed:@"icon-frame-yellow.png"] retain];
  
  _pointsGreen = [[UIImage imageNamed:@"points-frame-green.png"] retain];
  _pointsYellow = [[UIImage imageNamed:@"points-frame-yellow.png"] retain];
  
  _abilityGray = [[UIImage imageNamed:@"ability-frame-gray.png"] retain];
  _abilityYellow = [[UIImage imageNamed:@"ability-frame-yellow.png"] retain];
}

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
  
  _talentColor = myImage;
  _talentGrayscale = [[UIImage convertToGrayscale:myImage] retain];
  [_talentButton setImage:_talentColor forState:UIControlStateNormal];
  
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
      [_talentButton setImage:_talentGrayscale forState:UIControlStateNormal];
      break;
    case TalentStateEnabled:
      _talentLabel.hidden = NO;
      _talentPointsView.hidden = NO;
      [_talentButton setImage:_talentColor forState:UIControlStateNormal];
      break;
    case TalentStateMaxed:
      _talentLabel.hidden = NO;
      _talentPointsView.hidden = NO;
      [_talentButton setImage:_talentColor forState:UIControlStateNormal];
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
    [_talentButton setImage:_talentGrayscale forState:UIControlStateNormal];
    if ([self.talent.keyAbility boolValue]) {
      _talentFrameView.image = _abilityGray;
    } else {
      _talentFrameView.image = _iconGray;
    }
  }
}

- (void)updateBorders {
  // Setup Frame Border
  if ([self.talent.keyAbility boolValue]) {
    if (self.state == TalentStateDisabled) {
      _talentFrameView.image = _abilityGray;
    } else {
      _talentFrameView.image = _abilityYellow;
      _talentPointsView.image = _pointsYellow;
      _talentLabel.textColor = LABEL_COLOR_YELLOW;
    }
  } else {
    if (self.state == TalentStateDisabled) {
      _talentFrameView.image = _iconGray;
    } else if (self.state == TalentStateEnabled) {
      _talentFrameView.image = _iconGreen;
      _talentPointsView.image = _pointsGreen;
      _talentLabel.textColor = LABEL_COLOR_GREEN;
    } else {
      _talentFrameView.image = _iconYellow;
      _talentPointsView.image = _pointsYellow;
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
  if (_talentColor) [_talentColor release];
  if (_talentGrayscale) [_talentGrayscale release];
  [super dealloc];
}


@end