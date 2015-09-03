//
//  SampleQuestions.m
//  JuryApp
//
//  Created by hanjinghe on 11/17/13.
//  Copyright (c) 2013 Hanjinghe. All rights reserved.
//

#import "SampleQuestions.h"
#import "DataManager.h"

#import "GroupInfo.h"
#import "QuestionInfo.h"

@interface SampleQuestions()

@end

@implementation SampleQuestions

#define _STR_QUESTIONAIRE_FILE_ @"questionaire.plist"

static SampleQuestions *_shareSampleQuestions;

+ (SampleQuestions *)shareSampleQuestions
{
    @synchronized(self) {
        
        if(_shareSampleQuestions == nil)
        {
            _shareSampleQuestions = [[SampleQuestions alloc] init];
            
            
        }
    }
    
    return _shareSampleQuestions;
}

+ (void)releaseSampleQuestions
{
    if(_shareSampleQuestions != nil)
    {
        _shareSampleQuestions = nil;
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
    NSDictionary *defaultQuestionaire = @{@"Hardship" :
                                                @[@"Would serving on the jury in this case create any significant hardship for you, financially or otherwise, such as family responsibilities, small children under your care, etc.?",
                                                  @"Do you have any physical ailment or medicalcondition that would make it difficult for you to serve as a juror in this case?",
                                                  @"Do you have any religious or philosophical beliefs that would make it difficult for you to be a juror? If yes, please explain.",
                                                  @"Do you have any difficulty reading, speaking or understanding English?"],
                                  @"Media Exposure" :
                                      @[@"Which TV news channels do you watch (please list all that apply, i.e. NBC, ABC, CBS, FOX, Internet Media Links, YouTube, etc.)?",
                                        @"What would you say is your primary source of news on a daily basis? Radio? Newspaper? TV? Internet? Other?",
                                        @"Do you listen to talk radio or any other news radio program? If so, which one(s)?",
                                        @"Do you regularly watch any television personalities? Talk shows? If so, which one(s)?",
                                        @"If the judge asked you to promise not to read or watch any news about this case, not to discuss this case with others (including fellow jurors), and not to do any independent research about this case, could you make and keep that promise? If no, please explain."],
                                  @"Litigation Experience" :
                                      @[@"Have you or anyone you know ever sued anyone? If yes, who, why and what was the result?",
                                        @"Have you or anyone you know ever been sued? If yes, who, why, and what was the result?",
                                        @"Have you or anyone you know ever hired a lawyer for a lawsuit? If yes, who, why and what was the result?",
                                        @"Have you ever served as a juror in a civil case? If yes, what type of civil case was it?",
                                        @"Have you, or anyone in your household, ever been a party or a witness in a civil or criminal court case? If yes, please explain."],
                                  @"Prior Injuries" :
                                      @[@"Do you worry about your own safely or your family’s personal safety? In what way, please explain?",
                                        @"Have you ever been hurt in any kind of accident? If yes, please describe the type of accident, who’s fault was it, your injuries and if any of your injuries were permanent.",
                                        @"Have you ever received money for harm done to you? If yes, please explain.",
                                        @"Has anyone close to you ever been seriously injured or killed in any kind of accident? If yes, please describe it.",
                                        @"Are there any current or past personal tragedies in your life that you feel still affect you daily?"],
                                  @"Lawsuits" :
                                      @[@"If you or a loved one were injured or killed through the alleged fault of a company/invidual, would you consider suing the company/individual? If no, why not?",
                                        @"Do you think the damages awarded in trials are generally too large? Too small? Reasonable? Don’t know/no opinion?",
                                        @"In general, what are your thoughts about lawsuits?",
                                        @"What percentage of all civil lawsuits filed in the U.S. do you believe the defendants argue frivolous (silly) defenses?",
                                        @"What are your general feelings about lawyers?"],
                                  @"Product/Company Relations" :
                                      @[@"Have you been exposed to any information, through the media, Internet, word-of-mouth, or any other source about any of the people, products, lawyers, or witnesses involved in this case?",
                                        @"Do you have any professional or personal ties to the plaintiff, the plaintiff’s family or any of the companies involved in this lawsuit?",
                                        @"Have you, or any of your immediate family members, ever worked for any of the companies involved in this case?",
                                        @"Do you, or any of your immediate familymembers, have any financial interest (for example own any stock or other investment) in the company or companies associated with this case?"],
                                  };
    
    NSDictionary *dicQuestionaire = [NSDictionary dictionaryWithObjectsAndKeys:@"Default", @"name",
                                     @"", @"description",
                                     defaultQuestionaire, @"data",
                                     nil];
    
    if(self.aryQuestionaires == nil)
    {
        self.aryQuestionaires = [[NSMutableArray alloc] init];
    }
    
    [self.aryQuestionaires removeAllObjects];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
    NSString* pathToUserOfNamePlist = [documentsDirectory stringByAppendingPathComponent:_STR_QUESTIONAIRE_FILE_];
    
    NSLog(@"%@", pathToUserOfNamePlist);
    
    if ([fileManager fileExistsAtPath:pathToUserOfNamePlist] == NO)
    {
        [self.aryQuestionaires addObject:dicQuestionaire];
    }
    else
    {
        NSMutableDictionary* saveData = [[NSMutableDictionary alloc] initWithContentsOfFile:pathToUserOfNamePlist];
        
        self.aryQuestionaires = [[NSMutableArray alloc] initWithArray:[saveData objectForKey:@"Questionaires"]];
    }
}

- (void) save
{
    // save data
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
    NSString* pathToUserOfNamePlist = [documentsDirectory stringByAppendingPathComponent:_STR_QUESTIONAIRE_FILE_];
    
    NSMutableDictionary * saveData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      self.aryQuestionaires,     @"Questionaires",
                                      nil];
    
    NSLog(@"%@", saveData);
    
    [saveData writeToFile:pathToUserOfNamePlist atomically:YES];
}

