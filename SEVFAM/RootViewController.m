//
//  RootViewController.m
//  SEVFAM
//
//  Created by Admir Beciragic on 4/20/12.
//  Copyright 2012 axeltra. All rights reserved.
//

#import "RootViewController.h"
#import "Main.h"
#import "iPadMain.h"

#import "SEVFAMAppDelegate.h"
#import "Reachability.h"

@implementation RootViewController

@synthesize keyDown,username,password;

@synthesize HUD;

@synthesize requestProces, appDelegate;

- (void)viewDidLoad
{
    self.title = @"SEV Mobile FAM";
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    
    appDelegate = (SEVFAMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    requestProces = [[RequestProcessor alloc] init];
    [requestProces setDelegate:self];
    
    password.secureTextEntry = true;
	
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [keyDown setImage:[UIImage imageNamed:@"background.jpg"] forState:UIControlStateNormal];
    [keyDown setImage:[UIImage imageNamed:@"background.jpg"] forState:UIControlStateHighlighted];
    [keyDown setImage:[UIImage imageNamed:@"background.jpg"] forState:UIControlStateSelected];
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillHide:) 
												 name:UIKeyboardWillHideNotification 
											   object:nil];	
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (IBAction)textFieldDoneEditing:(id)sender{
    [username resignFirstResponder];
    [password resignFirstResponder];
}

- (IBAction)Login:(id)sender{
    [username resignFirstResponder];
    [password resignFirstResponder];
    [self showHUDWithLabel];
    Reachability *internetReach = [[Reachability reachabilityForInternetConnection] retain];
    if ([internetReach isReachable]) {
    //rezerven string - @"http://aaepd.axeltralocal/index/login/"
        [requestProces doPostRequest:@"https://w3.sev.fo/mobilefam/login.php" withParameters:[NSArray arrayWithArray:[self packLoginData]]];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@"Log In Error",nil)
                              message: [NSString stringWithFormat:@"No internet conection"]
                              delegate: self
                              cancelButtonTitle: NSLocalizedString(@"OK",nil) 
                              otherButtonTitles: nil, nil];
        [alert show];
        [alert release];
        [self hudWasHidden:HUD];
    }    

}



- (NSMutableArray *)packLoginData {
	NSMutableArray *tmp = [[NSMutableArray alloc] init];
	
	NSMutableDictionary *userIdParam = [[NSMutableDictionary alloc] init];
	[userIdParam setValue:@"username" forKey:@"key"];
	[userIdParam setValue:[@"" stringByAppendingFormat:@"%@",username.text] forKey:@"value"];
	[tmp addObject:userIdParam];
	[userIdParam release];
	userIdParam = nil;
	
	NSMutableDictionary *contactIdParam = [[NSMutableDictionary alloc] init];
	[contactIdParam setValue:@"password" forKey:@"key"];
	[contactIdParam setValue:[@"" stringByAppendingFormat:@"%@",password.text] forKey:@"value"];
	[tmp addObject:contactIdParam];
	[contactIdParam release];
	contactIdParam = nil;
    
    NSLog(@"%@",tmp);
    
	return tmp;
}


- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

-(void) keyboardWillShow:(NSNotification *)notification{
    if (!appDelegate.isIpad) {
        CGRect viewFrameHolder = self.view.frame;
        viewFrameHolder.origin.y = -35;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(growingAnimationStopped)];
        
        
        self.view.frame = viewFrameHolder;
        
        [UIView commitAnimations];
    }
}

-(void) keyboardWillHide:(NSNotification *)note{
    if (!appDelegate.isIpad) {
        CGRect viewFrameHolder = self.view.frame;
        viewFrameHolder.origin.y = 0;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(growingAnimationStopped)];
        
        self.view.frame = viewFrameHolder;
        
        [UIView commitAnimations];
    }
}

- (void)postRequestDidStart:(ASIFormDataRequest *)request {
    NSLog(@"post request started:");
}

- (void)postRequestDidFinish:(ASIFormDataRequest *)request {
	NSLog(@"post request finished: %@", [request responseString]);
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray:[requestProces processResponseByString:[request responseString]] copyItems:YES];
    if([tmp count] > 0){
        int error =[[[tmp objectAtIndex:0] objectForKey:@"error"] intValue]; 
        
        if ( error == 0){
            appDelegate.password = password.text;
            appDelegate.userData = [tmp objectAtIndex:0];
            username.text = @"";
            password.text = @"";
            //NSLog(@"%@",appDelegate.userData);
            sleep(1);
            [self hudWasHidden:HUD];
            if (appDelegate.isIpad) {
                iPadMain *vievForm = [[iPadMain alloc] initWithNibName:@"iPadMain" bundle:nil];
                [self.navigationController pushViewController:vievForm animated:YES];
                [vievForm release];
                vievForm = nil;
            }
            else{
                Main *vievForm = [[Main alloc] initWithNibName:@"Main" bundle:nil];
                [self.navigationController pushViewController:vievForm animated:YES];
                [vievForm release];
                vievForm = nil;
            }
        }
        else{
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"Log In Error",nil)
                                  message: [NSString stringWithFormat:@"%@",[[tmp objectAtIndex:0] objectForKey:@"errorMessage"]]
                                  delegate: self
                                  cancelButtonTitle: NSLocalizedString(@"OK",nil) 
                                  otherButtonTitles: nil, nil];
            [alert show];
            [alert release];
            [self hudWasHidden:HUD];
           
        }
    }
}

- (void)postRequestDidFail:(ASIFormDataRequest *)request {
	NSLog(@"Error %@", [request error]);
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: NSLocalizedString(@"Log In Error",nil)
                          message: [NSString stringWithFormat:@"Server comunication failure. Try again later"]
                          delegate: self
                          cancelButtonTitle: NSLocalizedString(@"OK",nil) 
                          otherButtonTitles: nil, nil];
    [alert show];
    [alert release];
    [self hudWasHidden:HUD];
}

- (void)requestDidStart:(ASIHTTPRequest *)request { 
	//NSLog(@"request started");
}

- (void)requestDidFinish:(ASIHTTPRequest *)request {
    //NSString *mainUrl = [NSString stringWithFormat:@"%@", [request originalURL]];
}

- (void)requestDidFail:(ASIHTTPRequest *)request { 
    NSLog(@"request failed");
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: NSLocalizedString(@"Log In Error",nil)
                          message: [NSString stringWithFormat:@"Server comunication failure. Try again later"]
                          delegate: self
                          cancelButtonTitle: NSLocalizedString(@"OK",nil) 
                          otherButtonTitles: nil, nil];
    [alert show];
    [alert release];
    [self hudWasHidden:HUD];
} 
    
- (void)dealloc
{
    [super dealloc];
}

- (void)showHUDWithLabel {
	// The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	
    // Add HUD to screen
    [self.navigationController.view addSubview:HUD];
	
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = @"Authenticating";
	
    // Show the HUD while the provided method executes in a new thread
    //[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
	[HUD show:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	//NSLog(@"Hud: %@", hud);
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
}


@end
