//
//  HttpService.h
//  CathayPOC
//
//  Created by Apple on 2019/9/22.
//  Copyright © 2019 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SERVER_IP       @"https://dimanyen.github.io/"
#define USERDATA        @"man.json"
#define FRIENDSLIST_1   @"friend1.json"
#define FRIENDSLIST_2   @"friend2.json"
#define INVITELIST      @"friend3.json"
#define NONEFRIENDS     @"friend4.json"
#define HTTPMETHOD      @"GET"

@interface HttpService : NSObject

typedef void (^SuccseeBlock)(id model, NSString *apiName);
typedef void (^ErrorBlock)(NSString *code);
+ (void) requestWithParams:(NSDictionary *)params AndAPIKey:(NSString *)apiKey AndSuccessBlock:(SuccseeBlock)succseeBlock AndErrorBlock:(ErrorBlock)errorBlock;
@end

