//
//  TalentButtonViewController.h
//  WoWTalentPro
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TalentButton;

@interface TalentButtonViewController : UIViewController {
  IBOutlet TalentButton *_talentButton;
  IBOutlet UIImageView *_talentBorderView;
  IBOutlet UILabel *_talentLabel;

  NSInteger _tree;
  NSInteger _tier;
  NSInteger _col;  
  NSInteger _max;
  
  NSInteger _current;
}

@property (nonatomic, assign) NSInteger tree;
@property (nonatomic, assign) NSInteger tier;
@property (nonatomic, assign) NSInteger col;
@property (nonatomic, assign) NSInteger max;

- (IBAction)talentAction;

@end
