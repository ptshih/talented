//
//  SummaryViewController.h
//  Talented
//
//  Created by Peter Shih on 12/13/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TalentTree;
@class TooltipViewController;
@class Mastery;

@protocol SummaryDelegate <NSObject>
@required
- (void)specTreeSelected:(NSInteger)treeNo;
@end

@interface SummaryViewController : UIViewController {
  IBOutlet UIButton *_redButton;
  IBOutlet UIButton *_primarySpellButton;
  IBOutlet UIButton *_dismissButton;
  IBOutlet UIImageView *_glowView;
  
  CGFloat _desiredHeight;
  
  NSArray *_primarySpells;
  Mastery *_mastery;
  NSMutableArray *_masteryViewArray;
  NSMutableArray *_primarySpellViewArray;
  
  TooltipViewController *_tooltipViewController;
  
  UILabel *_tooltipLabel;
  
  TalentTree *_talentTree;
  id <SummaryDelegate> _delegate;
}

@property (nonatomic, retain) NSArray *primarySpells;
@property (nonatomic, retain) Mastery *mastery;
@property (nonatomic, retain) NSMutableArray *masteryViewArray;
@property (nonatomic, retain) NSMutableArray *primarySpellViewArray;

@property (nonatomic, retain) TooltipViewController *tooltipViewController;

@property (nonatomic, retain) UILabel *tooltipLabel;

@property (nonatomic, assign) TalentTree *talentTree;
@property (nonatomic, assign) id <SummaryDelegate> delegate;

- (IBAction)masteryTapped:(id)sender;
- (IBAction)spellTapped:(id)sender;
- (IBAction)selectSpecTree;
- (IBAction)hideTooltip;

@end
