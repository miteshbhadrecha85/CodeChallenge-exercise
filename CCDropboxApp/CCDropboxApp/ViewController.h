//
//  ViewController.h
//  CCDropboxApp
//
//  Created by Mitesh on 13/03/15.
//  Copyright (c) 2015 Mitesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface ViewController : UIViewController <DBRestClientDelegate>

@property (nonatomic, strong) DBRestClient *restClient;


@end

