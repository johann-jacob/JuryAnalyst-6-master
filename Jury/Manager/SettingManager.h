//
//  SettingManager.h
//  JuryApp
//
//  Created by hanjinghe on 11/17/13.
//  Copyright (c) 2013 Hanjinghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SettingManager : NSObject
{
    
}

+ (SettingManager *)shareSettingManager;
+ (void)releaseSettingManager;

@property (nonatomic, assign) BOOL isEXnotIN;
@property (nonatomic, assign) NSInteger valueEX;
@property (nonatomic, assign) NSInteger valueIN;

@property (nonatomic, assign) BOOL isYEnotCN;
@property (nonatomic, assign) NSInteger valueYE;
@property (nonatomic, assign) NSInteger valueCN;

@property (nonatomic, assign) BOOL isSEnotIN;
@property (nonatomic, assign) NSInteger valueSE;
@property (nonatomic, assign) NSInteger valueIN2;

@property (nonatomic, assign) BOOL isTHnotFE;
@property (nonatomic, assign) NSInteger valueTH;
@property (nonatomic, assign) NSInteger valueFE;

@property (nonatomic, assign) BOOL isPEnotJU;
@property (nonatomic, assign) NSInteger valuePE;
@property (nonatomic, assign) NSInteger valueJU;

@property (nonatomic, assign) BOOL isGender;
@property (nonatomic, assign) NSInteger valueMale;
@property (nonatomic, assign) NSInteger valueFemale;

@property (nonatomic, assign) BOOL isEducation;
@property (nonatomic, assign) NSInteger value9th;
@property (nonatomic, assign) NSInteger valueSchool;
@property (nonatomic, assign) NSInteger valueCollege;
@property (nonatomic, assign) NSInteger valueAssociate;
@property (nonatomic, assign) NSInteger valueBachelor;
@property (nonatomic, assign) NSInteger valueMaster;
@property (nonatomic, assign) NSInteger valueDoctorate;

@property (nonatomic, assign) BOOL isEthnicity;
@property (nonatomic, assign) NSInteger valueWhite;
@property (nonatomic, assign) NSInteger valueBlack;
@property (nonatomic, assign) NSInteger valueAslan;
@property (nonatomic, assign) NSInteger valueAmerican;
@property (nonatomic, assign) NSInteger valueMultiracial;
@property (nonatomic, assign) NSInteger valueHispanic;

@property (nonatomic, assign) BOOL isPoliticalParty;
@property (nonatomic, assign) NSInteger valueRepublican;
@property (nonatomic, assign) NSInteger valueDemocrat;
@property (nonatomic, assign) NSInteger valueIndependent;

- (void) save;
- (void) load;

@end
