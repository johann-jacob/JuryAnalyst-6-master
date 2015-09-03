//
//  CaseInfo.h
//  Jury
//
//  Created by hanjinghe on 13-12-6.
//  Copyright (c) 2013年 Alioth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaseInfo : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *number;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *courthouse;

@property (nonatomic, assign) int numberOfJurors;

@property (nonatomic, assign) int rows;
@property (nonatomic, assign) int columns;

@property (nonatomic, assign) BOOL avatars;

@property (nonatomic, assign) BOOL commonVoirDire;
@property (nonatomic, assign) BOOL civil;

@end
