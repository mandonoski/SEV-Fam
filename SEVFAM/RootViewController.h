//
//  RootViewController.h
//  SEVFAM
//
//  Created by Admir Beciragic on 4/20/12.
//  Copyright 2012 axeltra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestProcessor.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "SEVFAMAppDelegate.h"

@interface RootViewController : UIViewController<MBProgressHUDDelegate, ASIHTTPRequestDelegate>{
    
    IBOutlet UIButton *keyDown;
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    
    RequestProcessor *requestProces;
    MBProgressHUD *HUD;
    SEVFAMAppDelegate *appDelegate;
    
}

@property (nonatomic, retain) IBOutlet UIButton *keyDown;
@property (nonatomic, retain) IBOutlet UITextField *username;
@property (nonatomic, retain) IBOutlet UITextField *password;

@property (nonatomic, retain) RequestProcessor *requestProces;
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, retain) SEVFAMAppDelegate *appDelegate;

- (NSMutableArray *)packLoginData;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)Login:(id)sender;

- (void)showHUDWithLabel;

@end
