//
//  DataManager.m
//  JuryApp
//
//  Created by hanjinghe on 11/17/13.
//  Copyright (c) 2013 Hanjinghe. All rights reserved.
//

#import "DataManager.h"

#import "CaseInfo.h"
#import "GroupInfo.h"
#import "QuestionInfo.h"

#import "LocalJurorInfo.h"

#import "SettingManager.h"

@implementation DataManager

#define _STR_DATA_FILE_ @"datas.plist"

#define _STR_SURVEY_DATA_FILE_ @"survey%@.plist"

static DataManager *_shareDataManager;

+ (DataManager *)shareDataManager
{
    @synchronized(self) {
        
        if(_shareDataManager == nil)
        {
            _shareDataManager = [[DataManager alloc] init];
            
            
        }
    }
    
    return _shareDataManager;
}

+ (void)releaseDataManager
{
    if(_shareDataManager != nil)
    {
        _shareDataManager = nil;
    }
}

- (id) init
{
	if ( (self = [super init]) )
	{
        [self _init];
	}
	
	return self;
}

- (void) _init
{
    self.currentSurveyIndex = -1;
    
    self.showWithoutStrike = YES;
    
    //self.showWithPreemptStrike = NO;
    //self.showWithHardStrike = NO;
    //self.showWithCauseStrike = NO;
    
    self.sortOption = SORT_LOCATION;
    
    self.aryEthnicity = [[NSMutableArray alloc] initWithObjects:@"White", @"Black", @"Asian or Pacific Islander", @"American Indian or Alaskan Native", @"Multiracial", @"Hispanic", @"N/A", nil];
    
    self.aryEducations = [[NSMutableArray alloc] initWithObjects:@"9th Grade", @"High school graduate", @"Some college", @"Associate's and/or Bachelor's degree", @"Bachelor's degree", @"Master's degree", @"Doctorate or professional degree", @"N/A", nil];
    
    self.aryPolicityPartys = [[NSMutableArray alloc] initWithObjects:@"N/A", @"Democrat", @"Republican", @"Independent", nil];
    
    self.aryQuestionOptions = [[NSMutableArray alloc] initWithObjects:@"None", @"Hardship", @"Cause", @"Frivolous Suits", nil];
    
    [self initPersonalityProfile];
    
    if(self.caseInfo == nil)
    {
        self.caseInfo = [[CaseInfo alloc] init];
    }
    
    if(self.dicQuestionType == nil)
    {
        self.dicQuestionType = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @"Array dual scale",                @"1",
                                @"5 Point Choice",                  @"5",
                                @"Array (5 Point Choice)",          @"A",
                                @"Array (10 Point Choice)",         @"B",
                                @"Array (Yes/No/Uncertain)",        @"C",
                                @"Date/Time",                       @"D",
                                @"Array (Increase/Same/Decrease)",  @"E",
                                @"Array",                           @"F",
                                @"Gender",                          @"G",
                                @"Array by column",                 @"H",
                                @"Language Switch",                 @"I",
                                @"Multiple Numerical Input",        @"K",
                                @"List (Radio)",                    @"L",
                                @"Multiple choice",                 @"M",
                                @"Numerical Input",                 @"N",
                                @"List with comment",               @"O",
                                @"Multiple choice with comments",   @"P",
                                @"Multiple Short Text",             @"Q",
                                @"Ranking",                         @"R",
                                @"Short Free Text",                 @"S",
                                @"Long Free Text",                  @"T",
                                @"Huge Free Text",                  @"U",
                                @"Text display",                    @"X",
                                @"Yes/No",                          @"Y",
                                @"List (Dropdown)",                 @"Z",
                                @"Array (Numbers)",                 @":",
                                @"Array (Texts)",                   @";",
                                @"File upload",                     @"|",
                                @"Equation",                        @"*",
                                nil];
    }
    
    [self load];
}

- (void) initPersonalityProfile
{
    if(self.aryPersonalityProfileData == nil)
    {
        self.aryPersonalityProfileData = [[NSMutableArray alloc] init];
    }
    
    [self.aryPersonalityProfileData removeAllObjects];
    
    NSArray *aryGroup1 = @[@{@"Are you" : @[@{@"easy to get to know?" : @"EX"},
                                            @{@"hard to get to know?" : @"IN"}, @{@"N/A" : @"NA"}]},
                           @{@"Would people consider you more" : @[@{@"talkative" : @"EX"},
                                                                   @{@"reserved" : @"IN"}, @{@"N/A" : @"NA"}]},
                           @{@"When you are with a group of people, would you rather" : @[@{@"join in the talk of the group" : @"EX"},
                                                                                          @{@"talk one-on-one with people you know well" : @"IN"}, @{@"N/A" : @"NA"}]},
                           @{@"Would you consider yourself to be" : @[@{@"social" : @"EX"},
                                                                                          @{@"private" : @"IN"}, @{@"N/A" : @"NA"}]},
                           ];
    
    NSArray *aryGroup2 = @[@{@"I do a lot for others, but little is done for me" : @[@{@"True" : @"YE"},
                                                                                     @{@"False" : @"CN"}, @{@"N/A" : @"NA"}]},
                                @{@"I can persuade almost anyone to switch to my side of an argument" : @[@{@"True" : @"CN"},
                                                                                                          @{@"False" : @"YE"}, @{@"N/A" : @"NA"}]},
                                @{@"I do not hesitate to direct people what I think is best for them" : @[@{@"True" : @"CN"},
                                                                                                           @{@"False" : @"YE"}, @{@"N/A" : @"NA"}]},
                                ];
    
    NSArray *aryGroup3 = @[@{@"I decide my priorities and take firm action to achieve them" : @[@{@"True" : @"MO"},
                                                                        @{@"False" : @"AC"}, @{@"N/A" : @"NA"}]},
                           @{@"I wait for events to take their course before deciding what to do" : @[@{@"True" : @"AC"},
                                                                                                @{@"False" : @"MO"}, @{@"N/A" : @"NA"}]},
                           @{@"I see to it that things come out the way I want them to" : @[@{@"True" : @"MO"},
                                                                                                @{@"False" : @"AC"}, @{@"N/A" : @"NA"}]},
                                ];
    
    NSArray *aryGroup4 = @[@{@"I believe in complaining if I receive bad service at a restaurant" : @[@{@"True" : @"LR"},
                                                                     @{@"false" : @"AQ"}, @{@"N/A" : @"NA"}]},
                                @{@"If I notice that another persons line of reasoning is wrong, I usually" : @[@{@"point it out" : @"LR"},
                                                                              @{@"let it pass" : @"AQ"}, @{@"N/A" : @"NA"}]},
                                @{@"When people do something that bothers me, I usually" : @[@{@"mention it to them" : @"LR"},
                                                                            @{@"let it go" : @"AQ"}, @{@"N/A" : @"NA"}]},
                           @{@"If we were lost in a city and my friends did not agree with me on the best way to go, I would" : @[@{@"let them know that I thought my way was best" : @"LR"}, @{@"follow them" : @"AQ"}, @{@"N/A" : @"NA"}]},
                                ];
    
    NSArray *aryGroup5 = @[@{@"Friends and family turn to me for warmth and support" : @[@{@"True" : @"NR"},
                                                              @{@"False" : @"ID"}, @{@"N/A" : @"NA"}]},
                                @{@"I dislike relying on others at work" : @[@{@"True" : @"ID"}, @{@"False" : @"NR"}, @{@"N/A" : @"NA"}]},
                                @{@"What should be done about homeless first" : @[@{@"Find them work" : @"ID"},
                                                          @{@"Find them a place to live" : @"NR"}, @{@"N/A" : @"NA"}]},
                           @{@"I prefer to make decisions on my own, with little or no advice from others" : @[@{@"True" : @"ID"},
                                                     @{@"False" : @"NR"}, @{@"N/A" : @"NA"}]},
                                ];
    
    [self.aryPersonalityProfileData addObject:aryGroup1];
    [self.aryPersonalityProfileData addObject:aryGroup2];
    [self.aryPersonalityProfileData addObject:aryGroup3];
    [self.aryPersonalityProfileData addObject:aryGroup4];
    [self.aryPersonalityProfileData addObject:aryGroup5];
    
}

