//
//  APIController.h
//  FriendsOfHillary
//
//  Created by Sid Gidwani on 4/30/16.
//  Copyright © 2016 Code4Hillary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIController : NSObject

+ (void)sendRequest: (NSString *)url
         withMethod: (NSString *) httpMethod
            andData: (id)httpData
            timeout: (NSTimeInterval)timeout
  completionHandler: (void (^)( NSData *, NSURLResponse *,NSError *))completionHandler;

@end
