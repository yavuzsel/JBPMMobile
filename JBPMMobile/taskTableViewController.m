//
//  taskTableViewController.m
//  JBPMMobile
//
//  Created by yavuz on 7/11/13.
//  Copyright (c) 2013 redhat. All rights reserved.
//

#import "taskTableViewController.h"
#import "taskDetailViewController.h"
#import "JBPMRESTClient.h"
#import <RaptureXML/RXMLElement.h>
#import "Task.h"

@interface taskTableViewController ()

@end

@implementation taskTableViewController

@synthesize taskList = _taskList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _taskList = [[NSMutableArray alloc] init];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    self.navigationItem.hidesBackButton = YES;
    self.tableView.rowHeight = 50.0f;
    id params = @{@"potentialOwner": [JBPMRESTClient sharedClient].username};
    [[JBPMRESTClient sharedClient]
     getPath:@"/business-central/rest/task/query"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         //handle succesful response from server.
         NSLog(@"LOAD SUCCESS: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
         RXMLElement *resultXML = [RXMLElement elementFromXMLData:responseObject];
         NSArray *tasks = [resultXML children:@"task-summary"];
         [resultXML iterateElements:tasks usingBlock:^(RXMLElement *task) {
             NSLog(@"ID: %d, Name: %@", [task child:@"id"].textAsInt, [task child:@"name"].text);
             Task *newTask = [[Task alloc] init];
             newTask.id = [task child:@"id"].textAsInt;
             newTask.name = [task child:@"name"].text;
             newTask.status = [task child:@"status"].text;
             newTask.priority = [task child:@"priority"].text;
             newTask.skipable = [task child:@"skipable"].text;
             newTask.actualOwner = [task child:@"actual-owner"].text;
             newTask.expirationTime = [task child:@"expiration-time"].text;
             newTask.processInstanceID = [task child:@"process-instance-id"].text;
             newTask.processSessionID = [task child:@"process-session-id"].text;
             newTask.subTaskStrategy = [task child:@"sub-task-strategy"].text;
             newTask.parentID = [task child:@"parent-id"].text;
             [_taskList addObject:newTask];
         }];
         [self.tableView reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         // handle error - login failed
         NSLog(@"LOAD FAIL: %@", error);
     }
     ];
}

- (void)logout:(id)sender {
    [self logoutFromServer];
}

- (void)logoutFromServer {
    [[JBPMRESTClient sharedClient]
         getPath:@"/business-central/org.kie.workbench.KIEWebapp/uf_logout" // is this the correct path?
         parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //handle succesful response from server.
             NSLog(@"LOGOUT SUCCESS: %d", [[operation response] statusCode]);
             NSLog(@"LOGOUT SUCCESS: %@", [[operation response] allHeaderFields]);
             [[JBPMRESTClient sharedClient] clearAuthorizationHeader];
             [self.navigationController popToRootViewControllerAnimated:YES];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             // handle error - login failed
             NSLog(@"LOGOUT FAIL: %@", error);
         }
     ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_taskList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.textLabel.text = ((Task *)[_taskList objectAtIndex:indexPath.row]).name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Status: %@", ((Task *)[_taskList objectAtIndex:indexPath.row]).status];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    taskDetailViewController *detailViewController = [[taskDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    detailViewController.task = (Task *)[_taskList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