- (void) load
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
    NSString* pathToUserOfNamePlist = [documentsDirectory stringByAppendingPathComponent:_STR_DATA_FILE_];
    
    NSLog(@"%@", pathToUserOfNamePlist);
    
    if ([fileManager fileExistsAtPath:pathToUserOfNamePlist] == NO)
    {
        if(self.aryMySurveys == nil)
        {
            self.aryMySurveys = [[NSMutableArray alloc] init];
        }
    }
    else
    {
        NSMutableDictionary* saveData = [[NSMutableDictionary alloc] initWithContentsOfFile:pathToUserOfNamePlist];
        
        if(self.aryMySurveys == nil)
        {
            self.aryMySurveys = [[NSMutableArray alloc] init];
        }
        
        NSMutableArray *aryCaseInfos = [saveData objectForKey:@"mysurveys"];
        for (NSDictionary *dicCaseInfo in aryCaseInfos)
        {
            CaseInfo *caseInfo = [[CaseInfo alloc] init];
            
            caseInfo.name = [dicCaseInfo objectForKey:@"case_name"];
            caseInfo.number = [dicCaseInfo objectForKey:@"case_number"];
            caseInfo.location = [dicCaseInfo objectForKey:@"case_location"];
            caseInfo.rows = [[dicCaseInfo objectForKey:@"case_rows"] intValue];
            caseInfo.columns = [[dicCaseInfo objectForKey:@"case_columns"] intValue];
            caseInfo.numberOfJurors = [[dicCaseInfo objectForKey:@"case_jurors"] intValue];
            
            [self.aryMySurveys addObject:caseInfo];
        }
    }
    
    [self loadSurveyData];
}

- (void) save
{
    // save data
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
    NSString* pathToUserOfNamePlist = [documentsDirectory stringByAppendingPathComponent:_STR_DATA_FILE_];
    
    NSMutableArray *aryCaseInfos = [[NSMutableArray alloc] init];
    for (CaseInfo *caseInfo in self.aryMySurveys)
    {
        NSDictionary *dicCaseInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                     caseInfo.name,             @"case_name",
                                     caseInfo.number,           @"case_number",
                                     caseInfo.location,         @"case_location",
                                     [NSNumber numberWithInt:caseInfo.rows],   @"case_rows",
                                     [NSNumber numberWithInt:caseInfo.columns],   @"case_columns",
                                     [NSNumber numberWithInt:caseInfo.numberOfJurors],   @"case_jurors",
                                     nil];
        
        [aryCaseInfos addObject:dicCaseInfo];
    }
    
    NSMutableDictionary * saveData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      aryCaseInfos,     @"mysurveys",
                                      nil];
    
    NSLog(@"%@", saveData);
    
    [saveData writeToFile:pathToUserOfNamePlist atomically:YES];
    
    [self saveSurveyData];
}

- (void) loadSurveyData
{
    if(self.currentSurveyIndex == -1 || self.currentSurveyIndex >= self.aryMySurveys.count)
        return;
    
    CaseInfo *survey = [self.aryMySurveys objectAtIndex:self.currentSurveyIndex];
    NSString * surveyNumber = survey.number;
    
    // save data
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
    NSString* pathToUserOfNamePlist = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:_STR_SURVEY_DATA_FILE_, surveyNumber]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSLog(@"%@", pathToUserOfNamePlist);
    
    if ([fileManager fileExistsAtPath:pathToUserOfNamePlist] == NO)
    {
        if(self.aryPoints == nil)
        {
            self.aryPoints = [[NSMutableArray alloc] init];
            
            for (int n = 0 ; n < 1000; n ++) {
                [self.aryPoints addObject:@""];
            }
        }
        
        if(self.aryGroups == nil)
        {
            self.aryGroups = [[NSMutableArray alloc] init];
        }
        else
        {
            [self.aryGroups removeAllObjects];
        }
        
        if(self.aryLocalQuestions == nil)
        {
            self.aryLocalQuestions = [[NSMutableArray alloc] init];
        }
        else
        {
            [self.aryLocalQuestions removeAllObjects];
        }
        
        if(self.arySelectedJurors == nil)
        {
            self.arySelectedJurors = [[NSMutableArray alloc] init];
        }
        else
        {
            [self.arySelectedJurors removeAllObjects];
        }
        
        if(self.aryLocalJurors == nil)
        {
            self.aryLocalJurors = [[NSMutableArray alloc] init];
        }
        else
        {
            [self.aryLocalJurors removeAllObjects];
        }
        
        if(self.aryJurorPersonalityProfileDatas == nil)
        {
            self.aryJurorPersonalityProfileDatas = [[NSMutableArray alloc] init];
        }
        else
        {
            [self.aryJurorPersonalityProfileDatas removeAllObjects];
        }
        
        self.dicResponse = [[NSMutableDictionary alloc] init];
    }
    else
    {
        NSMutableDictionary* saveData = [[NSMutableDictionary alloc] initWithContentsOfFile:pathToUserOfNamePlist];
        
        self.aryPoints = [[NSMutableArray alloc] initWithArray:[saveData objectForKey:@"point"] copyItems:YES];
        
        [self.aryLocalJurors removeAllObjects];
        
        NSMutableArray *aryJurorInfos = [saveData objectForKey:@"jurors"];
        
        if(self.aryLocalJurors == nil)
        {
            self.aryLocalJurors = [[NSMutableArray alloc] init];
        }
        else
        {
            [self.aryLocalJurors removeAllObjects];
        }
        
        for (NSDictionary *dicJurorInfo in aryJurorInfos)
        {
            LocalJurorInfo *jurorInfo = [[LocalJurorInfo alloc] init];
            
            jurorInfo.tid = [dicJurorInfo objectForKey:@"juror_id"],
            jurorInfo.personality = [dicJurorInfo objectForKey:@"juror_personality"],
            jurorInfo.name = [dicJurorInfo objectForKey:@"juror_name"],
            jurorInfo.age = [[dicJurorInfo objectForKey:@"juror_age"] intValue],
            jurorInfo.rating = [[dicJurorInfo objectForKey:@"juror_rate"] intValue],
            jurorInfo.symbol = [dicJurorInfo objectForKey:@"juror_symbol"],
            jurorInfo.education = [dicJurorInfo objectForKey:@"juror_education"],
            jurorInfo.politicalParty = [dicJurorInfo objectForKey:@"juror_politicalparty"],
            jurorInfo.occupation = [dicJurorInfo objectForKey:@"juror_occupation"],
            jurorInfo.note = [dicJurorInfo objectForKey:@"juror_note"],
            jurorInfo.preperemptory = [[dicJurorInfo objectForKey:@"juror_preperemptory"] intValue];
            jurorInfo.defence = [[dicJurorInfo objectForKey:@"juror_defence"] intValue];
            jurorInfo.cause = [[dicJurorInfo objectForKey:@"juror_cause"] intValue];
            jurorInfo.avatarIndex = [[dicJurorInfo objectForKey:@"juror_avatar"] intValue];
            jurorInfo.actionIndex = [[dicJurorInfo objectForKey:@"juror_action"] intValue];
            jurorInfo.overide = [dicJurorInfo objectForKey:@"juror_overide"];
            
            //jurorInfo.gender = [[dicJurorInfo objectForKey:@"gender"] intValue];
            //jurorInfo.ethnicity = [[dicJurorInfo objectForKey:@"ethnicity"] intValue];
            
            jurorInfo.gender = jurorInfo.avatarIndex / 10;
            jurorInfo.ethnicity = jurorInfo.avatarIndex%10;
            
            [self.aryLocalJurors addObject:jurorInfo];
        }
        
        if(self.arySelectedJurors == nil)
        {
            self.arySelectedJurors = [[NSMutableArray alloc] init];
        }
        else
        {
            [self.arySelectedJurors removeAllObjects];
        }
        
        NSMutableArray *arySelectedJurors = [saveData objectForKey:@"selectedJurors"];
        
        for (NSDictionary *dicJurorInfo in arySelectedJurors)
        {
            LocalJurorInfo *jurorInfo = [[LocalJurorInfo alloc] init];
            
            jurorInfo.tid = [dicJurorInfo objectForKey:@"juror_id"],
            jurorInfo.personality = [dicJurorInfo objectForKey:@"juror_personality"],
            jurorInfo.name = [dicJurorInfo objectForKey:@"juror_name"],
            jurorInfo.age = [[dicJurorInfo objectForKey:@"juror_age"] intValue],
            jurorInfo.rating = [[dicJurorInfo objectForKey:@"juror_rate"] intValue],
            jurorInfo.symbol = [dicJurorInfo objectForKey:@"juror_symbol"],
            jurorInfo.education = [dicJurorInfo objectForKey:@"juror_education"],
            jurorInfo.politicalParty = [dicJurorInfo objectForKey:@"juror_politicalparty"],
            jurorInfo.occupation = [dicJurorInfo objectForKey:@"juror_occupation"],
            jurorInfo.note = [dicJurorInfo objectForKey:@"juror_note"],
            jurorInfo.preperemptory = [[dicJurorInfo objectForKey:@"juror_preperemptory"] intValue];
            jurorInfo.defence = [[dicJurorInfo objectForKey:@"juror_defence"] intValue];
            jurorInfo.cause = [[dicJurorInfo objectForKey:@"juror_cause"] intValue];
            jurorInfo.avatarIndex = [[dicJurorInfo objectForKey:@"juror_avatar"] intValue];
            jurorInfo.actionIndex = [[dicJurorInfo objectForKey:@"juror_action"] intValue];
            jurorInfo.overide = [dicJurorInfo objectForKey:@"juror_overide"];
            
            //jurorInfo.gender = [[dicJurorInfo objectForKey:@"gender"] intValue];
            //jurorInfo.ethnicity = [[dicJurorInfo objectForKey:@"ethnicity"] intValue];
            
            jurorInfo.gender = jurorInfo.avatarIndex / 10;
            jurorInfo.ethnicity = jurorInfo.avatarIndex%10;
            
            [self.arySelectedJurors addObject:jurorInfo];
        }
        
        if(self.aryLocalQuestions == nil)
        {
            self.aryLocalQuestions = [[NSMutableArray alloc] init];
        }
        else
        {
            [self.aryLocalQuestions removeAllObjects];
        }
        
        NSMutableArray *aryLocalQuestions = [saveData objectForKey:@"localquestions"];
        for (NSDictionary *dicLocalQuestion in aryLocalQuestions)
        {
            QuestionInfo *questionInfo = [[QuestionInfo alloc] init];
            
            questionInfo.qid = [[dicLocalQuestion objectForKey:@"question_id"] integerValue];
            questionInfo.groupId = [[dicLocalQuestion objectForKey:@"question_group"] integerValue];
            questionInfo.answer = [dicLocalQuestion objectForKey:@"question_answer"];
            questionInfo.question = [dicLocalQuestion objectForKey:@"question_qustion"];
            questionInfo.sumQuestion = [dicLocalQuestion objectForKeyedSubscript:@"question_sum"];
            questionInfo.title = [dicLocalQuestion objectForKey:@"question_title"];
            questionInfo.symbol = [dicLocalQuestion objectForKey:@"question_symbol"];
            
            questionInfo.responsePositive = [[dicLocalQuestion objectForKey:@"question_pos"] intValue];
            questionInfo.responseNagative = [[dicLocalQuestion objectForKey:@"question_nag"] intValue];
            
            questionInfo.style = [[dicLocalQuestion objectForKey:@"question_style"] intValue];
            questionInfo.weight = [[dicLocalQuestion objectForKey:@"question_weight"] intValue];
            
            [self.aryLocalQuestions addObject:questionInfo];
        }
        
        if(self.aryGroups == nil)
        {
            self.aryGroups = [[NSMutableArray alloc] init];
        }
        else
        {
            [self.aryGroups removeAllObjects];
        }
        
        NSMutableArray *aryGroups = [saveData objectForKey:@"groups"];
        for (NSDictionary *dicLocalGroup in aryGroups)
        {
            GroupInfo *groupInfo = [[GroupInfo alloc] init];
            
            groupInfo.groupId = [[dicLocalGroup objectForKey:@"group_id"] integerValue];
            groupInfo.groupTitle = [dicLocalGroup objectForKey:@"group_title"];
            groupInfo.groupDesciption = [dicLocalGroup objectForKey:@"group_description"];
            
            [self.aryGroups addObject:groupInfo];
        }
        
        self.aryJurorPersonalityProfileDatas = [[NSMutableArray alloc] initWithArray:[saveData objectForKey:@"personalityprofile"] copyItems:YES];
        
        self.dicResponse = [[NSMutableDictionary alloc] initWithDictionary:[saveData objectForKey:@"response"] copyItems:YES];
    }
}

