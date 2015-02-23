//
//  LoginController.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 10/27/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "LoginController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "User.h"
#import "School.h"
#import "Globals.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "TWTSideMenuViewController.h"
#import "TWTMenuViewController.h"
#import "TWTMainViewController.h"


@implementation LoginController

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

        _oGlobal = [[Globals alloc] init];
        NSMutableDictionary *params = [NSMutableDictionary new];
        //[params setObject:self.txtEmail.text forKey:@"email"];
        //[params setObject:self.txtPassword.text forKey:@"password"];
        [params setObject:@"kyle@akadasoftware.com" forKey:@"email"];
        [params setObject:@"akada" forKey:@"password"];
    
        
        NSMutableString *method = [[NSMutableString alloc] init];
        [method setString:@"getUser?"];
        NSURL *myURL =  [NSURL URLWithString:[_oGlobal buildURL:method fromDictionary:params]];
        
        NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
        
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSError *e = nil;
            self.user = [[User alloc] initWithDictionary:responseObject error:&e];
            //Failed to Login
            if(self.user.UserID <=0 )
            {
                NSError *loginError;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Incorrect email or password"
                                                                    message:[loginError localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
   
            }
            //Successful Login
            else
            {
                //Saved the object as an array of one item....
                [defaults rm_setCustomObject:responseObject forKey:@"SavedUser"];

                int UserID = self.user.UserID;
                if(rememberMe)
                {
                    [defaults setInteger:UserID forKey:@"UserID"];
                    
                }
                else
                {
                    [defaults setInteger:0 forKey:@"UserID"];
                    
                }

                
                NSMutableDictionary *schoolParams = [NSMutableDictionary new];
                
                //[schoolParams setObject:[NSString stringWithFormat:@"%d", self.user.SchID] forKey:@"SchID"];
                [schoolParams setObject:[NSString stringWithFormat:@"%ld", (long)self.user.SchID] forKey:@"SchID"];
                [schoolParams setObject:[NSString stringWithFormat:@"%d", UserID]  forKey:@"UserID"];
                [schoolParams setObject:self.user.UserGUID forKey:@"UserGUID"];
                
                [method setString:@"getSchool?"];

                NSURL *mySchoolURL =  [NSURL URLWithString:[_oGlobal buildURL:method fromDictionary:schoolParams]];
                
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
                    NSLog(@"%@d", self.objSchool.SName);

                
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
                
                AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
                appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                self.menuViewController = [[TWTMenuViewController alloc] initWithNibName:nil bundle:nil];
                
                self.sideMenuViewController = [[TWTSideMenuViewController alloc] initWithMenuViewController:self.menuViewController mainViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController]];
                
                self.sideMenuViewController.shadowColor = [UIColor blackColor];
                self.sideMenuViewController.edgeOffset = (UIOffset) { .horizontal = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 18.0f : 0.0f };
                self.sideMenuViewController.zoomScale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 0.5634f : 0.85f;
                self.sideMenuViewController.delegate = self;
                appDelegateTemp.window.rootViewController = self.sideMenuViewController;
                

                

            }
          
            // 3
            
           //Some sort of server error?
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: %@", error);
            
            // 4
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Service unavailable, please try again later."
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
