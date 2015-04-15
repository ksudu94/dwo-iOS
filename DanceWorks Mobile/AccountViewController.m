//
//  AccountViewController.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 10/15/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountInformation.h"
#import "AFNetworking.h"
#import "LoginController.h"
#import "Account.h"
#import "Globals.h"
#import "User.h"
#import "School.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "TWTSideMenuViewController.h"


@implementation AccountViewController

/**
 * _oGlobal is the same as self.oGlobal if the object is created in the header file
 **/

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(LogOut:)];
    [self.navigationController popViewControllerAnimated:YES];

    self.leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Open" style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed)];

    self.navigationItem.rightBarButtonItem = self.rightBarButton;

    self.navigationItem.leftBarButtonItem = self.leftBarButton;
    

    //A delegate allows one object to send data to another when an event happens
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.oGlobal = [[Globals alloc] init];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    
    //Objects stored as Json string dictionaries...
    NSMutableDictionary *dictUser = [defaults rm_customObjectForKey:@"SavedUser"];
    NSMutableDictionary *dictSchool = [defaults rm_customObjectForKey:@"SavedSchool"];


    NSError *e = nil;
    self.objUser = [[User alloc] initWithDictionary:dictUser error:&e];
    self.objSchool = [[School alloc] initWithDictionary:dictSchool error:&e];
     

    /*
     *User Parameters
    */
    
    NSMutableDictionary *userParams = [NSMutableDictionary new];
    
    [userParams setObject:[NSString stringWithFormat:@"%d", self.objUser.UserID]  forKey:@"UserID"];
    [userParams setObject:self.objUser.UserGUID forKey:@"UserGUID"];

    NSMutableString *userMethod = [[NSMutableString alloc] init];
    [userMethod setString:@"getUserByID?"];
    
    NSURL *userURL =  [NSURL URLWithString:[self.oGlobal buildURL:userMethod fromDictionary:userParams]];
    
    NSURLRequest *userRequest = [NSURLRequest requestWithURL:userURL];

    
    /*
     *User Operation Start
     */
    
    AFHTTPRequestOperation *userOperation = [[AFHTTPRequestOperation alloc] initWithRequest:userRequest];
    userOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [userOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *userOper, id userResponseObject) {
        
        
        // 3
        NSError *e = nil;
        self.objUser = [[User alloc] initWithDictionary:userResponseObject error:&e];
        if(self.objUser.UserID > 0)
        {
            //Successfully reloaded User Object            
            [defaults rm_setCustomObject:userResponseObject forKey:@"SavedUsers"];
            
            /*
             *Account Parameters
             */
            
            NSMutableDictionary *accountParams = [NSMutableDictionary new];
            
            [accountParams setObject:@"%20" forKey:@"Order"];
            [accountParams setObject:[NSString stringWithFormat:@"%d", self.objUser.UserID]  forKey:@"UserID"];
            [accountParams setObject:[NSString stringWithFormat:@"%d", self.objUser.SchID]  forKey:@"SchID"];
            [accountParams setObject:self.objUser.UserGUID forKey:@"UserGUID"];
            
            NSMutableString *accountMethod = [[NSMutableString alloc] init];
            [accountMethod setString:@"getAccountsJS?"];
            
            NSURL *accountURL =  [NSURL URLWithString:[self.oGlobal buildURL:accountMethod fromDictionary:accountParams]];
            NSURLRequest *accountRequest = [NSURLRequest requestWithURL:accountURL];

            AFHTTPRequestOperation *accountOperation = [[AFHTTPRequestOperation alloc] initWithRequest:accountRequest];
            
            accountOperation.responseSerializer = [AFJSONResponseSerializer serializer];
            
            
            [accountOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *accountOperation, id accountResponseObject) {
                
                
                // 3
                self.accountsDictionary = accountResponseObject;
                [self saveAccounts];
                [self.tableView reloadData];
                [defaults rm_setCustomObject:accountResponseObject forKey:@"SavedAccounts"];
                
                
                
                
            } failure:^(AFHTTPRequestOperation *accountOperation, NSError *error) {
                
                NSLog(@"Error: %@", error);
                
                // 4
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Accounts"
                                                                    message:[error localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
            }];
            
            [accountOperation start];

            /*
             *School Parameters
             */
            NSMutableDictionary *schoolParams = [NSMutableDictionary new];
            
            [schoolParams setObject:[NSString stringWithFormat:@"%d", self.objUser.SchID] forKey:@"SchID"];
            [schoolParams setObject:[NSString stringWithFormat:@"%d", self.objUser.UserID]  forKey:@"UserID"];
            [schoolParams setObject:self.objUser.UserGUID forKey:@"UserGUID"];
            
            NSMutableString *schoolMethod = [[NSMutableString alloc] init];
            [schoolMethod setString:@"getSchool?"];
            
            NSURL *mySchoolURL =  [NSURL URLWithString:[self.oGlobal buildURL:schoolMethod fromDictionary:schoolParams]];
            
            NSURLRequest *mySchoolRequest = [NSURLRequest requestWithURL:mySchoolURL];
            
            
            
            AFHTTPRequestOperation *getSchool = [[AFHTTPRequestOperation alloc] initWithRequest:mySchoolRequest];
            getSchool.responseSerializer = [AFJSONResponseSerializer serializer];
            
            
            [getSchool setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *getSchool, id schoolResponseObject) {
                
                NSError *e = nil;
                self.objSchool = [[School alloc] initWithDictionary:schoolResponseObject error:&e];
                if(self.objSchool.SchID > 0 )
                {
                    //Saved the object as an array of one item....
                    [defaults rm_setCustomObject:schoolResponseObject forKey:@"SavedSchool"];
                    
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"Error: %@", error);
                
                // 4
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error retrieving School, please try again later."
                                                                    message:[error localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
            }];
            
            [getSchool start];

            
        } else {
            NSLog(@"UserID is less than 0... Error");

        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving User, please try again later."
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [userOperation start];

}


- (void)openButtonPressed
{
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}


- (void) LogOut: (id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"UserID"];
    [defaults synchronize];
    //[defaults setInteger:UserID forKey:@"UserID"];
    //[self performSegueWithIdentifier:@"LogoutSegue" sender:self];
    UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginController"];
    [[UIApplication sharedApplication].keyWindow setRootViewController:rootController];
    NSLog( @"Button clicked." );
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.accountsObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *id = @"AccountCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    
    Account *newAccount = [_accountsObjects objectAtIndex: indexPath.row];
    [_dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
    NSString *fullName=[NSString stringWithFormat:@"%@%@%@",newAccount.FName,@" ",newAccount.LName];

    cell.textLabel.text = fullName;
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountInformation *accountInformation = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"AccountInformation"];
    accountInformation.selectedAccount = [_accountsObjects objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:accountInformation animated:NO];
    

}
*/

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.accountTabBarController = (UITabBarController*) [segue destinationViewController];
    NSIndexPath *selectedIndex = [self.tableView indexPathForSelectedRow];
    self.accountInformationController = [self.accountTabBarController.viewControllers objectAtIndex: 0];
    self.accountInformationController.selectedAccount = [_accountsObjects objectAtIndex:selectedIndex.row];
    
}
-(void) saveAccounts {
    //triggered when all data is loaded
    NSError *e = nil;
    _accountsObjects = [[NSMutableArray alloc] init];
    if (e){
        NSLog(@"JSONObjectWithData error: %@", e);
    } else {
        for (NSDictionary *dictionary in self.accountsDictionary)
        {
            //Create account for every response
            self.objAccount = [[Account alloc] initWithDictionary:dictionary error:&e];
            //NSLog(self.objAccount.FName);
            
            //The DateReg value needs to be converted to readable format so that when you save it. It's not nill
            self.objAccount.DateReg = [_oGlobal getDateFromJSON:[dictionary objectForKey:@"DateReg"]];
           
            [_accountsObjects addObject:self.objAccount];

            
            
        }
    }
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
