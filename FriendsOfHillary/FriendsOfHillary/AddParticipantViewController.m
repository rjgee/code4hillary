//
//  AddParticipantViewController.m
//  FriendsOfHillary
//
//  Created by Sid Gidwani on 4/30/16.
//  Copyright © 2016 Code4Hillary. All rights reserved.
//

#import "AddParticipantViewController.h"
#import "APIController.h"

@interface AddParticipantViewController ()

@property (nonatomic, weak) IBOutlet UITextField *firstNameField;
@property (nonatomic, weak) IBOutlet UITextField *lastNameField;
@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UITextField *phoneField;

@end

@implementation AddParticipantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addParticipant:(id)sender {
  [APIController sendRequest:[NSString stringWithFormat:@"https://api.thegroundwork.com/events/events/%@/invitations", [self.event objectForKey:@"id"]] withMethod:@"POST" andData:@[@{@"email":self.emailField.text, @"phone":self.phoneField.text, @"firstName":self.firstNameField.text, @"lastName":self.lastNameField.text}] timeout:10.0 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
      }
      else {
        id responseObject = nil;
        if ((data != nil) && (data.length != 0)) {
          [self.navigationController popViewControllerAnimated:YES];
        }
      }
    });
    
  }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
