//
//  CPTTestAppScatterPlotController.h
//  CPTTestApp-iPhone
//
//  Created by Brad Larson on 5/11/2009.
//

#import "CorePlot-CocoaTouch.h"
#import <UIKit/UIKit.h>
#import "SEVFAMAppDelegate.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#define NUM_POINTS 400

@interface iPadCPTTestAppScatterPlotController : UIViewController<CPTPlotDataSource,MFMailComposeViewControllerDelegate>
{
    
    SEVFAMAppDelegate *appDelegate;
	CPTXYGraph *graph;
    double xxx2[NUM_POINTS];
	double xxx1[NUM_POINTS];
	double yyy1[NUM_POINTS];
	double yyy2[NUM_POINTS];
    NSMutableArray *plotData;
    IBOutlet CPTGraphHostingView *hostView;
    
    int numberOfValues;
    
    NSMutableArray *dates;
    NSMutableArray *valuesForDates;

}

@property (nonatomic, retain) SEVFAMAppDelegate *appDelegate;

@property (nonatomic, retain) NSMutableArray *dates;
@property (nonatomic, retain) NSMutableArray *valuesForDates;

- (UIImage*)captureView:(UIView *)view;
- (void)saveScreenshotToPhotosAlbum:(UIView *)view;

@end
