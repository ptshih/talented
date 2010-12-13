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

@interface TooltipViewController : UIViewController {
  TreeViewController *_treeView;
	TalentViewController *_talentView;
  
  CGFloat _desiredHeight;
  
  UIImageView *_bgImageView;
  UIButton *_plusButton;
  UIButton *_minusButton;
  UILabel *_tooltipLabel;
  
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

@property (nonatomic, retain) UIImageView *bgImageView;
@property (nonatomic, retain) UIButton *plusButton;
@property (nonatomic, retain) UIButton *minusButton;
@property (nonatomic, retain) UILabel *tooltipLabel;

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *rankLabel;
@property (nonatomic, retain) UILabel *depReqLabel;
@property (nonatomic, retain) UILabel *tierReqLabel;

@property (nonatomic, retain) UILabel *costLabel;
@property (nonatomic, retain) UILabel *rangeLabel;
@property (nonatomic, retain) UILabel *castTimeLabel;
@property (nonatomic, retain) UILabel *cooldownLabel;
@property (nonatomic, retain) UILabel *requiresLabel;

- (void)loadTooltipPopup;

@end
