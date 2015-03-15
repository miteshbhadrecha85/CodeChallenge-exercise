//
//  CCPhotoDetailVC.m
//  CCDropboxApp
//
//  Created by Mitesh on 14/03/15.
//  Copyright (c) 2015 Mitesh. All rights reserved.
//

#import "CCPhotoDetailVC.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
@interface CCPhotoDetailVC ()

@end

@implementation CCPhotoDetailVC

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.currentMetadata.filename;
    NSString *dropboxPath = self.currentMetadata.path;
    NSString *filename = self.currentMetadata.filename;
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    [self showProgressIndicator];
    [self.restClient loadFile:dropboxPath intoPath:localPath];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    UITabBarController *homeTabbar = (UITabBarController *)[AppDelegate sharedDelegate].window.rootViewController;
    [homeTabbar.tabBar setHidden:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    UITabBarController *homeTabbar = (UITabBarController *)[AppDelegate sharedDelegate].window.rootViewController;
    [homeTabbar.tabBar setHidden:NO];
    [super viewWillDisappear:animated];
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Progress Indicator Show/hide

- (void)showProgressIndicator
{
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.labelText = @"Fetching file content";
    [self.view addSubview:progressHUD];
    [self.view bringSubviewToFront:progressHUD];
    [progressHUD show:YES];
}
- (void)hideProgressIndicator
{
    //    NSLog(@"%s",__FUNCTION__);
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}

#pragma mark - Dropbox delegate


- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath
       contentType:(NSString *)contentType metadata:(DBMetadata *)metadata {
    NSLog(@"File loaded into path: %@", localPath);
    self.photoImgview.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:localPath]];
    [self hideProgressIndicator];
}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error {
    NSLog(@"There was an error loading the file: %@", error);
    [self hideProgressIndicator];
}

@end
