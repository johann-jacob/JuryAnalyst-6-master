//
//  SettingManager.m
//  JuryApp
//
//  Created by hanjinghe on 11/17/13.
//  Copyright (c) 2013 Hanjinghe. All rights reserved.
//

#import "SettingManager.h"
#import "DataManager.h"

#import "CaseInfo.h"

@implementation SettingManager

static SettingManager *_shareSettingManager;

+ (SettingManager *)shareSettingManager
{
    @synchronized(self) {
        
        if(_shareSettingManager == nil)
        {
            _shareSettingManager = [[SettingManager alloc] init];
            
            
        }
    }
    
    return _shareSettingManager;
}

+ (void)releaseSettingManager
{
    if(_shareSettingManager != nil)
    {
        _shareSettingManager = nil;
    }
}

- (id) init
{
	if ( (self = [super init]) )
	{
        //[self _init];
	}
	
	return self;
}

- (void) _init
{
    [self load];
}

- (void) save
{
    DataManager *dataManager = [DataManager shareDataManager];
    NSInteger currentSurveyIndex = dataManager.currentSurveyIndex;
    
    if(currentSurveyIndex == -1 || currentSurveyIndex >= dataManager.aryMySurveys.count)
        return;
    
    CaseInfo *survey = [dataManager.aryMySurveys objectAtIndex:currentSurveyIndex];
    NSString * surveyNumber = survey.number;
    
    // save data
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
    NSString* pathToUserOfNamePlist = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"settingdata%@.plist", surveyNumber]];
    
    NSMutableDictionary * saveData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      
                                      [NSNumber numberWithBool:self.isEXnotIN], @"isEXnotIN",
                                      [NSNumber numberWithInt:self.valueEX],    @"valueEX",
                                      [NSNumber numberWithInt:self.valueIN],    @"valueIN",
                                      
                                      [NSNumber numberWithBool:self.isYEnotCN], @"isYEnotCN",
                                      [NSNumber numberWithInt:self.valueYE],    @"valueYE",
                                      [NSNumber numberWithInt:self.valueCN],    @"valueCN",
                                      
                                      [NSNumber numberWithBool:self.isSEnotIN], @"isSEnotIN",
                                      [NSNumber numberWithInt:self.valueSE],    @"valueSE",
                                      [NSNumber numberWithInt:self.valueIN2],    @"valueIN2",
                                      
                                      [NSNumber numberWithBool:self.isTHnotFE], @"isTHnotFE",
                                      [NSNumber numberWithInt:self.valueTH],    @"valueTH",
                                      [NSNumber numberWithInt:self.valueFE],    @"valueFE",
                                      
                                      [NSNumber numberWithBool:self.isPEnotJU], @"isPEnotJU",
                                      [NSNumber numberWithInt:self.valuePE],    @"valuePE",
                                      [NSNumber numberWithInt:self.valueJU],    @"valueJU",
                                      
                                      //---------------------------------------------------
                                      
                                      [NSNumber numberWithBool:self.isGender],          @"isGender",
                                      [NSNumber numberWithInt:self.valueMale],          @"valueMale",
                                      [NSNumber numberWithInt:self.valueFemale],        @"valueFemale",
                                      
                                      [NSNumber numberWithBool:self.isEducation],       @"isEducation",
                                      [NSNumber numberWithInt:self.value9th],           @"value9th",
                                      [NSNumber numberWithInt:self.valueSchool],        @"valueSchool",
                                      [NSNumber numberWithInt:self.valueCollege],       @"valueCollege",
                                      [NSNumber numberWithInt:self.valueAssociate],     @"valueAssociate",
                                      [NSNumber numberWithInt:self.valueBachelor],      @"valueBachelor",
                                      [NSNumber numberWithInt:self.valueMaster],        @"valueMaster",
                                      [NSNumber numberWithInt:self.valueDoctorate],     @"valueDoctorate",
                                      
                                      [NSNumber numberWithBool:self.isEducation],       @"isEthnicity",
                                      [NSNumber numberWithInt:self.valueWhite],         @"valueWhite",
                                      [NSNumber numberWithInt:self.valueBlack],         @"valueBlack",
                                      [NSNumber numberWithInt:self.valueAslan],         @"valueAslan",
                                      [NSNumber numberWithInt:self.valueAmerican],      @"valueAmerican",
                                      [NSNumber numberWithInt:self.valueMultiracial],   @"valueMultiracial",
                                      [NSNumber numberWithInt:self.valueHispanic],      @"valueHispanic",
                                      
                                      [NSNumber numberWithBool:self.isPoliticalParty],  @"isPoliticalParty",
                                      [NSNumber numberWithInt:self.valueRepublican],    @"valueRepublican",
                                      [NSNumber numberWithInt:self.valueDemocrat],      @"valueDemocrat",
                                      [NSNumber numberWithInt:self.valueIndependent],   @"valueIndependent",
                                      
                                      nil];
    
    NSLog(@"%@", pathToUserOfNamePlist);
    
    BOOL success = [saveData writeToFile:pathToUserOfNamePlist atomically:NO];
    
    NSLog(@"%d", success);
}

