//
//  ViewController.h
//  CathayPOC
//
//  Created by Apple on 2019/9/15.
//  Copyright © 2019 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#define NONEFRIENDSLIST         @"NONEFRIENDSLIST"
#define ONLYFIRENDSLIST         @"ONLYFIRENDSLIST"
#define FRINFDSANDINVITELIST    @"FRINFDSANDINVITELIST"

//Cell ID
#define NEWFRIENDSCELLID        @"NewFriendsCell"
#define FRIENDSCELLID           @"FriendsCell"
#define FRIENDSTOPCELLID        @"FriendTopCell"

@interface ViewController : UIViewController
@property (nonatomic,strong) NSString *inputTypeString;


@end

