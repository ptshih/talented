//
//  LauncherViewController.m
//  TalentPad
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "LauncherViewController.h"
#import "CalculatorViewController.h"
#import "UIView+Additions.h"

static UIImage *_redButtonBackground = nil;
static UIImage *_deathwing = nil;
static UIImage *_deathwing_wings = nil;
static UIImage *_grimbatol = nil;
static UIImage *_icecrown = nil;
static UIImage *_goblin = nil;
static UIImage *_worgen = nil;
static UIImage *_angel = nil;
static UIImage *_sapphiron = nil;
static UIImage *_illidan = nil;
static UIImage *_darkportal = nil;
static UIImage *_arthas = nil;

@interface LauncherViewController (Private)

- (void)classViewAnimation;
- (void)launcherAnimation;
- (void)selectClassWithId:(NSInteger)characterClassId;

@end

@implementation LauncherViewController

@synthesize backgroundArray = _backgroundArray;

+ (void)initialize {
  _redButtonBackground = [[[UIImage imageNamed:@"red_button.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] retain];
  _deathwing = [[UIImage imageNamed:@"deathwing.jpg"] retain];;
  _deathwing_wings = [[UIImage imageNamed:@"deathwing_wings.jpg"] retain];
  _grimbatol = [[UIImage imageNamed:@"grimbatol.jpg"] retain];
  _icecrown = [[UIImage imageNamed:@"icecrown.jpg"] retain];
  _goblin = [[UIImage imageNamed:@"goblin.jpg"] retain];
  _worgen = [[UIImage imageNamed:@"worgen.jpg"] retain];
  _angel = [[UIImage imageNamed:@"angel.jpg"] retain];
  _sapphiron = [[UIImage imageNamed:@"sapphiron.jpg"] retain];
  _illidan = [[UIImage imageNamed:@"illidan.jpg"] retain];
  _darkportal = [[UIImage imageNamed:@"darkportal.jpg"] retain];
  _arthas = [[UIImage imageNamed:@"arthas.jpg"] retain];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"TalentPad";
    _isVisible = NO;
    _isAnimating = NO;
    _backgroundIndex = 0;
    _backgroundArray = [[NSArray arrayWithObjects:_deathwing, _deathwing_wings, _grimbatol, _icecrown, _goblin, _worgen, _angel, _sapphiron, _illidan, _darkportal, _arthas, nil] retain];
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  _isVisible = YES;
  if (!_isAnimating) {
    [self launcherAnimation];
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  _isVisible = NO;
  _isAnimating = NO;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_loadButton setBackgroundImage:_redButtonBackground forState:UIControlStateNormal];
  _launcherBackground.transform = CGAffineTransformMakeScale(1.3, 1.3);
  [self classViewAnimation];
//  [self launcherAnimation];
}

- (void)classViewAnimation {
  _classView.alpha = 0.0;
  [UIView beginAnimations:@"ClassViewAnimation" context:nil];
	[UIView setAnimationDelegate:nil];
	[UIView setAnimationBeginsFromCurrentState:NO];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];  
	[UIView setAnimationDuration:1]; // Fade out is configurable in seconds (FLOAT)
  _classView.alpha = 0.6;
	[UIView commitAnimations];
}

- (void)launcherAnimation {
  _isAnimating = YES;
  _launcherBackground.alpha = 1.0;
  _launcherBackgroundTwo.alpha = 1.0;
  
  _launcherBackground.image = _launcherBackgroundTwo.image;
  _backgroundIndex++;
  if (_backgroundIndex == [self.backgroundArray count]) _backgroundIndex = 0;
  _launcherBackgroundTwo.image = [self.backgroundArray objectAtIndex:_backgroundIndex];

  _launcherBackground.transform = CGAffineTransformMakeScale(1.3, 1.3);
  _launcherBackgroundTwo.transform = CGAffineTransformMakeScale(1.3, 1.3);
  [UIView beginAnimations:@"LauncherAnimation" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationBeginsFromCurrentState:NO];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];  
	[UIView setAnimationDuration:9]; // Fade out is configurable in seconds (FLOAT)
//  [UIView setAnimationRepeatAutoreverses:YES];
//  [UIView setAnimationRepeatCount:INT_MAX];
  [UIView setAnimationDidStopSelector:@selector(launcherAnimationFinished)];
  _launcherBackground.transform = CGAffineTransformMakeScale(1.0, 1.0);
	[UIView commitAnimations];
}

- (void)launcherAnimationFinished {
  [UIView beginAnimations:@"LauncherAnimationTransition" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationBeginsFromCurrentState:NO];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];  
	[UIView setAnimationDuration:1]; // Fade out is configurable in seconds (FLOAT)
  [UIView setAnimationDidStopSelector:@selector(launcherAnimationTransitionFinished)];
  _launcherBackground.alpha = 0.0;
  _launcherBackgroundTwo.alpha = 1.0;

	[UIView commitAnimations];
}

- (void)launcherAnimationTransitionFinished {
  if(_isVisible) {
    [self launcherAnimation];
  }
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
  if (_backgroundArray) [_backgroundArray release];
  [super dealloc];
}


@end