- (void) addQuestionaire:(NSString *)name
{
    for (NSMutableDictionary *oneQuestionaire in self.aryQuestionaires) {
        
        NSString *name_ = [oneQuestionaire objectForKey:@"name"];
        
        if([name_ isEqualToString:name])
        {
            NSMutableDictionary *questionaireData = [oneQuestionaire objectForKey:@"data"];
            
            NSArray *groups = [questionaireData allKeys];
            for (int groupIndex = 0 ; groupIndex < groups.count ; groupIndex ++) {
                
                NSString *groupTitle = [groups objectAtIndex:groupIndex];
                
                GroupInfo *groupInfo = [[GroupInfo alloc] init];
                groupInfo.groupTitle = groupTitle;
                
                NSInteger groupID = [[DataManager shareDataManager] addNewGroup:groupInfo];
                
                NSArray *questions = [questionaireData objectForKey:groupTitle];
                
                for (int quesitonIndex = 0 ; quesitonIndex < questions.count ; quesitonIndex ++) {
                    
                    NSString *question = [questions objectAtIndex:quesitonIndex];
                    
                    NSInteger quesitonID = ((QuestionInfo *)[[DataManager shareDataManager].aryLocalQuestions lastObject]).qid + 1;
                    
                    QuestionInfo *questionInfo = [[QuestionInfo alloc] init];
                    questionInfo.question = question;
                    questionInfo.qid = quesitonID;
                    questionInfo.groupId = groupID;
                    
                    [[DataManager shareDataManager] addQuestion:questionInfo];
                }
            }
        }
    }
}

- (void) saveCurrentQuestionsToQuestionaire:(NSString *)name description:(NSString *)description
{
    NSMutableDictionary *newGroupAndQuestions = [[NSMutableDictionary alloc] init];
    
    for (GroupInfo *groupInfo in [DataManager shareDataManager].aryGroups) {
        
        NSMutableArray *aryQuestions = [[NSMutableArray alloc] init];
        
        for (QuestionInfo *question in [DataManager shareDataManager].aryLocalQuestions) {
            
            if(groupInfo.groupId == question.groupId)
            {
                [aryQuestions addObject:question.question];
            }
            
        }
        
        [newGroupAndQuestions setObject:aryQuestions forKey:groupInfo.groupTitle];
    }
    
    NSDictionary *dicNewQuestionaire = [NSDictionary dictionaryWithObjectsAndKeys:
                                     name, @"name",
                                     description, @"description",
                                     newGroupAndQuestions, @"data",
                                     nil];
    
    [self.aryQuestionaires addObject:dicNewQuestionaire];
    
    [self save];
}

@end
