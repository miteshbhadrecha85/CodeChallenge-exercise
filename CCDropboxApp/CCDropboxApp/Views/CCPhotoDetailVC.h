//
//  CCPhotoDetailVC.h
//  CCDropboxApp
//
//  Created by Mitesh on 14/03/15.
//  Copyright (c) 2015 Mitesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface CCPhotoDetailVC : UIViewController <DBRestClientDelegate>

@property (nonatomic, strong) DBRestClient *restClient;
@property (nonatomic, strong) DBMetadata *currentMetadata;

@property (nonatomic, strong) IBOutlet UIImageView *photoImgview;
@property (nonatomic, strong) IBOutlet UILabel *photoNameLbl;
@end
