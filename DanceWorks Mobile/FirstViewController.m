//
//  FirstViewController.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 10/10/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "FirstViewController.h"
#import "AFNetworking.h"
#import "User.h"

@interface FirstViewController (){
    User *user;
}

- (IBAction)btnLogin:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *switchRememberMe;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation FirstViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLogin:(id)sender {
    
    BOOL rememberMe = [_switchRememberMe  isOn];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSURL *myURL = [NSURL URLWithString:@"http://app.akadasoftware.com/ws/Service1.svc/getUser?email=kyle@akadasoftware.com&password=akada"];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
  
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSError *e = nil;
        user = [[User alloc] initWithDictionary:responseObject error:&e];
        //NSLog(@"Error: %@", e);
        NSLog(@"Name: %@", user.UserName);
        int UserID = user.UserID;
        if(rememberMe)
        {
            [defaults setInteger:UserID forKey:@"UserID"];

        }
        else
        {
            [defaults setInteger:0 forKey:@"UserID"];

        }

        [self performSegueWithIdentifier:@"AccountSegue" sender:self];

   
        
        
        // 3
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];

}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}
@end
