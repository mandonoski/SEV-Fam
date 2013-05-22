//
//  RequestProcessor.h
//  TestSQL
//
//  Created by Admir Beciragic on 2/20/12.
//  Copyright (c) 2012 Axeltra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASIHTTPRequest;
@class ASIFormDataRequest;

@protocol SEVFAMAppDelegate
@optional
- (void)requestDidStart:(ASIHTTPRequest *)request;
- (void)requestDidFinish:(ASIHTTPRequest *)request;
- (void)requestDidFail:(ASIHTTPRequest *)request;

- (void)postRequestDidStart:(ASIFormDataRequest *)request;
- (void)postRequestDidFinish:(ASIFormDataRequest *)request;
- (void)postRequestDidFail:(ASIFormDataRequest *)request;
@end

@interface RequestProcessor : NSObject{
	NSMutableArray *requestsInProgress;
	NSObject <SEVFAMAppDelegate> *delegate;
}

@property (retain, nonatomic) NSMutableArray *requestsInProgress;
@property (retain, nonatomic) NSObject <SEVFAMAppDelegate> *delegate;

- (void)doRequest:(NSString *)url;

- (void)doPostRequest:(NSString *)urlString withParameters:(NSArray *)params;

- (NSMutableArray *)processResponseByString:(NSString *)theResponse;

@end
