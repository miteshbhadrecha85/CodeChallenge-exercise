//
//  CCBrowseVC.m
//  CCDropboxApp
//
//  Created by Mitesh on 14/03/15.
//  Copyright (c) 2015 Mitesh. All rights reserved.
//

#import "CCBrowseVC.h"
#import "CCContentCell.h"
#import "CCPhotoDetailVC.h"
#import "AFNetworkReachabilityManager.h"

#define PhotoDetailSegue @"ShowPhotoDetail"

@interface CCBrowseVC ()

@end

@implementation CCBrowseVC

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:PhotoDetailSegue])
    {
        CCPhotoDetailVC *photoDetailVC = (CCPhotoDetailVC *)[segue destinationViewController];
        photoDetailVC.currentMetadata = self.selectedMetadata;
        
    }
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.contentTblview addSubview:self.refreshControl];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationBackground.png"]];
    [self.refreshControl addTarget:self
                            action:@selector(refreshDropboxContent)
                  forControlEvents:UIControlEventValueChanged];
    

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"Browse Content";
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        [self refreshDropboxContent];
    }
    else
    {
        [self addBarButtonItemIsLinked:NO];
        UIAlertView *networkAlert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your internet connection and try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [networkAlert show];
    }

}
- (void)viewWillDisappear:(BOOL)animated
{
    self.title = @"";
    [super viewWillDisappear:animated];
}
#pragma mark - Bar button item

- (void)addBarButtonItemIsLinked:(BOOL)isLinked
{
    UIBarButtonItem *unlinkBtn = [[UIBarButtonItem alloc] initWithTitle:isLinked?@"Unlink":@"Link" style:UIBarButtonItemStylePlain target:self action:isLinked?@selector(unlinkAllAccount):@selector(createDBSession)];
    [self.navigationItem setRightBarButtonItem:unlinkBtn];
}

#pragma mark - Session management

- (void)createDBSession
{
    //Create a Dropbox session with App key and Secret
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:@"bzdn94jrvwnx58p"
                            appSecret:@"68tynskzpo29e04"
                            root:kDBRootAppFolder]; // either kDBRootAppFolder or kDBRootDropbox
    [DBSession setSharedSession:dbSession];
    
    [[DBSession sharedSession] linkFromController:self];
}

- (void)unlinkAllAccount
{
    [[DBSession sharedSession] unlinkAll];
    self.userAccountInfo = nil;
    [self.contentArr removeAllObjects];
    [self.contentTblview reloadData];
    [self addBarButtonItemIsLinked:NO];
    [self createDBSession];
}
#pragma mark - Refresh Content

- (void)refreshDropboxContent
{
    [self.refreshControl endRefreshing];
    
    if ([[DBSession sharedSession] isLinked])
    {
        [self addBarButtonItemIsLinked:YES];
        [self showProgressIndicator];
        //Initialize Rest client with shared session
        self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        self.restClient.delegate = self;
    
        [self.restClient loadAccountInfo];
        [self.restClient loadMetadata:@"/"];
    }
    else
    {
        [self addBarButtonItemIsLinked:NO];
        [self createDBSession];
    }
}

#pragma mark - Progress Indicator Show/hide

- (void)showProgressIndicator
{
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.labelText = @"Fetching Dropbox content";
    [self.view addSubview:progressHUD];
    [self.view bringSubviewToFront:progressHUD];
    [progressHUD show:YES];
}
- (void)hideProgressIndicator
{
//    NSLog(@"%s",__FUNCTION__);

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Dropbox Delegate

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata
{
    self.appRootMetadata = metadata;
    self.contentArr = [NSMutableArray arrayWithArray:metadata.contents];
    if (![[metadata contents] count])
    {
        [self.contentArr addObject:[NSNull null]];
    }
    [self.contentTblview reloadData];
    [self hideProgressIndicator];
}
- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError*)error
{
    NSLog(@"Error loading metadata: %@", error);
    self.contentArr = [NSMutableArray arrayWithObject:[NSNull null]];
    [self.contentTblview reloadData];
    [self hideProgressIndicator];
    
}

- (void)restClient:(DBRestClient*)client loadedAccountInfo:(DBAccountInfo*)info
{
    self.userAccountInfo = info;
    NSLog(@"Account Info: %@", info.displayName);
}
- (void)restClient:(DBRestClient*)client loadAccountInfoFailedWithError:(NSError*)error
{
    NSLog(@"Error loading Account Info: %@", error);
}

#pragma mark - Tableview Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentArr count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.userAccountInfo) {
        return 40;
    }
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%@'s Dropbox",self.userAccountInfo.displayName];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCContentCell *cell = (CCContentCell *)[self.contentTblview dequeueReusableCellWithIdentifier:@"DBContentCell"];

    if ([[self.contentArr objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
        [cell.filenameLbl setText:@"Folder is empty!"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.fileIconImgview setHidden:YES];
    }
    else
    {
        DBMetadata *currentData = [self.contentArr objectAtIndex:indexPath.row];
        [cell.filenameLbl setText:currentData.filename];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        [cell.fileIconImgview setHidden:NO];
        cell.fileIconImgview.image = [UIImage imageNamed:currentData.icon];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.filenameLbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [cell.fileIconImgview.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [cell.fileIconImgview.layer setBorderWidth:0.5f];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DBMetadata *currentData = [self.contentArr objectAtIndex:indexPath.row];
//    if (currentData.isDirectory) {
//        [self.restClient loadMetadata:[NSString stringWithFormat:@"/%@",currentData.path]];
//    }
    
    if (![[self.contentArr objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]])
    {
        self.selectedMetadata = [self.contentArr objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:PhotoDetailSegue sender:self];
    }
    
    
}

@end
