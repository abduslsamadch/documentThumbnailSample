//
//  ViewController.m
//  testThumbnails
//
//  Created by abdus on 1/21/13.
//  Copyright (c) 2013 www.abdus.me All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end
#define pageHeight 360
#define pageWidth 320
#define thumbnailHeight 88
#define thumbnailWidht 70
@implementation ViewController
@synthesize webView,thumbnailScrollView;
#pragma mark
#pragma mark VC Delegates
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Reader" ofType:@"doc"];
    NSURL *url = [NSURL fileURLWithPath:path];
    request = [NSURLRequest requestWithURL:url];
    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, pageWidth, pageHeight)];
    
    [self.webView  setScalesPageToFit:YES];
    self.webView.delegate = self;
    [self.webView  loadRequest:request];
    [self.view addSubview:self.webView ];
    
    
    self.thumbnailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, pageHeight+5, pageWidth, thumbnailHeight)];
    [self.thumbnailScrollView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:self.thumbnailScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
#pragma mark webView Delegate Methods
- (void)webViewDidFinishLoad:(UIWebView *)webView {
   //  NSLog(@"webViewDidFinishLoad");
    CGSize z =  self.webView.scrollView.contentSize;
    totalFileHeight= z.height;
    totalFileHeight=totalFileHeight/pageHeight;
    [self takeScreenShotAndReloadWebViewWithPage];
}
#pragma mark
#pragma mark utitlityMehtods 
-(void)takeScreenShotAndReloadWebViewWithPage
{
    float widthOfThumbnailForScrollView = (thumbnailWidht+5);
    float widhtOfScrollViewContant = (currentExecutingSnapshot*widthOfThumbnailForScrollView)+widthOfThumbnailForScrollView;
    self.thumbnailScrollView.contentSize = CGSizeMake(widhtOfScrollViewContant,50);
    self.webView.scrollView.contentOffset = CGPointMake(0, currentOffset);
   // [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.scrollTo(0,%f)",currentOffset]];
    
    //take Snapshot
    UIGraphicsBeginImageContext(CGSizeMake(320, pageHeight));
    [self.webView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //set frames of thumbailButton and thumnailImage
    CGRect thumbnailFrame = CGRectMake(pointToAddNextThumbnail, 0, thumbnailWidht, thumbnailHeight);
    UIButton *thumbnailButton = [[UIButton alloc] initWithFrame:thumbnailFrame];
    UIImageView *thumbnailImage =[[UIImageView alloc] initWithFrame:thumbnailFrame];
    [thumbnailImage setImage:img];
    thumbnailButton.tag = currentOffset;
    [thumbnailButton setBackgroundColor:[UIColor clearColor]];
    [thumbnailButton addTarget:self action:@selector(thumnailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.thumbnailScrollView addSubview:thumbnailImage];
    [self.thumbnailScrollView addSubview:thumbnailButton];
    [thumbnailImage release];
    [thumbnailButton release];
    
    
    
    pointToAddNextThumbnail = pointToAddNextThumbnail+thumbnailWidht+5;
    currentOffset = currentOffset + pageHeight;
    
    if (currentExecutingSnapshot < totalFileHeight)
    {
        currentExecutingSnapshot ++;
        //[self.webView  loadRequest:request];
        //make a recursive call and take snapshot of all pages
        [self takeScreenShotAndReloadWebViewWithPage];  
    }
    else
    {
        [self finishedFethingThumbnails];
    }
}
-(void)finishedFethingThumbnails
{
     self.webView.scrollView.contentOffset = CGPointMake(0, 0);
}
#pragma mark
#pragma mark IBaction
-(IBAction)thumnailButtonClicked:(UIButton*)sender
{
    [[self.webView scrollView] setZoomScale:0 animated:YES];
    [[self.webView scrollView] setContentOffset:CGPointMake(0, sender.tag) animated:YES];
}
#pragma mark
#pragma mark dealloc
-(void)dealloc
{
    [webView release];
    [thumbnailScrollView release];
    [super dealloc];
}

@end
