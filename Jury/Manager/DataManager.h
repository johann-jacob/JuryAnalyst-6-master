//
//  DataManager.h
//  JuryApp
//
//  Created by hanjinghe on 11/17/13.
//  Copyright (c) 2013 Hanjinghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CaseInfo;
@class GroupInfo;
@class QuestionInfo;
@class JurorInfo;
@class LocalJurorInfo;

#define BASE_URL @"http://app.juryanalyst.com/index.php?r=admin/remotecontrol"

enum SORT_OPTION {
    SORT_LOCATION,
    SORT_RATE,
    SORT_ALPAH,
};

@interface DataManager : NSObject
{
    
}

@property (nonatomic, retain) NSMutableArray *aryLocalJurors;
//@property (nonatomic, retain) NSMutableArray *aryJurors;
@property (nonatomic, retain) NSMutableArray *arySelectedJurors;

@property (nonatomic, retain) NSMutableArray *aryMySurveys;

@property (nonatomic, retain) NSMutableArray *aryGroups;

@property (nonatomic, retain) NSMutableDictionary *dicQuestionType;
@property (nonatomic, retain) NSMutableArray *aryLocalQuestions;

@property (nonatomic, retain) NSMutableDictionary *dicResponse;

@property (nonatomic, retain) NSMutableArray *aryEthnicity;
@property (nonatomic, retain) NSMutableArray *aryEducations;
@property (nonatomic, retain) NSMutableArray *aryPolicityPartys;
@property (nonatomic, retain) NSMutableArray *aryQuestionOptions;

@property (nonatomic, retain) NSMutableArray *aryPersonalityProfileData;
@property (nonatomic, retain) NSMutableArray *aryJurorPersonalityProfileDatas;

@property (nonatomic, retain) CaseInfo *caseInfo;

@property (nonatomic, assign) NSInteger currentSurveyIndex;

@property (nonatomic, assign) BOOL showWithHardStrike;
@property (nonatomic, assign) BOOL showWithCauseStrike;
@property (nonatomic, assign) BOOL showWithPreemptStrike;

@property (nonatomic, assign) BOOL showWithoutStrike;

@property (nonatomic, assign) int sortOption;

@property (nonatomic, assign) int jurorWidth;
@property (nonatomic, assign) int jurorHeight;

@property (nonatomic, retain) NSArray *sortJurorNumbers;

@property (nonatomic, retain) NSMutableArray *aryPoints;

+ (DataManager *)shareDataManager;
+ (void)releaseDataManager;

- (void) loadSurveyData;
- (void) saveSurveyData;

- (NSString *) getCurrentSurveyDataFilePath;

- (void) setSelectedSurveyIndex:(int)index;

- (void) addMySurvey:(CaseInfo *)mysurvey;
- (void) deleteMySurvey:(int)index;
- (void) updateMySurvey:(CaseInfo *)oldCaseInfo new:(CaseInfo *)newCaseInfo;
- (CaseInfo *)getMySurvey:(int)index;
- (int) getCurrectSurveyWidth;
- (int) getCurrectSurveyHeight;

- (NSString *) getJurorFinalCount:(NSString *)jurorID;

- (NSInteger )getValueFromPersonalitySymbol:(NSString *)symbol;

- (void) addSelectedJuror:(LocalJurorInfo *)juror;
- (void) removeSelectedJuror:(LocalJurorInfo *)juror;
- (BOOL) isSelectedJuror:(NSString *)tid;

- (UIView *) getSurveySymbolView:(NSString *)jurorId;

- (NSString *) getPoliticalPartySymbol:(NSString *)jurorId;
- (NSMutableArray *) getCauseHardshipSymbol:(NSString *)jurorId;
- (NSMutableArray *) getFrivilousSymbol:(NSString *)jurorId;

- (NSInteger) addNewGroup:(GroupInfo *)group;
- (GroupInfo *)getGroup:(int)groupId;
- (GroupInfo *)getGroupWithIndex:(int)index;
- (void) editGroup:(GroupInfo *)group;
- (void) deleteGroup:(int)index;

- (void) addQuestion:(QuestionInfo *)question;
- (void) deleteQuestion:(int)groupId index:(int)index;

- (int) getTypeIndexFromKey:(NSString *)key;
- (NSString *) getQuestionKey:(int)index;

- (void) addLocalJuror:(LocalJurorInfo *)juror;
- (void) deleteLocalJuror:(int)index;
- (void) updateLocalJurorWithNote:(NSString *)note tid:(NSString *)tid replace:(BOOL)replace;
- (void) updateLocalJurorWithAvatar:(int)index tid:(NSString *)tid;
- (void) updateLocalJurorWithAction:(int)Actionindex tid:(NSString *)tid;
- (int) getActionindex:(NSString *)tid;
- (void) updateLocalJurorWithFinalCount:(int)finalCount tid:(NSString *)tid;
- (LocalJurorInfo *) getLocalJuror:(NSString *)tid;

- (void) setStrike:(NSString *)tid type:(int)type;
- (BOOL) isStrikedAlready:(NSString *)tid;

- (void) addResponse:(NSString *)jurorID question:(QuestionInfo *)question response:(NSString *)response weight:(float)weight;
- (NSMutableDictionary *)getResponseWithJuror:(NSString *)jurorID question:(QuestionInfo *)question;

- (void) updatePersonalityProfileWithJuror:(NSString *)tid personalityData:(NSArray *)personalityData;
- (NSMutableArray *)getPersonalityProfileWithJuror:(NSString *)tid;

- (QuestionInfo *)getLocalQuestion:(NSInteger)qid;

- (void) setJurorPoint:(NSInteger)point tid:(NSString *)tid;
- (void) removeJurorIdFromSelectedList:(NSString *)tid;

+ (NSString *)base64StringFromData: (NSData *)data length: (NSUInteger)length;
+ (NSData *)base64DataFromString: (NSString *)string;

@end
