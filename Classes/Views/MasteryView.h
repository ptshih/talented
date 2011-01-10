//
//  PrimarySpellView.h
//  Talented
//
//  Created by Peter Shih on 12/14/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasteryView : UIView {
  IBOutlet UIButton *_masteryIcon;
  IBOutlet UILabel *_masteryNameLabel;
}

@property (nonatomic, assign) UIButton *masteryIcon;
@property (nonatomic, assign) UILabel *masteryNameLabel;

@end
