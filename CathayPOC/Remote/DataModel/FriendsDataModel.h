//
//  FriendsDataModel.h
//  CathayPOC
//
//  Created by Apple on 2019/9/22.
//  Copyright © 2019 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"



@interface FriendsDataModel : JSONModel
@property (nonatomic,strong) NSString <Optional> *name;
@property (nonatomic,strong) NSString <Optional> *status;
@property (nonatomic,strong) NSString <Optional> *isTop;
@property (nonatomic,strong) NSString <Optional> *fid;
@property (nonatomic,strong) NSString <Optional> *updateDate;

@end
