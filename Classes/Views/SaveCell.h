//
//  SaveCell.h
//  Talented
//
//  Created by Peter Shih on 12/21/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Save;

@interface SaveCell : UITableViewCell {
  UIImageView *_iconImageView;
  UILabel *_nameLabel;
  UILabel *_timestampLabel;
  UILabel *_pointsLabel;
  UILabel *_specTreeLabel;
}

@property (nonatomic, retain) UIImageView *iconImageView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *timestampLabel;
@property (nonatomic, retain) UILabel *pointsLabel;
@property (nonatomic, retain) UILabel *specTreeLabel;

+ (void)fillCell:(SaveCell *)cell withSave:(Save *)save;

@end
