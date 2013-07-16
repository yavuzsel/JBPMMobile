//
//  taskDetailViewController.m
//  JBPMMobile
//
//  Created by yavuz on 7/11/13.
//  Copyright (c) 2013 redhat. All rights reserved.
//

#import "taskDetailViewController.h"
#include "Task.h"

@interface taskDetailViewController ()

@end

@implementation taskDetailViewController

@synthesize task = _task;

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
    NSLog(@"TASK: %@", _task);
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
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == tableView.numberOfSections-1) {
        return nil;
    }
    NSString *title;
    switch (section) {
        case 0:
            title = @"Name:";
            break;
            
        case 1:
            title = @"Status:";
            break;
            
        case 2:
            title = @"Priority:";
            break;
            
        case 3:
            title = @"Skipable:";
            break;
            
        case 4:
            title = @"Expiration Date:";
            break;

        default:
            break;
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == tableView.numberOfSections-1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.backgroundColor = [UIColor clearColor];
        UIButton *acceptButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [acceptButton setTitle:@"Accept" forState:UIControlStateNormal];
        acceptButton.frame = CGRectMake((9.0f*self.tableView.bounds.size.width)/16.0f, 5.0f, (6*self.tableView.bounds.size.width)/16.0f, self.tableView.rowHeight-10.0f);
        [acceptButton addTarget:self action:@selector(acceptTaskClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *rejectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [rejectButton setTitle:@"Reject" forState:UIControlStateNormal];
        rejectButton.frame = CGRectMake((1.0f*self.tableView.bounds.size.width)/16.0f, 5.0f, (6*self.tableView.bounds.size.width)/16.0f, self.tableView.rowHeight-10.0f);
        [rejectButton addTarget:self action:@selector(rejectTaskClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:acceptButton];
        [cell addSubview:rejectButton];
        return cell;
    }
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = _task.name;
            break;
            
        case 1:
            cell.textLabel.text = _task.status;
            break;
            
        case 2:
            cell.textLabel.text = _task.priority;
            break;
            
        case 3:
            cell.textLabel.text = _task.skipable;
            break;
            
        case 4:
            cell.textLabel.text = _task.expirationTime;
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)acceptTaskClicked:(id)sender {
    NSLog(@"Accept Task");
}

- (void)rejectTaskClicked:(id)sender {
    NSLog(@"Reject Task");
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
