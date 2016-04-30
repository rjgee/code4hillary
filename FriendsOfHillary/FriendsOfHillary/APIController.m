//
//  APIController.m
//  FriendsOfHillary
//
//  Created by Sid Gidwani on 4/30/16.
//  Copyright © 2016 Code4Hillary. All rights reserved.
//

#import "APIController.h"

@implementation APIController

+ (void)sendRequest: (NSString *)url
         withMethod: (NSString *) httpMethod
            andData: (id)httpData
            timeout: (NSTimeInterval)timeout
  completionHandler: (void (^)( NSData *, NSURLResponse *,NSError *))completionHandler
{
  NSURL *webServiceURL = [[NSURL alloc] initWithString:url];
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:webServiceURL
                                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                     timeoutInterval:timeout];
  
  [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  
  if ([request.URL.absoluteString containsString:@"oauth/token"]) {
    [request addValue:@"Basic cHViLWd3Lmd3anMtZGV2LWNlbnRlci0tWG5qWFdLcDR1TXlLdHF1ODNVcUFKZzFnUllLT0JlX1dBcUlTOUwzVW5RVjBlQ2Y1ZTQ0eHl3MUtRNWdPZ0hyU2tKUF9Pc181UDdUWUVSUVduRlNrV0E6" forHTTPHeaderField:@"Authorization"];
  }
  else {
    NSString *authenticationToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"authenticationToken"];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", authenticationToken] forHTTPHeaderField:@"Authorization"];
  }
  [request setHTTPMethod:httpMethod];
  
  if (httpData) {
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:httpData options:0 error:&error];
    [request setHTTPBody:postData];
  }
  
  NSLog(@"\n****Sending HTTP Request****\nRequest:%@ %@\nHeaders:%@\nBody:%@\n", request.HTTPMethod, request.URL.absoluteString, request.allHTTPHeaderFields, [[NSString alloc] initWithData:[request HTTPBody] encoding:NSASCIIStringEncoding]);
  
  void (^wrappedCompletionHandler)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) = ^void (NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    NSError *jsonDecodeError = nil;
    id responseObject = nil;
    if ((data != nil) && (data.length != 0)) {
      responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonDecodeError];
    }
    NSLog(@"\n****Received HTTP Response****\nRequest:%@ %@\nResponse:%@\nHeaders:%@\nBody:%@\nError:%@\n", request.HTTPMethod, response.URL.absoluteString, [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode], httpResponse.allHeaderFields, responseObject, error.localizedDescription);
    if (error == nil) {
      NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)httpResponse.statusCode);
      if ([[responseObject class] isSubclassOfClass:[NSDictionary class]]) {
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        NSString *authenticationToken = [responseDict objectForKey:@"accessToken"];
        if (authenticationToken != nil) {
          [[NSUserDefaults standardUserDefaults] setObject:authenticationToken forKey:@"authenticationToken"];
          [[NSUserDefaults standardUserDefaults] synchronize];
        }
      }
    }
    
    completionHandler(data, response, error);
  };
  NSURLSession *session = [NSURLSession sharedSession];
  [[session dataTaskWithRequest:request completionHandler:wrappedCompletionHandler] resume];
}

@end
