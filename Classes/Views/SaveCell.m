//
//  SaveCell.m
//  TalentPad
//
//  Created by Peter Shih on 12/21/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "SaveCell.h"
#import "Save.h"
#import "UIView+Additions.h"
#import "NSObject+ConvenienceMethods.h"
#import "NSString+ConvenienceMethods.h"
#import <QuartzCore/QuartzCore.h>
#import "SMACoreDataStack.h"
#import "TalentTree.h"
#import "TalentTree+Fetch.h"
#import "NSDate+HumanInterval.h"

#define SPACING_X 7.0

@interface SaveCell (Private)

+ (NSString *)treeNameForCharacterClassId:(NSInteger)characterClassId andTreeNo:(NSInteger)treeNo;
+ (UIImage *)iconForCharacterClassId:(NSInteger)characterClassId;

@end

@implementation SaveCell

@synthesize iconImageView = _iconImageView;
@synthesize nameLabel = _nameLabel;
@synthesize timestampLabel = _timestampLabel;
@synthesize pointsLabel = _pointsLabel;
@synthesize specTreeLabel = _specTreeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _iconImageView = [[UIImageView alloc] init];
    _nameLabel = [[UILabel alloc] init];
    _timestampLabel = [[UILabel alloc] init];
    _pointsLabel = [[UILabel alloc] init];
    _specTreeLabel = [[UILabel alloc] init];
    
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.timestampLabel.backgroundColor = [UIColor clearColor];
    self.pointsLabel.backgroundColor = [UIColor clearColor];
    self.specTreeLabel.backgroundColor = [UIColor clearColor];
    
    self.nameLabel.textAlignment = UITextAlignmentLeft;
    self.timestampLabel.textAlignment = UITextAlignmentRight;
    self.pointsLabel.textAlignment = UITextAlignmentLeft;
    self.specTreeLabel.textAlignment = UITextAlignmentRight;
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timestampLabel];
    [self.contentView addSubview:self.pointsLabel];
    [self.contentView addSubview:self.specTreeLabel];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.iconImageView.image = nil;
  self.nameLabel.text = nil;
  self.timestampLabel.text = nil;
  self.pointsLabel.text = nil;
  self.specTreeLabel.text = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat editingPadding = self.editing ? 32.0 : 0.0;
  
  CGFloat left = SPACING_X;
  
  self.iconImageView.left = left;
  self.iconImageView.top = 5.0;
  self.iconImageView.width = 50.0;
  self.iconImageView.height = 50.0;
  
  left = self.iconImageView.right + SPACING_X;
  
  self.nameLabel.top = 8.0;
  self.specTreeLabel.top = 8.0;
  self.pointsLabel.top = 30.0;
  self.timestampLabel.top = 30.0;
  
  CGFloat textWidth = self.contentView.width - self.iconImageView.width - 3 * SPACING_X - editingPadding;
  CGSize textSize = CGSizeMake(textWidth, INT_MAX);
  
  // Save Name
  CGSize nameSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
  self.nameLabel.width = nameSize.width;
  self.nameLabel.height = nameSize.height;
  self.nameLabel.left = left;
  
  // Points Spent
  CGSize pointsSize = [self.pointsLabel.text sizeWithFont:self.pointsLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
  self.pointsLabel.width = pointsSize.width;
  self.pointsLabel.height = pointsSize.height;
  self.pointsLabel.left = left;
  
  // Specialization Tree
  CGSize specTreeSize = [self.specTreeLabel.text sizeWithFont:self.specTreeLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
  self.specTreeLabel.width = specTreeSize.width;
  self.specTreeLabel.height = specTreeSize.height;
  self.specTreeLabel.left = self.contentView.right - self.specTreeLabel.width - SPACING_X - editingPadding;
  
  // Timestamp
  CGSize timestampSize = [self.timestampLabel.text sizeWithFont:self.timestampLabel.font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
  self.timestampLabel.width = timestampSize.width;
  self.timestampLabel.height = timestampSize.height;
  self.timestampLabel.left = self.contentView.right - self.timestampLabel.width - SPACING_X - editingPadding;
}

+ (void)fillCell:(SaveCell *)cell withSave:(Save *)save {
  cell.iconImageView.image = [self iconForCharacterClassId:[save.characterClassId integerValue]];
  
  cell.nameLabel.text = save.saveName;
  cell.pointsLabel.text = [NSString stringWithFormat:@"%@ / %@ / %@", save.leftPoints, save.middlePoints, save.rightPoints];
  cell.specTreeLabel.text = [self treeNameForCharacterClassId:[save.characterClassId integerValue] andTreeNo:[save.saveSpecTree integerValue]];
  cell.timestampLabel.text = [save.timestamp humanIntervalSinceNow];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

#pragma mark Helpers
+ (NSString *)treeNameForCharacterClassId:(NSInteger)characterClassId andTreeNo:(NSInteger)treeNo {
  NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"TalentTree" inManagedObjectContext:context];
  
  NSFetchRequest *request = [TalentTree fetchRequestForTalentTreeWithCharacterClassId:characterClassId andTreeNo:treeNo];
  [request setEntity:entity];
  
  NSError *error;
  NSArray *array = [context executeFetchRequest:request error:&error];
  if(array) {
    TalentTree *specTree = [array objectAtIndex:0];
    return specTree.talentTreeName;
  } else {
    return @"Not Found";
  }
}

+ (UIImage *)iconForCharacterClassId:(NSInteger)characterClassId {
  NSString *className;
  switch (characterClassId) {
    case 1:
      className = @"warrior";
      break;
    case 2:
      className = @"paladin";
      break;
    case 3:
      className = @"hunter";
      break;
    case 4:
      className = @"rogue";
      break;
    case 5:
      className = @"priest";
      break;
    case 6:
      className = @"deathknight";
      break;
    case 7:
      className = @"shaman";
      break;
    case 8:
      className = @"mage";
      break;
    case 9:
      className = @"warlock";
      break;
    case 11:
      className = @"druid";
      break;
    default:
      className = @"ghostcrawler";
      break;
  }
  return [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@.png", className]];
}

- (void)dealloc {
  [_iconImageView release];
  [_nameLabel release];
  [_timestampLabel release];
  [_pointsLabel release];
  [_specTreeLabel release];
  [super dealloc];
}


@end
