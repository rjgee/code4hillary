//
//  LoginViewController.m
//  FriendsOfHillary
//
//  Created by Sid Gidwani on 4/30/16.
//  Copyright © 2016 Code4Hillary. All rights reserved.
//

#import "LoginViewController.h"
#import "APIController.h"
#import "EventsViewController.h"

@interface LoginViewController ()

@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.title = @"Event Manager";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
  [APIController sendRequest:@"https://api.thegroundwork.com/oauth/token" withMethod:@"POST" andData:@{@"email":self.emailField.text, @"password":self.passwordField.text} timeout:10.0 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
      }
      else {
        id responseObject = nil;
        if ((data != nil) && (data.length != 0)) {
          responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
          [self performSegueWithIdentifier:@"loginToMyEvents" sender:nil];
        }
      }
    });
    
  }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
  NSLog(@"going to my events");
}

@end
