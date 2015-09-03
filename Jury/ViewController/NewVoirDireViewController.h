//
//  NewVoirDireViewController.h
//  JuryAnalyst
//
//  Created by wuyinsong on 4/26/14.
//  Copyright (c) 2014 Alioth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRRequestUpload.h"
#import "BRRequestDownload.h"
#import "BRRequestListDirectory.h"

@interface NewVoirDireViewController : UIViewController
{
NSData *uploadData;
BRRequestUpload *uploadFile;
BRRequestDownload *downloadFile;
NSMutableData *downloadData;
NSString *fileName;
}
@end
