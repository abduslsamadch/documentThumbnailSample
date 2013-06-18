//
//  ViewController.h
//  testThumbnails
//
//  Created by abdus on 1/21/13.
//  Copyright (c) 2013 www.abdus.me All rights reserved.
//

#import <UIKit/UIKit.h>
#include <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController<UIWebViewDelegate>
{

BOOL finished;
    float currentOffset;
    float pointToAddNextThumbnail;
    NSURLRequest *request;
    int totalFileHeight;
    int currentExecutingSnapshot;
}
@property(nonatomic,retain) UIWebView* webView;
@property(nonatomic,retain) UIScrollView* thumbnailScrollView;
@end