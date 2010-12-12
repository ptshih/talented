//
//  TalentViewController.h
//  TalentPad
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TalentDelegate <NSObject>
@required
- (void)talentTapped:(id)sender;
@end

@class Talent;

typedef enum {
  TalentStateDisabled = 0,
  TalentStateEnabled = 1,
  TalentStateMaxed = 2,
  TalentStateFinished = 3
} TalentState;

@interface TalentViewController : UIViewController {
  IBOutlet UIImageView *_talentBorderView;
  IBOutlet UILabel *_talentLabel;
  
  Talent *_talent;
  id <TalentDelegate> _delegate;
  
  NSInteger _state;
}

@property (nonatomic, assign) Talent *talent;
@property (nonatomic, assign) id <TalentDelegate> delegate;
@property (nonatomic, assign) NSInteger state;

@end