- (NSString *) getCurrentSurveyDataFilePath
{
    if(self.currentSurveyIndex == -1 || self.currentSurveyIndex >= self.aryMySurveys.count)
        return nil;
    
    CaseInfo *survey = [self.aryMySurveys objectAtIndex:self.currentSurveyIndex];
    NSString * surveyNumber = survey.number;
    
    // save data
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString* pathToUserOfNamePlist = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:_STR_SURVEY_DATA_FILE_, surveyNumber]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSLog(@"%@", pathToUserOfNamePlist);
    
    if ([fileManager fileExistsAtPath:pathToUserOfNamePlist] == NO) return nil;
    
    return pathToUserOfNamePlist;
}

- (void) saveSurveyData
{
    if(self.currentSurveyIndex == -1 || self.currentSurveyIndex >= self.aryMySurveys.count)
        return;
    
    CaseInfo *survey = [self.aryMySurveys objectAtIndex:self.currentSurveyIndex];
    NSString * surveyNumber = survey.number;
    
    // save data
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
    NSString* pathToUserOfNamePlist = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:_STR_SURVEY_DATA_FILE_, surveyNumber]];
    
    NSMutableArray *aryLocalJurors = [[NSMutableArray alloc] init];
    for (LocalJurorInfo *jurorInfo in self.aryLocalJurors)
    {
        NSDictionary *dicLocalJuror = [NSDictionary dictionaryWithObjectsAndKeys:
                                       jurorInfo.tid,                           @"juror_id",
                                       jurorInfo.personality,                           @"juror_personality",
                                       jurorInfo.name,                          @"juror_name",
                                       [NSNumber numberWithInt:jurorInfo.age],  @"juror_age",
                                       [NSNumber numberWithInt:jurorInfo.rating],@"juror_rate",
                                       jurorInfo.symbol,                        @"juror_symbol",
                                       jurorInfo.education,                     @"juror_education",
                                       jurorInfo.politicalParty,                @"juror_politicalparty",
                                       jurorInfo.occupation,                    @"juror_occupation",
                                       jurorInfo.note,                          @"juror_note",
                                       [NSNumber numberWithInt:jurorInfo.preperemptory],@"juror_preperemptory",
                                       [NSNumber numberWithInt:jurorInfo.defence],      @"juror_defence",
                                       [NSNumber numberWithInt:jurorInfo.cause],        @"juror_cause",
                                       [NSNumber numberWithInt:jurorInfo.newVers],        @"juror_newVers",
                                       [NSNumber numberWithInt:jurorInfo.avatarIndex],        @"juror_avatar",
                                       [NSNumber numberWithInt:jurorInfo.actionIndex],        @"juror_action",
                                       jurorInfo.overide, @"juror_overide",
                                       [NSNumber numberWithInt:jurorInfo.gender], @"gender",
                                       [NSNumber numberWithInt:jurorInfo.ethnicity], @"ethnicity",
                                       nil];
        
        [aryLocalJurors addObject:dicLocalJuror];
    }
    
    NSMutableArray *arySelectedJurors = [[NSMutableArray alloc] init];
    for (LocalJurorInfo *jurorInfo in self.arySelectedJurors)
    {
        NSDictionary *dicLocalJuror = [NSDictionary dictionaryWithObjectsAndKeys:
                                       jurorInfo.tid,                           @"juror_id",
                                       jurorInfo.personality,                           @"juror_personality",
                                       jurorInfo.name,                          @"juror_name",
                                       [NSNumber numberWithInt:jurorInfo.age],  @"juror_age",
                                       [NSNumber numberWithInt:jurorInfo.rating],@"juror_rate",
                                       jurorInfo.symbol,                        @"juror_symbol",
                                       jurorInfo.education,                     @"juror_education",
                                       jurorInfo.politicalParty,                @"juror_politicalparty",
                                       jurorInfo.occupation,                    @"juror_occupation",
                                       jurorInfo.note,                          @"juror_note",
                                       [NSNumber numberWithInt:jurorInfo.preperemptory],@"juror_preperemptory",
                                       [NSNumber numberWithInt:jurorInfo.defence],      @"juror_defence",
                                       [NSNumber numberWithInt:jurorInfo.cause],        @"juror_cause",
                                       [NSNumber numberWithInt:jurorInfo.newVers],        @"juror_newVers",
                                       [NSNumber numberWithInt:jurorInfo.avatarIndex],        @"juror_avatar",
                                       [NSNumber numberWithInt:jurorInfo.actionIndex],        @"juror_action",
                                       jurorInfo.overide, @"juror_overide",
                                       [NSNumber numberWithInt:jurorInfo.gender], @"gender",
                                       [NSNumber numberWithInt:jurorInfo.ethnicity], @"ethnicity",
                                       nil];
        
        [arySelectedJurors addObject:dicLocalJuror];
    }
    
    NSMutableArray *aryLocalGroups = [[NSMutableArray alloc] init];
    for (GroupInfo *groupInfo in self.aryGroups)
    {
        NSDictionary *dicLocalGroupInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithInteger:groupInfo.groupId],  @"group_id",
                                           groupInfo.groupTitle,                            @"group_title",
                                           groupInfo.groupDesciption,                       @"group_description",
                                           nil];
        
        [aryLocalGroups addObject:dicLocalGroupInfo];
    }
    
    NSMutableArray *aryLocalQuestions = [[NSMutableArray alloc] init];
    for (QuestionInfo *questionInfo in self.aryLocalQuestions)
    {
        NSDictionary *dicLocalQuestion = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithInteger:questionInfo.qid],@"question_id",
                                          questionInfo.question,                        @"question_qustion",
                                          questionInfo.sumQuestion,                        @"question_sum",
                                          [NSNumber numberWithInteger:questionInfo.groupId],@"question_group",
                                          questionInfo.answer,                          @"question_answer",
                                          questionInfo.title,                           @"question_title",
                                          questionInfo.symbol,                          @"question_symbol",
                                          [NSNumber numberWithInt:questionInfo.responsePositive],  @"question_pos",
                                          [NSNumber numberWithInt:questionInfo.responseNagative],  @"question_nag",
                                          [NSNumber numberWithInt:questionInfo.style],  @"question_style",
                                          [NSNumber numberWithInt:questionInfo.weight], @"question_weight",
                                       nil];
        
        [aryLocalQuestions addObject:dicLocalQuestion];
    }
    
    NSMutableDictionary * saveData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      self.aryPoints,       @"point",
                                      aryLocalJurors,       @"jurors",
                                      arySelectedJurors,    @"selectedJurors",
                                      aryLocalQuestions,    @"localquestions",
                                      aryLocalGroups,       @"groups",
                                      self.dicResponse,     @"response",
                                      self.aryJurorPersonalityProfileDatas, @"personalityprofile",
                                      nil];
    
    NSLog(@"%@", pathToUserOfNamePlist);
    
    BOOL success = [saveData writeToFile:pathToUserOfNamePlist atomically:NO];
    
    NSLog(@"%d", success);
}

