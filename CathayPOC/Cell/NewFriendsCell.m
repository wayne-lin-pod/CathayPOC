//
//  NewFriendsCell.m
//  CathayPOC
//
//  Created by Apple on 2019/9/15.
//  Copyright © 2019 Apple. All rights reserved.
//

#import "NewFriendsCell.h"


@implementation NewFriendsCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setViewStyle:self.bottomView];
    [self setViewStyle:self.subView];
}

- (void) setViewStyle:(UIView *)view {
    view.layer.cornerRadius = view.frame.size.height/10;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 0.1;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(5,5);
    view.layer.shadowOpacity = 0.1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


@end
