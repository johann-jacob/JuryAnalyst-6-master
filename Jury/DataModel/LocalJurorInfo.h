//
//  LocalJurorInfo.h
//  Jury
//
//  Created by hanjinghe on 13-12-6.
//  Copyright (c) 2013年 Alioth. All rights reserved.
//

#import <Foundation/Foundation.h>

enum JUROR_ACTIOM {
    JA_ACCEPT,
    JA_CONSIDER,
    JA_DECLINE,
    JA_NEUTRAL,
    JA_STRIKE,
    JA_UNSTRIKE,
};

@interface LocalJurorInfo : NSObject

@property (nonatomic, retain) NSString *tid;
@property (nonatomic, retain) NSString *personality;
@property (nonatomic, retain) NSString *token;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *overide;

@property (nonatomic, retain) NSString *email;

@property (nonatomic, retain) NSString *occupation;

@property (nonatomic, assign) int gender;

@property (nonatomic, assign) int age;
@property (nonatomic, assign) int rating;

@property (nonatomic, assign) int ethnicity;

@property (nonatomic, retain) NSString *symbol;

@property (nonatomic, retain) NSString *education;
@property (nonatomic, retain) NSString *politicalParty;

@property (nonatomic, retain) NSString *note;

@property (nonatomic, assign) int preperemptory;
@property (nonatomic, assign) int defence;
@property (nonatomic, assign) int cause;
@property (nonatomic, assign) int newVers;

@property (nonatomic, assign) int avatarIndex;

@property (nonatomic, assign) int actionIndex;

- (id) initWithJuror:(LocalJurorInfo *)juror;


@end