- (void) setSelectedSurveyIndex:(int)index
{
    self.currentSurveyIndex = index;
    
    [self loadSurveyData];
}

- (NSString *)getStringValue:(NSMutableDictionary *)dic key:(NSString *)key
{
    NSString *object = [dic objectForKey:key];
    
    if([object isKindOfClass:[NSNull class]])
    {
        object = @"";
    }
    
    return object;
}

- (void) addMySurvey:(CaseInfo *)mysurvey
{
    if(self.aryMySurveys == nil)
    {
        self.aryMySurveys = [[NSMutableArray alloc] init];
    }
    
    [self.aryMySurveys addObject:mysurvey];
    
    [self save];
}

- (void) deleteMySurvey:(int)index
{
    if(self.aryMySurveys.count <= index)
        return;
    
    [self.aryMySurveys removeObjectAtIndex:index];
    
    [self save];
}

- (void) updateMySurvey:(CaseInfo *)oldCaseInfo new:(CaseInfo *)newCaseInfo
{
    BOOL updated = NO;
    for (CaseInfo *survey in self.aryMySurveys)
    {
        if([survey.number isEqualToString:oldCaseInfo.number])
        {
            survey.name = newCaseInfo.name;
            survey.number = newCaseInfo.number;
            survey.location = newCaseInfo.location;
            survey.rows = newCaseInfo.rows;
            survey.columns = newCaseInfo.columns;
            survey.numberOfJurors = newCaseInfo.numberOfJurors;
            
            updated = YES;
            
            break;
        }
    }
    
    if(updated == NO)
    {
        [self addMySurvey:newCaseInfo];
    }
    
    [self save];
}

- (CaseInfo *)getMySurvey:(int)index
{
    if(index >= self.aryMySurveys.count)
        return nil;
    
    return [self.aryMySurveys objectAtIndex:index];
}

- (int) getCurrectSurveyWidth
{
    int width = 8;
    if(self.currentSurveyIndex >= 0 && self.currentSurveyIndex < self.aryMySurveys.count)
    {
        CaseInfo *currentCaseInfo = [self.aryMySurveys objectAtIndex:self.currentSurveyIndex];
        
        width = currentCaseInfo.columns;
    }
    
    return width;
}

- (int) getCurrectSurveyHeight
{
    int height = 5;
    if(self.currentSurveyIndex >= 0 && self.currentSurveyIndex < self.aryMySurveys.count)
    {
        CaseInfo *currentCaseInfo = [self.aryMySurveys objectAtIndex:self.currentSurveyIndex];
        
        height = currentCaseInfo.rows;
    }
    
    return height;
}

- (void) filterNullStringWithEmpty:(NSMutableArray *) aryData
{
    for (int n = 0 ; n < [aryData count] ; n ++) {
        
        NSMutableDictionary *item = [aryData objectAtIndex:n];
        
        [self filterNullStringWithEmptyOnDic:item];
    }
}

- (void) filterNullStringWithEmptyOnDic:(NSMutableDictionary *) dicData
{
    NSArray *allkeys = [dicData allKeys];
    
    for (NSString *key in allkeys) {
        
        id value = [dicData objectForKey:key];
        
        if([value isKindOfClass:[NSString class]])
        {
            
        }
        else if([value isKindOfClass:[NSMutableDictionary class]])
        {
            [self filterNullStringWithEmptyOnDic:value];
        }
        else if([value isKindOfClass:[NSMutableArray class]])
        {
            [self filterNullStringWithEmpty:value];
        }
        else
        {
            [dicData setValue:@"" forKey:key];
        }
    }
}

- (NSString *) getJurorFinalCount:(NSString *)jurorID
{
    
    float sum = 0.0f;
    for (QuestionInfo *localQuestion in self.aryLocalQuestions)
    {
        NSInteger weight = [self getWeightValueOnResponseWithJuror:jurorID question:localQuestion.qid];
        
        if(weight == NSNotFound) continue;
        
        sum += weight;
    }
    
    sum += [self getJurorMainWeightSum:jurorID];
    
    NSString *finalCount = [NSString stringWithFormat:@"%d", (int)sum];
    
    return finalCount;
}

- (NSInteger )getValueFromPersonalitySymbol:(NSString *)symbol
{
    NSInteger value = 0;
    if([symbol isEqualToString:@"EX"])
        value = [SettingManager shareSettingManager].valueEX;
    else if([symbol isEqualToString:@"IN"])
        value = [SettingManager shareSettingManager].valueIN;
    else if([symbol isEqualToString:@"YE"])
        value = [SettingManager shareSettingManager].valueYE;
    else if([symbol isEqualToString:@"CN"])
        value = [SettingManager shareSettingManager].valueCN;
    else if([symbol isEqualToString:@"SE"])
        value = [SettingManager shareSettingManager].valueSE;
    else if([symbol isEqualToString:@"IT"])
        value = [SettingManager shareSettingManager].valueIN2;
    else if([symbol isEqualToString:@"TH"])
        value = [SettingManager shareSettingManager].valueTH;
    else if([symbol isEqualToString:@"FE"])
        value = [SettingManager shareSettingManager].valueFE;
    else if([symbol isEqualToString:@"PE"])
        value = [SettingManager shareSettingManager].valuePE;
    else if([symbol isEqualToString:@"JU"])
        value = [SettingManager shareSettingManager].valueJU;
    
    return value;
}

