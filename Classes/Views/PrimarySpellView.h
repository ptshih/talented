//
//  PrimarySpellView.h
//  TalentPad
//
//  Created by Peter Shih on 12/14/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PrimarySpellButton;

@interface PrimarySpellView : UIView {
  IBOutlet PrimarySpellButton *_primarySpellIcon;
  IBOutlet UILabel *_primarySpellNameLabel;
}

@property (nonatomic, assign) PrimarySpellButton *primarySpellIcon;
@property (nonatomic, assign) UILabel *primarySpellNameLabel;

@end
