//
//  ParticipatnsViewController.m
//  FriendsOfHillary
//
//  Created by Sid Gidwani on 4/30/16.
//  Copyright © 2016 Code4Hillary. All rights reserved.
//

#import "ParticipantsViewController.h"
#import "AddParticipantViewController.h"
#import "APIController.h"

@interface ParticipantsViewController ()

@property (strong, nonatomic) NSMutableArray *participants;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ParticipantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self action:@selector(addButtonPressed)];
  self.navigationItem.rightBarButtonItem = addButton;
    // Do any additional setup after loading the view.
  self.title = @"Guests";
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  NSString *eventID = [self.event objectForKey:@"id"];
  [APIController sendRequest:[NSString stringWithFormat:@"https://api.thegroundwork.com/events/events/%@/invitations", eventID] withMethod:@"GET" andData:nil timeout:10.0 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
      }
      else {
        id responseObject = nil;
        if ((data != nil) && (data.length != 0)) {
          responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        }
        self.participants = [[responseObject objectForKey:@"results"] mutableCopy];
        [self.tableView reloadData];
      }
    });
  }];
}

- (void)addButtonPressed {
  [self performSegueWithIdentifier:@"participantsToAddParticipant" sender:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *selectionCell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell"];
  
  NSDictionary *participant = [self.participants objectAtIndex:(self.participants.count - indexPath.row - 1)];
  
  selectionCell.textLabel.text = [NSString stringWithFormat:@"%@, %@", [participant objectForKey:@"familyName"], [participant objectForKey:@"givenName"]];
  
  if ([[participant objectForKey:@"status"] isEqualToString:@"attending"]) {
    selectionCell.accessoryType = UITableViewCellAccessoryCheckmark;
  }
  else {
    selectionCell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  return selectionCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.participants.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  NSMutableDictionary *participant = [[self.participants objectAtIndex:(self.participants.count - indexPath.row - 1)] mutableCopy];
  
  if ([[participant objectForKey:@"status"] isEqualToString:@"attending"]) {
    [participant setObject:@"pending" forKey:@"status"];
  }
  else {
    [participant setObject:@"attending" forKey:@"status"];
  }
  
  [self.participants replaceObjectAtIndex:(self.participants.count - indexPath.row - 1) withObject:participant];
  
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
  AddParticipantViewController *vc = (AddParticipantViewController *)segue.destinationViewController;
  vc.event = self.event;
}


@end