- (NSInteger) getJurorMainWeightSum:(NSString *)jurorID
{
    NSInteger sum = 0;
    
    NSMutableArray *aryPersonalityProfileData = [self getPersonalityProfileWithJuror:jurorID];
    
    for (int n = 0 ; n < aryPersonalityProfileData.count ; n ++)
    {
        NSString *symbol = [[aryPersonalityProfileData objectAtIndex:n] objectForKey:@"symbol"];
        
        sum += [self getValueFromPersonalitySymbol:symbol];
    }
    
    LocalJurorInfo *juror = [self getLocalJuror:jurorID];
    
    if(juror.gender == 0)
        sum += [SettingManager shareSettingManager].valueMale;
    else
        sum += [SettingManager shareSettingManager].valueFemale;
    
    if([juror.education isEqualToString:[self.aryEducations objectAtIndex:0]])
        sum += [SettingManager shareSettingManager].value9th;
    else if([juror.education isEqualToString:[self.aryEducations objectAtIndex:1]])
        sum += [SettingManager shareSettingManager].valueSchool;
    else if([juror.education isEqualToString:[self.aryEducations objectAtIndex:2]])
        sum += [SettingManager shareSettingManager].valueCollege;
    else if([juror.education isEqualToString:[self.aryEducations objectAtIndex:3]])
        sum += [SettingManager shareSettingManager].valueAssociate;
    else if([juror.education isEqualToString:[self.aryEducations objectAtIndex:4]])
        sum += [SettingManager shareSettingManager].valueBachelor;
    else if([juror.education isEqualToString:[self.aryEducations objectAtIndex:5]])
        sum += [SettingManager shareSettingManager].valueMaster;
    else if([juror.education isEqualToString:[self.aryEducations objectAtIndex:6]])
        sum += [SettingManager shareSettingManager].valueDoctorate;
    
    if(juror.ethnicity == 0)
        sum += [SettingManager shareSettingManager].valueWhite;
    else if(juror.ethnicity == 1)
        sum += [SettingManager shareSettingManager].valueBlack;
    else if(juror.ethnicity == 2)
        sum += [SettingManager shareSettingManager].valueAslan;
    else if(juror.ethnicity == 3)
        sum += [SettingManager shareSettingManager].valueAmerican;
    else if(juror.ethnicity == 4)
        sum += [SettingManager shareSettingManager].valueMultiracial;
    else if(juror.ethnicity == 5)
        sum += [SettingManager shareSettingManager].valueHispanic;
    
    if([juror.politicalParty isEqualToString:[self.aryPolicityPartys objectAtIndex:0]])
        sum += [SettingManager shareSettingManager].valueDemocrat;
    else if([juror.politicalParty isEqualToString:[self.aryPolicityPartys objectAtIndex:1]])
        sum += [SettingManager shareSettingManager].valueRepublican;
    else if([juror.politicalParty isEqualToString:[self.aryPolicityPartys objectAtIndex:2]])
        sum += [SettingManager shareSettingManager].valueIndependent;
    
    
    return sum;
}

- (void) addSelectedJuror:(LocalJurorInfo *)juror
{
    if(self.arySelectedJurors == nil)
    {
        self.arySelectedJurors = [[NSMutableArray alloc] init];
    }
    
    for (LocalJurorInfo *localJuror in self.arySelectedJurors) {
        
        if([localJuror.tid isEqualToString:juror.tid])
        {
            localJuror.personality = juror.personality;
            localJuror.name = juror.name;
            localJuror.age = juror.age;
            localJuror.rating = juror.rating;
            localJuror.symbol = juror.symbol;
            localJuror.education = juror.education;
            localJuror.politicalParty = juror.politicalParty;
            localJuror.occupation = juror.occupation;
            localJuror.note = juror.note;
            localJuror.preperemptory = juror.preperemptory;
            localJuror.defence = juror.defence;
            localJuror.cause = juror.cause;
            localJuror.newVers = juror.newVers;
            localJuror.avatarIndex = juror.avatarIndex;
            localJuror.actionIndex = juror.actionIndex;
            localJuror.gender = juror.gender;
            localJuror.ethnicity = juror.ethnicity;
            
            [self saveSurveyData];
            
            return;
        }
    }
    
    [self.arySelectedJurors addObject:juror];
    [self addLocalJuror:juror];
    
    [self saveSurveyData];
}

- (void) removeSelectedJuror:(LocalJurorInfo *)juror
{
    if(self.arySelectedJurors == nil)
    {
        return;
    }
    
    for (LocalJurorInfo *localJuror in self.arySelectedJurors) {
        
        if([localJuror.tid isEqualToString:juror.tid])
        {
            [self.arySelectedJurors removeObject:localJuror];
            
            [self saveSurveyData];
            
            return;
        }
    }
}

- (BOOL) isSelectedJuror:(NSString *)tid
{
//    for (LocalJurorInfo *localJuror in self.arySelectedJurors) {
//        
//        if([localJuror.tid isEqualToString:tid])
//        {
//            
//            return YES;
//        }
//    }
//    
//    return NO;
    
    for (NSString *selectedTid in self.aryPoints) {
        
        if([selectedTid isEqualToString:tid])
        {
            return YES;
        }
    }
    
    return NO;
}

- (UIView *) getSurveySymbolView:(NSString *)jurorId
{
    int size = 26, inteval = 2;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, size)];
    view.backgroundColor = [UIColor clearColor];
    
    int symbolIndex = 0;
//    for (NSDictionary *dic in self.aryJurorPersonalityProfileDatas) {
//        
//        NSString *jurorId_ = [dic objectForKey:@"juror"];
//        
//        if([jurorId_  isEqualToString:jurorId])
//        {
//            NSArray *personalDatas = [dic objectForKey:@"personal"];
//            
//            for (NSDictionary *personalData in personalDatas) {
//                
//                symbolIndex ++;
//                
//                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((size + inteval) * (symbolIndex - 1), 0, 26, 26)];
//                label.textAlignment = NSTextAlignmentCenter;
//                label.text = [personalData objectForKey:@"symbol"];
//                label.textColor = [UIColor whiteColor];
//                label.font = [UIFont boldSystemFontOfSize:12];
//                
//                label.backgroundColor = [UIColor greenColor];
//                
//                [view addSubview:label];
//                label = nil;
//            }
//            
//            break;
//        }
//    }
    
    for (QuestionInfo *localQuestion in self.aryLocalQuestions)
    {
        if(localQuestion.symbol.length == 0) continue;
        
        NSInteger weight = [self getWeightValueOnResponseWithJuror:jurorId question:localQuestion.qid];
        
        if(weight == NSNotFound || [self includesThisSymbolOnLeftOfJuror:jurorId symbol:localQuestion.symbol]) continue;
        
        symbolIndex ++;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((size + inteval) * (symbolIndex - 1), 0, 26, 26)];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((size + inteval) * (symbolIndex - 1), 0, 26, 26)];
        btn.titleLabel.text = @"";
        btn.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        // Change N% to the Questions number
        
        if([localQuestion.symbol isEqualToString:@"N%"]){
            label.text = @"25%";
            
            NSMutableDictionary *jurorResponse = [self.dicResponse objectForKey:jurorId];
            
            if(jurorResponse != nil){
                NSMutableDictionary *responseData = [jurorResponse objectForKey:[NSString stringWithFormat:@"%ld", localQuestion.qid]];
                label.text = [responseData objectForKey:@"response"];
            }
        }
        else{
            label.text = localQuestion.symbol;
        }
        
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:12];
        
        if(weight > 0)
        {
            label.backgroundColor = [UIColor colorWithRed:63.0f / 255.0f green:127.0f/ 255.0f blue:59.0f/ 255.0f alpha:1.0];
        }
        else if (weight < 0)
        {
            label.backgroundColor = [UIColor colorWithRed:133.0f / 255.0f green:32.0f/ 255.0f blue:25.0f/ 255.0f alpha:1.0];
        }
        else{
            label.backgroundColor = [UIColor colorWithRed:31.0f / 255.0f green:40.0f/ 255.0f blue:55.0f/ 255.0f alpha:1.0];
        }
        
        [view addSubview:label];
        label = nil;
    }
    
    view.frame = CGRectMake(0, 0, (size + inteval) * symbolIndex, size);
    
    return view;
}

- (BOOL) includesThisSymbolOnLeftOfJuror:(NSString *)jurorId symbol:(NSString *)symbol
{
    NSArray *arySymbosOfTopLeftOnJuror1 = [self getCauseHardshipSymbol:jurorId];
    NSArray *arySymbosOfTopLeftOnJuror2 = [self getFrivilousSymbol:jurorId];
    
    for (NSMutableDictionary *dic in arySymbosOfTopLeftOnJuror1) {
        NSString *symbol_ = [dic objectForKey:@"symbol"];
        
        if([symbol_ isEqualToString:symbol])
            return YES;
    }
    
    for (NSMutableDictionary *dic in arySymbosOfTopLeftOnJuror2) {
        NSString *symbol_ = [dic objectForKey:@"symbol"];
        
        if([symbol_ isEqualToString:symbol])
            return YES;
    }
    
    return NO;
}

- (NSString *) getPoliticalPartySymbol:(NSString *)jurorId
{
    for (LocalJurorInfo *_juror in self.aryLocalJurors)
    {
        if([_juror.tid isEqualToString:jurorId])
        {
            if(_juror.politicalParty.length > 0)
            {
                return [_juror.politicalParty substringToIndex:1];
            }
            else
            {
                return @"";
            }
        }
    }
    
    return @"";
}

