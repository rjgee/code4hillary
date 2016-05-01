//
//  EventsViewController.m
//  FriendsOfHillary
//
//  Created by Sid Gidwani on 4/30/16.
//  Copyright © 2016 Code4Hillary. All rights reserved.
//

#import "EventsViewController.h"
#import "APIController.h"
#import "ParticipantsViewController.h"

@interface EventsViewController ()

@property (strong, nonatomic) NSArray *events;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.title = @"My Events";
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self action:@selector(addButtonPressed)];
  self.navigationItem.rightBarButtonItem = addButton;
}

- (void)addButtonPressed {
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [APIController sendRequest:@"https://api.thegroundwork.com/events/events" withMethod:@"GET" andData:nil timeout:10.0 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
        self.events = [responseObject objectForKey:@"results"];
        [self.tableView reloadData];
      }
    });
  }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *selectionCell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell"];
  
  NSDictionary *event = [self.events objectAtIndex:indexPath.row];
  
  selectionCell.textLabel.text = [event objectForKey:@"title"];
  
  return selectionCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.events.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  NSDictionary *event = [self.events objectAtIndex:indexPath.row];
  
  [self performSegueWithIdentifier:@"myEventsToParticipants" sender:event];
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
  NSDictionary *event = (NSDictionary *)sender;
  ParticipantsViewController *vc = (ParticipantsViewController *)segue.destinationViewController;
  vc.event = event;
}

@end
