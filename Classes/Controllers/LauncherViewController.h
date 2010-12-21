//
//  LauncherViewController.h
//  TalentPad
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaveViewController.h"

@interface LauncherViewController : UIViewController <SaveDelegate> {
  IBOutlet UIButton *_loadButton;
  IBOutlet UIImageView *_launcherBackground;
  IBOutlet UIImageView *_launcherBackgroundTwo;
  IBOutlet UIView *_classView;
  BOOL _isVisible;
  BOOL _isAnimating;
  NSArray *_backgroundArray;
  NSInteger _backgroundIndex;
}

@property (nonatomic, retain) NSArray *backgroundArray;

- (IBAction)warrior;
- (IBAction)paladin;
- (IBAction)hunter;
- (IBAction)rogue;
- (IBAction)priest;
- (IBAction)deathknight;
- (IBAction)shaman;
- (IBAction)mage;
- (IBAction)warlock;
- (IBAction)druid;

- (IBAction)load;

@end