- (NSMutableArray *) getCauseHardshipSymbol:(NSString *)jurorId
{
    NSMutableDictionary *jurorResponse = [self.dicResponse objectForKey:jurorId];
    
    if(jurorResponse == nil) return nil;
    
    NSArray *allQuestions = [jurorResponse allKeys];
    
    int count = 0;
    NSMutableArray *arySymbols = [[NSMutableArray alloc] init];
    for (NSString *qid in allQuestions) {
        
        QuestionInfo *questionInfo = [self getLocalQuestion:[qid integerValue]];
        
        if([questionInfo.answer isEqualToString:[self.aryQuestionOptions objectAtIndex:1]] ||
           [questionInfo.answer isEqualToString:[self.aryQuestionOptions objectAtIndex:2]])
        {
            
            if(questionInfo.symbol != nil && questionInfo.symbol.length > 0 && questionInfo)
            {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            questionInfo.symbol,                @"symbol",
                                            [jurorResponse objectForKey:qid],   @"response",
                                            [NSString stringWithFormat:@"%ld", (long)questionInfo.qid],                   @"qid",
                                            nil];
                
                [arySymbols addObject:dic];
                //[arySymbols addObject:questionInfo.symbol];
                
                count ++;
            }
        }
        
        if(count == 4)
        {
            return arySymbols;
        }
    }
    
    return arySymbols;
}

- (NSMutableArray *) getFrivilousSymbol:(NSString *)jurorId
{
    NSMutableDictionary *jurorResponse = [self.dicResponse objectForKey:jurorId];
    
    if(jurorResponse == nil) return nil;
    
    NSArray *allQuestions = [jurorResponse allKeys];
    
    int count = 0;
    NSMutableArray *arySymbols = [[NSMutableArray alloc] init];
    for (NSString *qid in allQuestions) {
        
        QuestionInfo *questionInfo = [self getLocalQuestion:[qid integerValue]];
        
        if([questionInfo.answer isEqualToString:[self.aryQuestionOptions objectAtIndex:3]])
        {
            if(questionInfo.symbol != nil && questionInfo.symbol.length > 0)
            {
                //[arySymbols addObject:questionInfo.symbol];
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            questionInfo.symbol,                @"symbol",
                                            [jurorResponse objectForKey:qid],   @"response",
                                            [NSString stringWithFormat:@"%ld", (long)questionInfo.qid],                   @"qid",
                                            nil];
                
                [arySymbols addObject:dic];
                
                count ++;
            }
        }
        
        if(count == 4)
        {
            return arySymbols;
        }
    }
    
    return arySymbols;
}

- (NSInteger) getWeightValueOnResponseWithJuror:(NSString *)jurorId question:(NSInteger)qid
{
    NSMutableDictionary *jurorResponse = [self.dicResponse objectForKey:jurorId];
    
    if(jurorResponse == nil) return NSNotFound;
    
    NSMutableDictionary *responseData = [jurorResponse objectForKey:[NSString stringWithFormat:@"%ld", qid]];
    
    if(responseData == nil) return NSNotFound;
    
    return [[responseData objectForKey:@"weight"] floatValue];
}

- (NSString *)filterString:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"div" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"/" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return string;
}

- (NSInteger) addNewGroup:(GroupInfo *)group
{
    if(self.aryGroups == nil)
    {
        self.aryGroups = [[NSMutableArray alloc] init];
    }
    
    for(GroupInfo *groupInfo in self.aryGroups)
    {
        if([groupInfo.groupTitle isEqualToString:group.groupTitle])
        {
            return groupInfo.groupId;
        }
    }
    
    group.groupId = ((GroupInfo *)[self.aryGroups lastObject]).groupId + 1;
    
    [self.aryGroups addObject:group];
    
    [self saveSurveyData];
    
    return group.groupId;
}

- (GroupInfo *)getGroup:(int)groupId
{
    for (GroupInfo *group in self.aryGroups) {
        
        if(group.groupId == groupId)
        {
            
            return group;
        }
    }
    
    return nil;
}

- (GroupInfo *)getGroupWithIndex:(int)index
{
    if((self.aryGroups.count - 1) < index || self.aryGroups.count == 0)
        return nil;
    
    return [self.aryGroups objectAtIndex:index];
}

- (void) editGroup:(GroupInfo *)group
{
    for (GroupInfo *oldgroup in self.aryGroups) {
        
        if(oldgroup.groupId == group.groupId)
        {
            oldgroup.groupTitle = group.groupTitle;
            oldgroup.groupDesciption = group.groupDesciption;
            
            [self saveSurveyData];
            
            return;
        }
    }
}

- (void) deleteGroup:(int)index
{
    if(index >= self.aryGroups.count)
        return;
    
    GroupInfo *groupInfo = [self.aryGroups objectAtIndex:index];
    
    //////// remove all questions related with this group ///////////
    
    NSMutableArray *aryNewQuestions = [[NSMutableArray alloc] init];
    for (QuestionInfo *questionInfo in self.aryLocalQuestions)
    {
        if(groupInfo.groupId != questionInfo.groupId)
        {
            [aryNewQuestions addObject:questionInfo];
        }
        else
        {
            [self removeResponseWithQuestionId:questionInfo.qid];
        }
    }
    
    [self.aryLocalQuestions removeAllObjects];
    self.aryLocalQuestions = aryNewQuestions;
    
    [self.aryGroups removeObjectAtIndex:index];
    
    [self saveSurveyData];
}

- (void) removeResponseWithQuestionId:(NSInteger)questionId
{
    NSString *qID = [NSString stringWithFormat:@"%ld", questionId];
    
    NSArray *aryJurorIds = [self.dicResponse allKeys];
    
    for (NSString *jurorId in aryJurorIds) {
        
        NSMutableDictionary *jurorResponse = [self.dicResponse objectForKey:jurorId];
        
        NSArray *allQuestionIdsInReponse = jurorResponse.allKeys;
        
        if([allQuestionIdsInReponse containsObject:qID])
        {
            [jurorResponse removeObjectForKey:qID];
        }
    }
}

- (int) getTypeIndexFromKey:(NSString *)key
{
    NSArray *keys = [self.dicQuestionType allKeys];
    
    int n = 0;
    for (NSString *_key in keys) {
        if([_key isEqualToString:key])
            return n;
        
        n ++;
    }

    return 0;
}

- (NSString *) getQuestionKey:(int)index
{
    NSArray *keys = [self.dicQuestionType allKeys];
    
    return [keys objectAtIndex:index];
}

- (void) addLocalJuror:(LocalJurorInfo *)juror
{
    for (LocalJurorInfo *_juror in self.aryLocalJurors)
    {
        if([_juror.tid isEqualToString:juror.tid])
        {
            _juror.personality = juror.personality;
            _juror.name = juror.name;
            _juror.gender = juror.gender;
            _juror.age = juror.age;
            _juror.ethnicity = juror.ethnicity;
            _juror.rating = juror.rating;
            _juror.symbol = juror.symbol;
            _juror.education = juror.education;
            _juror.politicalParty = juror.politicalParty;
            _juror.occupation = juror.occupation;
            _juror.note = juror.note;
            _juror.preperemptory = juror.preperemptory;
            _juror.defence = juror.defence;
            _juror.cause = juror.cause;
            _juror.newVers = juror.newVers;
            _juror.avatarIndex = juror.avatarIndex;
            _juror.actionIndex = juror.actionIndex;
            _juror.overide = juror.overide;
            
            [self saveSurveyData];
            
            return;
        }
    }
    
    [self.aryLocalJurors addObject:juror];
    
    [self saveSurveyData];
}

- (void) deleteLocalJuror:(int)index
{
    if(index >= self.aryLocalJurors.count)
        return ;
    
    [self.aryLocalJurors removeObjectAtIndex:index];
}

- (void) updateLocalJurorWithNote:(NSString *)note tid:(NSString *)tid replace:(BOOL)replace
{
    for (LocalJurorInfo *_juror in self.aryLocalJurors)
    {
        if([_juror.tid isEqualToString:tid])
        {
            
            if(replace)
                _juror.note = [[NSString alloc] initWithFormat:@"%@", note];
            else
                _juror.note = [[NSString alloc] initWithFormat:@"%@\n%@", _juror.note, note];
            
            [self saveSurveyData];
            
            return;
        }
    }
}

- (void) updateLocalJurorWithAvatar:(int)index tid:(NSString *)tid
{
    for (LocalJurorInfo *_juror in self.aryLocalJurors)
    {
        if([_juror.tid isEqualToString:tid])
        {
            _juror.avatarIndex = index;
            
            [self saveSurveyData];
            
            return;
        }
    }
}

- (void) updateLocalJurorWithAction:(int)Actionindex tid:(NSString *)tid
{
    for (LocalJurorInfo *_juror in self.aryLocalJurors)
    {
        if([_juror.tid isEqualToString:tid])
        {
            _juror.actionIndex = Actionindex;
            
            [self saveSurveyData];
            
            return;
        }
    }
}

