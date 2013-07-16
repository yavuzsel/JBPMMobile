//
//  loginViewController.m
//  JBPMMobile
//
//  Created by yavuz on 7/11/13.
//  Copyright (c) 2013 redhat. All rights reserved.
//

#import "loginViewController.h"
#import "taskTableViewController.h"
#import "JBPMRESTClient.h"

@interface loginViewController ()

@end

@implementation loginViewController

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
    return 3;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self logout]; // !!!: this is to fix logout problem (unitl we find a proper way to logout)
    [self pingHome];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Username:";
    } else if (section == 1){
        return @"Password:";
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 2) {
        // login button cell
        cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.backgroundColor = [UIColor clearColor];
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [loginButton setTitle:@"Login" forState:UIControlStateNormal];
        loginButton.frame = CGRectMake((4.0f*self.tableView.bounds.size.width)/7.0f, 5.0f, self.tableView.bounds.size.width/3.0f, self.tableView.rowHeight-10.0f);
        [loginButton addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:loginButton];
        return cell;
    }
    
    // Configure the cell...
    UIView *fieldHolder = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 6.0f, self.tableView.bounds.size.width-30.0f, self.tableView.rowHeight-12.0f)];
    fieldHolder.backgroundColor = [UIColor clearColor];
    UITextField *editableView = [[UITextField alloc] initWithFrame:CGRectMake(15.0f, 6.0f, self.tableView.bounds.size.width-60.0f, self.tableView.rowHeight-12.0f)];
    editableView.font = [UIFont systemFontOfSize:17.0f];
    if (indexPath.section == 1) {
        editableView.secureTextEntry = YES;
    }
    editableView.tag = (10+indexPath.section);
    [fieldHolder addSubview:editableView];
    [cell addSubview:fieldHolder];
    
    return cell;
}

- (void)loginClicked:(id)sender {
    NSString *username = @"default", *password = @"default"; // in case we cannot get the username password
    for (int section = 0; section < [self.tableView numberOfSections]; section++) {
        for (int row = 0; row < [self.tableView numberOfRowsInSection:section]; row++) {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:cellPath];
            [[cell viewWithTag:(10+section)] resignFirstResponder];
            if (section == 0) {
                username = ((UITextField *)[cell viewWithTag:(10+section)]).text;
            } else if (section == 1) {
                password = ((UITextField *)[cell viewWithTag:(10+section)]).text;
            }
        }
    }
    NSLog(@"username: %@ password: %@", username, password);
    id params = @{@"j_username": username, @"j_password": password};
    [[JBPMRESTClient sharedClient]
        postPath:@"/business-central/j_security_check"
        parameters:params
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //handle succesful response from server.
            NSString *responseCookie = [[[operation response] allHeaderFields] objectForKey:@"Set-Cookie"];
            if ([responseCookie rangeOfString:@"undefined"].location == NSNotFound) {
                // login successful
                [[JBPMRESTClient sharedClient] setAuthorizationHeaderWithToken:responseCookie];
                [JBPMRESTClient sharedClient].username = username;
                taskTableViewController *tasksView = [[taskTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:tasksView animated:YES];
            } else {
                // login failed
                NSLog(@"LOGIN FAILED: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @"Login Failed!"
                                      message: @"Please check your username and/or password!"
                                      delegate: nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // handle error - login failed
            NSLog(@"LOGIN FAIL: %@", error);
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Ooops!"
                                  message: @"Something went wrong, please try again later!"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            [self logout];
        }
     ];
}

- (void)logout {
    [[JBPMRESTClient sharedClient]
         getPath:@"/business-central/org.kie.workbench.KIEWebapp/uf_logout"
         parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //handle succesful response from server.
             NSLog(@"LOGOUT SUCCESS: %d", [[operation response] statusCode]);
             NSLog(@"LOGOUT SUCCESS: %@", [[operation response] allHeaderFields]);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             // handle error - login failed
             NSLog(@"LOGOUT FAIL: %@", error);
         }
     ];
}

// !!!: this is to fix logout problem
- (void)pingHome {
    [[JBPMRESTClient sharedClient]
     getPath:@"/business-central"
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         //handle succesful response from server.
         NSLog(@"PING SUCCESS: %d", [[operation response] statusCode]);
         NSLog(@"PING SUCCESS: %@", [[operation response] allHeaderFields]);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         // handle error - login failed
         NSLog(@"PING FAIL: %@", error);
     }
     ];
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
