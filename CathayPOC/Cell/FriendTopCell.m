//
//  FriendTopCell.m
//  CathayPOC
//
//  Created by Apple on 2019/9/15.
//  Copyright © 2019 Apple. All rights reserved.
//

#import "FriendTopCell.h"

@implementation FriendTopCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.searchView.layer.cornerRadius = 10;
    self.searchView.clipsToBounds = YES;
    self.inputTxt.returnKeyType = UIReturnKeyDone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
