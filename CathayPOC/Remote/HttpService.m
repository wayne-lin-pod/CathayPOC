//
//  HttpService.m
//  CathayPOC
//
//  Created by Apple on 2019/9/22.
//  Copyright © 2019 Apple. All rights reserved.
//

#import "HttpService.h"

@implementation HttpService
+ (void) requestWithParams:(NSDictionary *)params AndAPIKey:(NSString *)apiKey AndSuccessBlock:(SuccseeBlock)succseeBlock AndErrorBlock:(ErrorBlock)errorBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_IP, apiKey];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
    if (!jsonData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            errorBlock([NSString stringWithFormat:@"%@",err]);
        });
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [urlRequest setHTTPMethod:HTTPMETHOD];
    NSData *bodyData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest setHTTPBody:bodyData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                
            }else{
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if(httpResponse.statusCode == 200){
                    NSError *parseError = nil;
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                    succseeBlock([responseDictionary objectForKey:@"response"],apiKey);
                }else{
                    errorBlock([NSString stringWithFormat:@"%ld", [httpResponse statusCode]]);
                }
            }
        });
    }];
    [dataTask resume];
}

@end
