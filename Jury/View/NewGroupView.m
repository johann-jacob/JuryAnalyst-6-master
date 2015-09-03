//
//  NewGroupView.m
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import "NewGroupView.h"

#import "DataManager.h"

#import "GroupInfo.h"

@interface NewGroupView()
{
    BOOL _isEditingState;
}

@property (nonatomic, assign) int groupId;

@property (nonatomic, assign) IBOutlet UITextField *txtGroupTitle;
@property (nonatomic, assign) IBOutlet UITextView *txtGroupDescription;

- (IBAction)onCancel:(id)sender;
- (IBAction)onDone:(id)sender;

@end

@implementation NewGroupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) _init
{
    self.txtGroupTitle.text = @"";
    //self.txtGroupTitle.enabled = YES;
    
    self.txtGroupDescription.text = @"";
    
    _isEditingState = NO;
}

- (void) _initWithId:(int)groupId
{
    GroupInfo *group = [[DataManager shareDataManager] getGroup:groupId];
    
    if(group == nil)
    {
        [self _init];
        return;
    }
    
    self.groupId = groupId;
    
    self.txtGroupTitle.text = group.groupTitle;
    //self.txtGroupTitle.enabled = NO;
    
    self.txtGroupDescription.text = group.groupDesciption;
    
    _isEditingState = YES;
}

- (IBAction)onCancel:(id)sender
{
    [self.delegate cancelNewGroup:self];
}

- (IBAction)onDone:(id)sender
{
    NSString *title = self.txtGroupTitle.text;
    NSString *description = self.txtGroupDescription.text;
    
    if(title.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please add a valid data." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    
    GroupInfo *groupInfo = [[GroupInfo alloc] init];
    groupInfo.groupTitle = title;
    groupInfo.groupDesciption = description;
    
    if(_isEditingState)
    {
        groupInfo.groupId = self.groupId;
        [self.delegate doneEditGroup:self group:groupInfo];
    }
    else
    {
        
        [self.delegate doneNewGroup:self group:groupInfo];
    }
}

@end
