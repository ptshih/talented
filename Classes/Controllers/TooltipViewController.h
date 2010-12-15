//
//  TooltipViewController.h
//  TalentPad
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TreeViewController;
@class TalentViewController;
@class InfoTextView;
@class PrimarySpell;
@class Mastery;

typedef enum {
  TooltipSourceTalent = 0,
  TooltipSourcePrimarySpell = 1,
  TooltipSourceMastery = 2
} TooltipSource;

@interface TooltipViewController : UIViewController {
  TreeViewController *_treeView;
	TalentViewController *_talentView;

  NSInteger _tooltipSource;
  Mastery *_mastery;
  PrimarySpell *_primarySpell;
  
  CGFloat _availableHeight;
  CGFloat _desiredHeight;
  
  UIImageView *_bgImageView;
  UIButton *_plusButton;
  UIButton *_minusButton;
  UIButton *_closeButton;
  
  InfoTextView *_tooltipLabel;
  
  UILabel *_nameLabel;
  UILabel *_rankLabel;
  UILabel *_depReqLabel; // dependency requirement
  UILabel *_tierReqLabel; // tier points spent requirement
  
  // Attributes Labels
  UILabel *_costLabel;
  UILabel *_rangeLabel;
  UILabel *_castTimeLabel;
  UILabel *_cooldownLabel;
  UILabel *_requiresLabel;
  
}

@property (nonatomic, assign) TreeViewController *treeView;
@property (nonatomic, assign) TalentViewController *talentView;

@property (nonatomic, assign) NSInteger tooltipSource;
@property (nonatomic, assign) Mastery *mastery;
@property (nonatomic, assign) PrimarySpell *primarySpell;

@property (nonatomic, assign) CGFloat availableHeight;

@property (nonatomic, retain) UIImageView *bgImageView;
@property (nonatomic, retain) UIButton *plusButton;
@property (nonatomic, retain) UIButton *minusButton;
@property (nonatomic, retain) UIButton *closeButton;

@property (nonatomic, retain) InfoTextView *tooltipLabel;

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *rankLabel;
@property (nonatomic, retain) UILabel *depReqLabel;
@property (nonatomic, retain) UILabel *tierReqLabel;

@property (nonatomic, retain) UILabel *costLabel;
@property (nonatomic, retain) UILabel *rangeLabel;
@property (nonatomic, retain) UILabel *castTimeLabel;
@property (nonatomic, retain) UILabel *cooldownLabel;
@property (nonatomic, retain) UILabel *requiresLabel;

- (void)reloadTooltipData;

@end
