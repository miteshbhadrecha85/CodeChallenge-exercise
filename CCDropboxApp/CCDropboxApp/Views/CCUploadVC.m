//
//  CCUploadVC.m
//  CCDropboxApp
//
//  Created by Mitesh on 14/03/15.
//  Copyright (c) 2015 Mitesh. All rights reserved.
//

#import "CCUploadVC.h"
#import "AFNetworkReachabilityManager.h"

@interface CCUploadVC ()

@end

@implementation CCUploadVC

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - View Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Upload to Dropbox";
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    [self addBarButtonItemPickPhoto];
    [self.uploadProgress setProgress:0.0f];
    [self.uploadProgress setHidden:YES];
    
    [self.uploadStatus setText:@"Press + to upload image."];
//    [self uploadAFile];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Bar button item

- (void)addBarButtonItemPickPhoto
{
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pickPhoto)];
    [self.navigationItem setRightBarButtonItem:addBtn];
}

#pragma mark - Image picker method
- (void)pickPhoto
{
    if ([[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.edgesForExtendedLayout = UIRectEdgeNone;
        picker.hidesBottomBarWhenPushed = YES;
        picker.allowsEditing = NO;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *networkAlert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your internet connection and try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [networkAlert show];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    self.photoImgview.image = [info valueForKey:UIImagePickerControllerOriginalImage];
//    NSLog(@"info:%@",info);
    NSString *filename = @"Image.png";
    NSData *imgData = [[NSData alloc] initWithData:UIImagePNGRepresentation([info valueForKey:UIImagePickerControllerOriginalImage])];
    
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
//    NSLog(@"local:%@",localPath);
    [imgData writeToFile:localPath atomically:YES];
    
    // Upload file to Dropbox
    NSString *destDir = @"/";
    [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
}
#pragma mark - Other methods
- (void)uploadAFile
{
    NSString *text = @"Hello Chirag.";
        NSString *filename = @"workingchirag.txt";
//    NSString *filename = [[NSBundle mainBundle] pathForResource:@"TestImage" ofType:@"png"];
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    NSLog(@"local:%@",localPath);
    [text writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // Upload file to Dropbox
    NSString *destDir = @"/";
    [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];
}

#pragma mark - Dropbox Delegate

- (void)restClient:(DBRestClient*)client uploadProgress:(CGFloat)progress
           forFile:(NSString*)destPath from:(NSString*)srcPath
{
    [self.uploadProgress setHidden:NO];
    [self.uploadStatus setHidden:NO];
    [self.uploadProgress setProgress:progress];
    [self.uploadStatus setText:@"Image upload in progress."];
}
- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath metadata:(DBMetadata *)metadata
{
    [self.uploadProgress setHidden:YES];
    [self.uploadStatus setText:@"Image upload complete."];
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}
- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error
{
    NSLog(@"File upload failed with error: %@", error);
}

@end
