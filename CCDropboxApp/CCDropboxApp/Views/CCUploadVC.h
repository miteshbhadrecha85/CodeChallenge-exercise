//
//  CCUploadVC.h
//  CCDropboxApp
//
//  Created by Mitesh on 14/03/15.
//  Copyright (c) 2015 Mitesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
@interface CCUploadVC : UIViewController <DBRestClientDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) DBRestClient *restClient;
@property (nonatomic, strong) IBOutlet UILabel *uploadStatus;
@property (nonatomic, strong) IBOutlet UIProgressView *uploadProgress;
@end

