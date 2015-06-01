//
//  StudentInformation.m
//  DanceWorks Mobile
//
//  Created by Akada Software on 12/15/14.
//  Copyright (c) 2014 Akada Software. All rights reserved.
//

#import "StudentInformation.h"
#import "Student.h"
#import "StudentViewController.h"
#import "EditStudentInformation.h"
#import "EnrollStudentViewController.h"
#import "StudentClassesController.h"

@implementation StudentInformation


-(void) viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.delegate = self;

    CGFloat scrollViewHeight = 0.0f;
    
    for(UIView* view in _scrollView.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [_scrollView setContentSize:(CGSizeMake(screenRect.size.width, self.view.frame.size.height))];
    _scrollView.frame = self.view.frame;
    
    [self setStudentFields];
    
    
    //Two keyboard methods that scroll the view and dismiss the keyboard
    [self registerForKeyboardNotifications];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    

}

- (IBAction)editStudent:(id)sender
{
    EditStudentInformation *editController = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"EditStudentInformation"];
    editController.selectedStudent = _selectedStudent;
    editController.delegate = self;
    [[self navigationController] pushViewController:editController animated:YES];
}
- (IBAction)enrollStudent:(id)sender
{
    EnrollStudentViewController *enrollController = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"EnrollStudentViewController"];
    enrollController.selectedStudent = _selectedStudent;
    enrollController.User = _User;
    enrollController.School = _School;
    enrollController.delegate = self;
    [[self navigationController] pushViewController:enrollController animated:YES];
}

/**
 * Update the Student Information textfields
 */
-(void) setStudentFields
{
    NSString *fullName=[NSString stringWithFormat:@"%@%@%@",self.selectedStudent.FName,@" ",self.selectedStudent.LName];
    
    _txtStudentName.text = fullName;
    _txtStudentPhone.text = self.selectedStudent.Phone;
    _txtStudentAddress.text = self.selectedStudent.Address;
    _txtStudentAccountName.text = self.selectedStudent.AcctName;
    switch (self.selectedStudent.Status)
    
    {
        case 0:
            _txtStudentStatus.text = @"Active";
            break;
        case 1:
            _txtStudentStatus.text = @"Inactive";
            break;
        case 2:
            _txtStudentStatus.text = @"Prospect";
            break;
        case 3:
            _txtStudentStatus.text = @"Deleted";
            break;
        default:
            _txtStudentStatus.text = @"Error";
            break;
    }

}

-(void) addItemViewController:(EditStudentInformation *)controller didFinishEnteringItem:(Student *)editedStudent
{

    self.selectedStudent = editedStudent;
    [self setStudentFields];
}

//Dismiss keyboard on enter click
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// Call this method somewhere in your view controller setup code. Allows scrollview to move so that keyboard doesn't cover
// up text field.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight ) {
        CGSize origKeySize = kbSize;
        kbSize.height = origKeySize.width;
        kbSize.width = origKeySize.height;
    }
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 20, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
   
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}


-(BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if([viewController isKindOfClass:[ StudentClassesController class]])
    {
        StudentClassesController *studentClassesController = (StudentClassesController *) viewController;
        studentClassesController.selectedStudent = _selectedStudent;
        studentClassesController.User = _User;
        studentClassesController.School = _School;
    }
    
    return TRUE;
}

@end