- (int) getActionindex:(NSString *)tid
{
    for (LocalJurorInfo *_juror in self.aryLocalJurors)
    {
        if([_juror.tid isEqualToString:tid])
        {
            return _juror.actionIndex;
        }
    }
    
    return -1;
}

- (void) updateLocalJurorWithFinalCount:(int)finalCount tid:(NSString *)tid
{
    for (LocalJurorInfo *_juror in self.aryLocalJurors)
    {
        if([_juror.tid isEqualToString:tid])
        {
            _juror.rating = finalCount;
            
            [self saveSurveyData];
            
            return;
        }
    }
}

- (LocalJurorInfo *) getLocalJuror:(NSString *)tid
{
    for (LocalJurorInfo *juror in self.aryLocalJurors)
    {
        if([juror.tid isEqualToString:tid])
        {
            return juror;
        }
    }
    
    return nil;
}

- (void) setStrike:(NSString *)tid type:(int)type
{
    LocalJurorInfo *localJuror = [self getLocalJuror:tid];
    
    if(type == 0)
    {
        localJuror.preperemptory = 1;
        localJuror.defence = 0;
        localJuror.cause = 0;
        localJuror.newVers = 0;
    }
    else if(type == 1)
    {
        localJuror.preperemptory = 0;
        localJuror.defence = 1;
        localJuror.cause = 0;
        localJuror.newVers = 0;
    }
    else if(type == 2)
    {
        localJuror.preperemptory = 0;
        localJuror.defence = 0;
        localJuror.cause = 1;
        localJuror.newVers = 0;
    }
    else if(type == 3)
    {
        localJuror.preperemptory = 0;
        localJuror.defence = 0;
        localJuror.cause = 0;
        localJuror.newVers = 0;
    }
    else if(type == 4)
    {
        localJuror.preperemptory = 0;
        localJuror.defence = 0;
        localJuror.cause = 0;
        localJuror.newVers = 1;
    }
    
    [self saveSurveyData];
}

- (BOOL) isStrikedAlready:(NSString *)tid
{
    LocalJurorInfo *localJuror = [self getLocalJuror:tid];
    
    if(localJuror.preperemptory > 0 ||
       localJuror.defence > 0 ||
       localJuror.cause > 0 ||
        localJuror.newVers > 0)
    {
        return YES;
    }
    
    return NO;
}

- (void) addQuestion:(QuestionInfo *)question
{
    if(self.aryLocalQuestions == nil)
    {
        self.aryLocalQuestions = [[NSMutableArray alloc] init];
    }
    
    QuestionInfo *oldquestion = [self getLocalQuestion:question.qid];
    
    if(oldquestion)
    {
        oldquestion.question = question.question;
        oldquestion.symbol = question.symbol;
        oldquestion.title = question.title;
        oldquestion.groupId = question.groupId;
        oldquestion.answer = question.answer;
        
        oldquestion.responsePositive = question.responsePositive;
        oldquestion.responseNagative = question.responseNagative;
        
        oldquestion.style = question.style;
        oldquestion.weight = question.weight;
        oldquestion.sumQuestion = question.sumQuestion;
    }
    else
    {
        [self.aryLocalQuestions addObject:question];
    }
    
    [self saveSurveyData];
}

- (void) deleteQuestion:(int)groupId index:(int)index
{
    int count = 0;
    for (QuestionInfo *quesiton in self.aryLocalQuestions) {
        
        if(quesiton.groupId == groupId)
        {
            if(count == index)
            {
                [self removeResponseWithQuestionId:quesiton.qid];
                
                [self.aryLocalQuestions removeObject:quesiton];
                
                break;
            }
            
            count ++;
        }
    }
    
    [self saveSurveyData];
}

- (QuestionInfo *)getLocalQuestion:(NSInteger)qid
{
    for (QuestionInfo *questionInfo in self.aryLocalQuestions)
    {
        if(questionInfo.qid == qid)
        {
            return questionInfo;
        }
    }
    
    return nil;
}

- (void) setJurorPoint:(NSInteger)point tid:(NSString *)tid
{
    [self.aryPoints replaceObjectAtIndex:point withObject:tid];
    
    [self saveSurveyData];
}

- (void) removeJurorIdFromSelectedList:(NSString *)tid
{
    NSInteger index = NSNotFound;
    for (NSInteger n = 0 ; n < self.aryPoints.count ; n ++) {
        
        NSString *selectedTid = [self.aryPoints objectAtIndex:n];
        
        if([selectedTid isEqualToString:tid])
        {
            index = n;
        }
    }
    
    if(index != NSNotFound)
    {
        [self setJurorPoint:index tid:@""];
    }
}

- (void) addResponse:(NSString *)jurorID question:(QuestionInfo *)question response:(NSString *)response weight:(float)weight
{
    NSMutableDictionary *jurorResponse = [self.dicResponse objectForKey:jurorID];
    
    if(jurorResponse == nil)
    {
        NSMutableDictionary *responseData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             response,                          @"response",
                                             [NSNumber numberWithFloat:weight], @"weight",
                                             nil];
        
        NSMutableDictionary *dicResponse = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            responseData, [NSString stringWithFormat:@"%ld", question.qid],
                                            nil];
        
        [self.dicResponse setObject:dicResponse forKey:jurorID];
    }
    else
    {
        NSMutableDictionary *dicResponse = [jurorResponse objectForKey:question];
        
        if(dicResponse)
        {
            [dicResponse setObject:response forKey:@"response"];
            [dicResponse setObject:[NSNumber numberWithFloat:weight] forKey:@"weight"];
        }
        else
        {
            NSMutableDictionary *responseData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 response,                          @"response",
                                                 [NSNumber numberWithFloat:weight], @"weight",
                                                 nil];
            
            NSMutableDictionary *newJurorResponse = [[NSMutableDictionary alloc] initWithDictionary:jurorResponse copyItems:YES];
            
            [newJurorResponse setObject:responseData forKey:[NSString stringWithFormat:@"%ld", question.qid]];
            
            [self.dicResponse setObject:newJurorResponse forKey:jurorID];
            newJurorResponse = nil;
        }
    }
    
    [self saveSurveyData];
}

- (NSMutableDictionary *)getResponseWithJuror:(NSString *)jurorID question:(QuestionInfo *)question
{
    NSMutableDictionary *jurorResponse = [self.dicResponse objectForKey:jurorID];
    
    if(jurorResponse == nil) return nil;
    
    NSMutableDictionary *responseData = [jurorResponse objectForKey:[NSString stringWithFormat:@"%ld", question.qid]];
    
    if(responseData == nil) return nil;
    
    return responseData;
}

- (NSMutableArray *)getPersonalityProfileWithJuror:(NSString *)tid
{
    NSMutableArray *aryShowablePersonalDatas = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dic in self.aryJurorPersonalityProfileDatas) {
        
        NSString *jurorToken = [dic objectForKey:@"juror"];
        
        if([jurorToken isEqualToString:tid])
        {
            NSMutableArray *personalDatas = [dic objectForKey:@"personal"];
            
            for (NSMutableDictionary *onePersonalData in personalDatas) {
                
                NSString *symbol = [onePersonalData objectForKey:@"symbol"];
                
                if([self isShowablePersonalData:symbol])
                {
                    [aryShowablePersonalDatas addObject:onePersonalData];
                }
            }
        }
    }
    
    return aryShowablePersonalDatas;
}

- (BOOL )isShowablePersonalData:(NSString *)symbol
{
    if ([symbol length] > 1) {
        symbol = [symbol substringToIndex:2];
    }
    
    if([symbol isEqualToString:@"N/"]){
        symbol = @"NA";
    }
    
    
    
    if([symbol isEqualToString:@"EX"] || [symbol isEqualToString:@"IN"] || [symbol isEqualToString:@"N/A"])
        return [SettingManager shareSettingManager].isEXnotIN;
    else if([symbol isEqualToString:@"YE"] || [symbol isEqualToString:@"CN"] || [symbol isEqualToString:@"N/A"])
        return [SettingManager shareSettingManager].isYEnotCN;
    else if([symbol isEqualToString:@"MO"] || [symbol isEqualToString:@"AC"] || [symbol isEqualToString:@"N/A"])
        return [SettingManager shareSettingManager].isSEnotIN;
    else if([symbol isEqualToString:@"LR"] || [symbol isEqualToString:@"AQ"] || [symbol isEqualToString:@"N/A"])
        return [SettingManager shareSettingManager].isTHnotFE;
    else if([symbol isEqualToString:@"NR"] || [symbol isEqualToString:@"ID"] || [symbol isEqualToString:@"N/A"])
        return [SettingManager shareSettingManager].isPEnotJU;
    
    return NO;
}

