//
//  TooltipViewController.h
//  Talented
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TooltipDelegate <NSObject>

@optional
- (void)tooltipDidDismiss;

@end

@class TreeViewController;
@class TalentViewController;
@class InfoTextView;
@class PrimarySpell;
@class Mastery;
@class Glyph;

typedef enum {
  TooltipSourceTalent = 0,
  TooltipSourcePrimarySpell = 1,
  TooltipSourceMastery = 2,
  TooltipSourceGlyph = 3
} TooltipSource;

@interface TooltipViewController : UIViewController {
  TreeViewController *_treeView;
	TalentViewController *_talentView;

  NSInteger _tooltipSource;
  Mastery *_mastery;
  PrimarySpell *_primarySpell;
  Glyph *_glyph;
  
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
  
  BOOL _showGlyphHelp;
  id <TooltipDelegate> _delegate;
}

@property (nonatomic, assign) TreeViewController *treeView;
@property (nonatomic, assign) TalentViewController *talentView;

@property (nonatomic, assign) NSInteger tooltipSource;
@property (nonatomic, assign) Mastery *mastery;
@property (nonatomic, assign) PrimarySpell *primarySpell;
@property (nonatomic, assign) Glyph *glyph;

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

@property (nonatomic, assign) BOOL showGlyphHelp;
@property (nonatomic, assign) id <TooltipDelegate> delegate;

- (void)reloadTooltipData;

@end