- (void) load
{
    DataManager *dataManager = [DataManager shareDataManager];
    NSInteger currentSurveyIndex = dataManager.currentSurveyIndex;
    
    if(currentSurveyIndex == -1 || currentSurveyIndex >= dataManager.aryMySurveys.count)
        return;
    
    CaseInfo *survey = [dataManager.aryMySurveys objectAtIndex:currentSurveyIndex];
    NSString * surveyNumber = survey.number;
    
    // save data
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
    NSString* pathToUserOfNamePlist = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"settingdata%@.plist", surveyNumber]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSLog(@"%@", pathToUserOfNamePlist);
    
    if ([fileManager fileExistsAtPath:pathToUserOfNamePlist] == NO)
    {
        self.isEXnotIN = YES;
        self.valueEX = 0;
        self.valueIN = 0;
        
        self.isYEnotCN = YES;
        self.valueYE = 0;
        self.valueCN = 0;
        
        self.isSEnotIN = YES;
        self.valueSE = 0;
        self.valueIN2 = 0;
        
        self.isTHnotFE = YES;
        self.valueTH = 0;
        self.valueFE = 0;
        
        self.isPEnotJU = YES;
        self.valuePE = 0;
        self.valueJU = 0;
        
        self.isGender = NO;
        self.valueMale = 0;
        self.valueFemale = 0;
        
        self.isEducation = NO;
        self.value9th = 0;
        self.valueSchool = 0;
        self.valueCollege = 0;
        self.valueAssociate = 0;
        self.valueBachelor = 0;
        self.valueMaster = 0;
        self.valueDoctorate = 0;
        
        self.isEthnicity = NO;
        self.valueWhite = 0;
        self.valueBlack = 0;
        self.valueAslan = 0;
        self.valueAmerican = 0;
        self.valueMultiracial = 0;
        self.valueHispanic = 0;
        
        self.isPoliticalParty = NO;
        self.valueRepublican = 0;
        self.valueDemocrat = 0;
        self.valueIndependent = 0;
    }
    else
    {
        NSMutableDictionary* saveData = [[NSMutableDictionary alloc] initWithContentsOfFile:pathToUserOfNamePlist];
     
        self.isEXnotIN  = [[saveData objectForKey:@"isEXnotIN"] boolValue];
        self.valueEX = [[saveData objectForKey:@"valueEX"] intValue];
        self.valueIN = [[saveData objectForKey:@"valueIN"] intValue];
        
        self.isYEnotCN = [[saveData objectForKey:@"isYEnotCN"] boolValue];
        self.valueYE = [[saveData objectForKey:@"valueYE"] intValue];
        self.valueCN = [[saveData objectForKey:@"valueCN"] intValue];
        
        self.isSEnotIN = [[saveData objectForKey:@"isSEnotIN"] boolValue];
        self.valueSE = [[saveData objectForKey:@"valueSE"] intValue];
        self.valueIN2 = [[saveData objectForKey:@"valueIN2"] intValue];
        
        self.isTHnotFE = [[saveData objectForKey:@"isTHnotFE"] boolValue];
        self.valueTH = [[saveData objectForKey:@"valueTH"] intValue];
        self.valueFE = [[saveData objectForKey:@"valueFE"] intValue];
        
        self.isPEnotJU = [[saveData objectForKey:@"isPEnotJU"] boolValue];
        self.valuePE = [[saveData objectForKey:@"valuePE"] intValue];
        self.valueJU = [[saveData objectForKey:@"valueJU"] intValue];
        
        //---------------------------------------------------
        
        self.isGender = [[saveData objectForKey:@"isGender"] boolValue];
        self.valueMale = [[saveData objectForKey:@"valueMale"] intValue];
        self.valueFemale = [[saveData objectForKey:@"valueFemale"] intValue];
        
        self.isEducation = [[saveData objectForKey:@"isEducation"] boolValue];
        self.value9th = [[saveData objectForKey:@"value9th"] intValue];
        self.valueSchool = [[saveData objectForKey:@"valueSchool"] intValue];
        self.valueCollege = [[saveData objectForKey:@"valueCollege"] intValue];
        self.valueAssociate = [[saveData objectForKey:@"valueAssociate"] intValue];
        self.valueBachelor = [[saveData objectForKey:@"valueBachelor"] intValue];
        self.valueMaster = [[saveData objectForKey:@"valueMaster"] intValue];
        self.valueDoctorate = [[saveData objectForKey:@"valueDoctorate"] intValue];
        
        self.isEducation = [[saveData objectForKey:@"isEthnicity"] boolValue];
        self.valueWhite = [[saveData objectForKey:@"valueWhite"] intValue];
        self.valueBlack = [[saveData objectForKey:@"valueBlack"] intValue];
        self.valueAslan = [[saveData objectForKey:@"valueAslan"] intValue];
        self.valueAmerican = [[saveData objectForKey:@"valueAmerican"] intValue];
        self.valueMultiracial = [[saveData objectForKey:@"valueMultiracial"] intValue];
        self.valueHispanic = [[saveData objectForKey:@"valueHispanic"] intValue];
        
        self.isPoliticalParty = [[saveData objectForKey:@"isPoliticalParty"] boolValue];
        self.valueRepublican = [[saveData objectForKey:@"valueRepublican"] intValue];
        self.valueDemocrat = [[saveData objectForKey:@"valueDemocrat"] intValue];
        self.valueIndependent = [[saveData objectForKey:@"valueIndependent"] intValue];
    }
}

@end