- (void) updatePersonalityProfileWithJuror:(NSString *)tid personalityData:(NSArray *)personalityData
{
    for (NSDictionary *oldDic in self.aryJurorPersonalityProfileDatas) {
        
        NSString *jurorToken = [oldDic objectForKey:@"juror"];
        
        if([jurorToken isEqualToString:tid])
        {
            [self.aryJurorPersonalityProfileDatas removeObject:oldDic];
            break;
        }
    }
    
    NSMutableArray *aryJurorPersonalData = [[NSMutableArray alloc] init];
    for (NSDictionary *groupData in personalityData) {
        
        int groupIndex = [[groupData objectForKey:@"group"] intValue];
        
        int answer1 = [[groupData objectForKey:@"answer1"] intValue];
        int answer2 = [[groupData objectForKey:@"answer2"] intValue];
        int answer3 = [[groupData objectForKey:@"answer3"] intValue];
        int answer4 = [[groupData objectForKey:@"answer4"] intValue];
        
        NSArray *groupData = [self.aryPersonalityProfileData objectAtIndex:groupIndex];
        
        NSDictionary *answerData1 = [groupData objectAtIndex:0];
        NSString *symbol1 = [[[[[answerData1 allValues] objectAtIndex:0] objectAtIndex:answer1] allValues] objectAtIndex:0];
        
        NSDictionary *answerData2 = [groupData objectAtIndex:1];
        NSString *symbol2 = [[[[[answerData2 allValues] objectAtIndex:0] objectAtIndex:answer2] allValues] objectAtIndex:0];
        
        NSDictionary *answerData3 = [groupData objectAtIndex:2];
        NSString *symbol3 = [[[[[answerData3 allValues] objectAtIndex:0] objectAtIndex:answer3] allValues] objectAtIndex:0];
        NSLog(@"Made it");
        NSString *symbol4 = @"";
        if([groupData count] > 3){
        NSDictionary *answerData4 = [groupData objectAtIndex:3];
        symbol4 = [[[[[answerData4 allValues] objectAtIndex:0] objectAtIndex:answer4] allValues] objectAtIndex:0];
        }
        
        NSLog(@"Made it1");
        NSString *symbol = @"";
        
        NSString *sym1 = @"";
        NSString *sym2 = @"";
        
        
        int oneCount = 0;
        int twoCount = 0;
        int nacount = 0;
        
        // Symbol 1
        if([symbol1 isEqualToString:@"NA"]){
            nacount++;
        }
        else{
            sym1 = symbol1;
            oneCount++;
        }
        
        //Symbol 2
        if([symbol2 isEqualToString:@"NA"]){
            nacount++;
        }
        else if([symbol2 isEqualToString:sym1]){
            oneCount++;
        }
        else if ([sym1 isEqualToString:@""]){
            sym1 = symbol2;
            oneCount++;
        }
        else{
            sym2 = symbol2;
            twoCount++;
        }
        
        // Symbol 3
        if([symbol3 isEqualToString:@"NA"]){
            nacount++;
        }
        else if([symbol3 isEqualToString:sym1]){
            oneCount++;
        }
        else if ([sym1 isEqualToString:@""]){
            sym1 = symbol3;
            oneCount++;
        }
        else{
            sym2 = symbol3;
            twoCount++;
        }
        if(![symbol4 isEqualToString:@""]){
            if([symbol4 isEqualToString:@"NA"]){
                nacount++;
            }
            else if([symbol4 isEqualToString:sym1]){
                oneCount++;
            }
            else if ([sym1 isEqualToString:@""]){
                sym1 = symbol4;
                oneCount++;
            }
            else{
                sym2 = symbol4;
                twoCount++;
            }
        }
        
        
        NSLog(@"One count: %d", oneCount);
        NSLog(@"Two count: %d", twoCount);
        
        if(![symbol4 isEqualToString:@""]){
            if(oneCount == 4){
                symbol = [NSString stringWithFormat:@"%@+", sym1];
            }
            if(oneCount == 3){
                symbol = sym1;
            }
            if(oneCount == 2 && twoCount == 2){
                symbol = [NSString stringWithFormat:@"%@/%@", sym1, sym2];
            }
            if(oneCount == 1){
                symbol = sym2;
            }
            if(nacount > 2){
                symbol = @"N/A";
            }
        }
        else{
            if(oneCount >= 2){
                if(oneCount == 3){
                    symbol = [NSString stringWithFormat:@"%@+", sym1];
                }
                else{
                    symbol = sym1;
                }
            }
            else{
                symbol = sym2;
            }
            if(nacount >= 2){
                symbol = @"N/A";
            }
        }
        

        
        //symbol = symbol;
        NSLog(@"%@", symbol);
        
//        else if([symbol1 isEqualToString:symbol3])
//        {
//            symbol = symbol1;
//        }
//        else
//        {
//            symbol = symbol2;
//        }

        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:groupIndex], @"group",
                             [NSNumber numberWithInt:answer1], @"answer1",
                             [NSNumber numberWithInt:answer2], @"answer2",
                             [NSNumber numberWithInt:answer3], @"answer3",
                             [NSNumber numberWithInt:answer4], @"answer4",
                             symbol, @"symbol",
                             nil];
        
        [aryJurorPersonalData addObject:dic];
    }
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         tid, @"juror",
                         aryJurorPersonalData, @"personal",
                         nil];
    
    [self.aryJurorPersonalityProfileDatas addObject:dic];
    
    [self saveSurveyData];
}

+ (NSData *)base64DataFromString: (NSString *)string {
    unsigned long ixtext, lentext;
    unsigned char ch, input[4], output[3];
    short i, ixinput;
    Boolean flignore, flendtext = false;
    const char *temporary;
    NSMutableData *result;
    
    if (!string) {
        return [NSData data];
    }
    
    ixtext = 0;
    
    temporary = [string UTF8String];
    
    lentext = [string length];
    
    result = [NSMutableData dataWithCapacity: lentext];
    
    ixinput = 0;
    
    while (true) {
        if (ixtext >= lentext) {
            break;
        }
        
        ch = temporary[ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z')) {
            ch = ch - 'A';
        } else if ((ch >= 'a') && (ch <= 'z')) {
            ch = ch - 'a' + 26;
        } else if ((ch >= '0') && (ch <= '9')) {
            ch = ch - '0' + 52;
        } else if (ch == '+') {
            ch = 62;
        } else if (ch == '=') {
            flendtext = true;
        } else if (ch == '/') {
            ch = 63;
        } else {
            flignore = true;
        }
        
        if (!flignore) {
            short ctcharsinput = 3;
            Boolean flbreak = false;
            
            if (flendtext) {
                if (ixinput == 0) {
                    break;
                }
                
                if ((ixinput == 1) || (ixinput == 2)) {
                    ctcharsinput = 1;
                } else {
                    ctcharsinput = 2;
                }
                
                ixinput = 3;
                
                flbreak = true;
            }
            
            input[ixinput++] = ch;
            
            if (ixinput == 4) {
                ixinput = 0;
                
                unsigned char0 = input[0];
                unsigned char1 = input[1];
                unsigned char2 = input[2];
                unsigned char3 = input[3];
                
                output[0] = (char0 << 2) | ((char1 & 0x30) >> 4);
                output[1] = ((char1 & 0x0F) << 4) | ((char2 & 0x3C) >> 2);
                output[2] = ((char2 & 0x03) << 6) | (char3 & 0x3F);
                
                for (i = 0; i < ctcharsinput; i++) {
                    [result appendBytes: &output[i] length: 1];
                }
            }
            
            if (flbreak) {
                break;
            }
        }
    }
    
    return result;
}

+ (NSString *)base64StringFromData: (NSData *)data length: (NSUInteger)length {
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    
    if (lentext < 1) {
        return @"";
    }
    
    result = [NSMutableString stringWithCapacity: lentext];
    
    raw = [data bytes];
    
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        
        if (ctremaining <= 0) {
            break;
        }
        
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            
            if (ix < lentext) {
                input[i] = raw[ix];
            } else {
                input[i] = 0;
            }
        }
        
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        
        ctcopy = 4;
        
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++) {
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        }
        
        for (i = ctcopy; i < 4; i++) {
            [result appendString: @"="];
        }
        
        ixtext += 3;
        charsonline += 4;
        
        if ((ixtext % 90) == 0) {
            [result appendString: @"\n"];
        }
        
        if (length > 0) {
            if (charsonline >= length) {
                charsonline = 0;
                
                [result appendString: @"\n"];
            }
        }
    }
    
    return result;
}

static char base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

@end
