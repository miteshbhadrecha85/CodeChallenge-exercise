//
//  CCBrowseVC.h
//  CCDropboxApp
//
//  Created by Mitesh on 14/03/15.
//  Copyright (c) 2015 Mitesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "MBProgressHUD.h"
@interface CCBrowseVC : UIViewController <DBRestClientDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) DBRestClient *restClient;
@property (nonatomic, strong) DBMetadata *appRootMetadata;
@property (nonatomic, strong) DBMetadata *selectedMetadata;
@property (nonatomic, strong) DBAccountInfo *userAccountInfo;
@property (nonatomic, strong) NSMutableArray *contentArr;
@property (nonatomic, strong) IBOutlet UITableView *contentTblview;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end
