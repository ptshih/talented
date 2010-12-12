//
//  TalentViewController.h
//  TalentPad
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TalentViewController;

@protocol TalentDelegate <NSObject>
@required
- (void)talentAdd:(TalentViewController *)sender;
- (void)talentSubtract:(TalentViewController *)sender;
@end

@class Talent;

typedef enum {
  TalentStateDisabled = 0,
  TalentStateEnabled = 1,
  TalentStateMaxed = 2,
  TalentStateFinished = 3
} TalentState;

@interface TalentViewController : UIViewController {
  IBOutlet UIButton *_talentButton;
  IBOutlet UIImageView *_talentFrameView;
  IBOutlet UIImageView *_talentPointsView;
  IBOutlet UILabel *_talentLabel;

  Talent *_talent;
  id <TalentDelegate> _delegate;
  
  NSInteger _state;
  NSInteger _currentRank;
}

@property (nonatomic, assign) Talent *talent;
@property (nonatomic, assign) id <TalentDelegate> delegate;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger currentRank;

- (IBAction)talentTapped;
- (void)updateState;

@end
