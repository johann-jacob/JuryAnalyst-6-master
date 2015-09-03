//
//  QuestionSettingView.m
//
//  Created by Han Jinghe on 2/8/13.
//
//

#import "QuestionSettingView.h"

#import "DataManager.h"
#import "SettingManager.h"

@interface QuestionSettingView()<UITextFieldDelegate>
{

}

@property (nonatomic, assign) IBOutlet UITableView *tvPersonality;
@property (nonatomic, assign) IBOutlet UITableView *tvDemographics;

- (IBAction)onCancel:(id)sender;
- (IBAction)onDone:(id)sender;

@end

@implementation QuestionSettingView

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

- (IBAction)onCancel:(id)sender
{
    self.hidden = YES;
}

- (IBAction)onDone:(id)sender
{
    self.hidden = YES;
}

- (void) onChangeSwitch:(UISwitch *) sender
{
    NSInteger tag = sender.tag;
    
    NSInteger component = tag / 10;
    NSInteger section = tag - component * 10;
    
    if(component == 0)
    {
        if(section == 0)
        {
            [SettingManager shareSettingManager].isEXnotIN = sender.isOn;
        }
        else if(section == 1)
        {
            [SettingManager shareSettingManager].isYEnotCN = sender.isOn;
        }
        else if(section == 2)
        {
            [SettingManager shareSettingManager].isSEnotIN = sender.isOn;
        }
        else if(section == 3)
        {
            [SettingManager shareSettingManager].isTHnotFE = sender.isOn;
        }
        else if(section == 4)
        {
            [SettingManager shareSettingManager].isPEnotJU = sender.isOn;
        }
        
        [self.tvPersonality reloadData];
    }
    else if(component == 1)
    {
        if(section == 0)
        {
            [SettingManager shareSettingManager].isGender = sender.isOn;
        }
        else if(section == 1)
        {
            [SettingManager shareSettingManager].isEducation = sender.isOn;
        }
        else if(section == 2)
        {
            [SettingManager shareSettingManager].isEthnicity = sender.isOn;
        }
        else if(section == 3)
        {
            [SettingManager shareSettingManager].isPoliticalParty = sender.isOn;
        }
        
        [self.tvDemographics reloadData];
    }
    
    [[SettingManager shareSettingManager] save];
}

- (void) onChangedText:(UITextField *)textField
{
    NSInteger value = [textField.text integerValue];
    
    NSInteger tag = textField.tag;
    
    NSInteger component = tag / 100;
    NSInteger section = (tag - 100 * component) / 10;
    NSInteger row = tag % 10;
    
    if(component == 0)
    {
        if(section == 0)
        {
            if(row == 0)
            {
                [SettingManager shareSettingManager].valueEX = value;
            }
            else
            {
                [SettingManager shareSettingManager].valueIN = value;
            }
        }
        else if(section == 1)
        {
            if(row == 0)
            {
                [SettingManager shareSettingManager].valueYE = value;
            }
            else
            {
                [SettingManager shareSettingManager].valueCN = value;
            }
        }
        else if(section == 2)
        {
            if(row == 0)
            {
                [SettingManager shareSettingManager].valueSE = value;
            }
            else
            {
                [SettingManager shareSettingManager].valueIN2 = value;
            }
        }
        else if(section == 3)
        {
            if(row == 0)
            {
                [SettingManager shareSettingManager].valueTH = value;
            }
            else
            {
                [SettingManager shareSettingManager].valueFE = value;
            }
        }
        else if(section == 4)
        {
            if(row == 0)
            {
                [SettingManager shareSettingManager].valuePE = value;
            }
            else
            {
                [SettingManager shareSettingManager].valueJU = value;
            }
        }
    }
    else
    {
        if(section == 0)
        {
            if(row == 0)
            {
                [SettingManager shareSettingManager].valueMale = value;
            }
            else
            {
                [SettingManager shareSettingManager].valueFemale = value;
            }
        }
        else if(section == 1)
        {
            if(row == 0)
            {
                [SettingManager shareSettingManager].value9th = value;
            }
            else if(row == 1)
            {
                [SettingManager shareSettingManager].valueSchool = value;
            }
            else if(row == 2)
            {
                [SettingManager shareSettingManager].valueCollege = value;
            }
            else if(row == 3)
            {
                [SettingManager shareSettingManager].valueAssociate = value;
            }
            else if(row == 4)
            {
                [SettingManager shareSettingManager].valueBachelor = value;
            }
            else if(row == 5)
            {
                [SettingManager shareSettingManager].valueMaster = value;
            }
            else if(row == 6)
            {
                [SettingManager shareSettingManager].valueDoctorate = value;
            }
        }
        else if(section == 2)
        {
            if(row == 0)
            {
                [SettingManager shareSettingManager].valueWhite = value;
            }
            else if(row == 1)
            {
                [SettingManager shareSettingManager].valueBlack = value;
            }
            else if(row == 2)
            {
                [SettingManager shareSettingManager].valueAslan = value;
            }
            else if(row == 3)
            {
                [SettingManager shareSettingManager].valueAmerican = value;
            }
            else if(row == 4)
            {
                [SettingManager shareSettingManager].valueMultiracial = value;
            }
            else if(row == 5)
            {
                [SettingManager shareSettingManager].valueHispanic = value;
            }
        }
        else if(section == 3)
        {
            if(row == 0)
            {
                [SettingManager shareSettingManager].valueRepublican = value;
            }
            else if(row == 1)
            {
                [SettingManager shareSettingManager].valueDemocrat = value;
            }
            else if(row == 2)
            {
                [SettingManager shareSettingManager].valueIndependent = value;
            }
        }
    }
    
    [[SettingManager shareSettingManager] save];
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"-"] && textField.text.length == 0)
        return YES;
    
    NSArray *aryNumbers = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @""];
    
    return [aryNumbers containsObject:string];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView.tag == 0)
        return 6;
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 0)
    {
        if(section == 0)
        {
            if([SettingManager shareSettingManager].isEXnotIN)
                return 2;
            else
                return 0;
        }
        else if(section == 1)
        {
            if([SettingManager shareSettingManager].isYEnotCN)
                return 2;
            else
                return 0;
        }
        else if(section == 2)
        {
            if([SettingManager shareSettingManager].isSEnotIN)
                return 2;
            else
                return 0;
        }
        else if(section == 3)
        {
            if([SettingManager shareSettingManager].isTHnotFE)
                return 2;
            else
                return 0;
        }
        else if(section == 4)
        {
            if([SettingManager shareSettingManager].isPEnotJU)
                return 2;
            else
                return 0;
        }
    }
    else if(tableView.tag == 1)
    {
        if(section == 0)
        {
            if([SettingManager shareSettingManager].isGender)
                return 2;
            else
                return 0;
        }
        else if(section == 1)
        {
            if([SettingManager shareSettingManager].isEducation)
                return 7;
            else
                return 0;
        }
        else if(section == 2)
        {
            if([SettingManager shareSettingManager].isEthnicity)
                return 6;
            else
                return 0;
        }
        else if(section == 3)
        {
            if([SettingManager shareSettingManager].isPoliticalParty)
                return 3;
            else
                return 0;
        }
    }
        
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGSize szCell = CGSizeMake(tableView.frame.size.width, 60);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, szCell.width, szCell.height)];
    view.backgroundColor = [UIColor whiteColor];
    
    UISwitch *switchView = [[UISwitch alloc] init];
    [switchView addTarget:self action:@selector(onChangeSwitch:) forControlEvents:UIControlEventValueChanged];
    switchView.tag = tableView.tag * 10 + section;
    switchView.center = CGPointMake(30, szCell.height / 2);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, szCell.width - 60, szCell.height)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"test";
    
    if(tableView.tag == 0)
    {
        if(section == 0)
        {
            switchView.on = [SettingManager shareSettingManager].isEXnotIN;
            label.text = @"Extrovert or Introvert";
        }
        else if(section == 1)
        {
            switchView.on = [SettingManager shareSettingManager].isYEnotCN;
            label.text = @"Yeilding or Controling";
        }
        else if(section == 2)
        {
            switchView.on = [SettingManager shareSettingManager].isSEnotIN;
            label.text = @"Sensor or Intuitor";
        }
        else if(section == 3)
        {
            switchView.on = [SettingManager shareSettingManager].isTHnotFE;
            label.text = @"Thinker or Feeler";
        }
        else if(section == 4)
        {
            switchView.on = [SettingManager shareSettingManager].isPEnotJU;
            label.text = @"Perciever or Judger";
        }
        else
        {
            return view;
        }
    }
    else
    {
        if(section == 0)
        {
            switchView.on = [SettingManager shareSettingManager].isGender;
            label.text = @"Gender";
        }
        else if(section == 1)
        {
            switchView.on = [SettingManager shareSettingManager].isEducation;
            label.text = @"Education";
        }
        else if(section == 2)
        {
            switchView.on = [SettingManager shareSettingManager].isEthnicity;
            label.text = @"Ethnicity";
        }
        else if(section == 3)
        {
            switchView.on = [SettingManager shareSettingManager].isPoliticalParty;
            label.text = @"Political Party";
        }
        else
        {
            return view;
        }
    }
    
    [view addSubview:switchView];
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize szCell = CGSizeMake(tableView.frame.size.width, 40);
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%d_%d",  indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 120, szCell.height)];
        label.tag = 1;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:16];
        
        [cell.contentView addSubview:label];
        
        UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(140, 8, 40, szCell.height - 2 * 8)];
        [text addTarget:self action:@selector(onChangedText:) forControlEvents:UIControlEventEditingChanged];
        text.tag = tableView.tag * 100 + indexPath.section * 10 + indexPath.row;
        text.backgroundColor = [UIColor lightGrayColor];
        text.textColor = [UIColor blackColor];
        text.borderStyle = UITextBorderStyleBezel;
        text.font = [UIFont systemFontOfSize:16];
        text.keyboardType = UIKeyboardTypeNumberPad;
        text.delegate = self;
        
        [cell.contentView addSubview:text];
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1];
    UITextField *text = nil;
    for (UIView *subview in cell.contentView.subviews) {
        if([subview isKindOfClass:[UITextField class]])
        {
            text = (UITextField *)subview;
            break;
        }
    }
    
    if(tableView.tag == 0)
    {
        if(indexPath.section == 0)
        {
            if(indexPath.row == 0)
            {
                label.text = @"Extrovert";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueEX];
            }
            else
            {
                label.text = @"Introvert";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueIN];
            }
        }
        else if(indexPath.section == 1)
        {
            if(indexPath.row == 0)
            {
                label.text = @"Yeilding";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueYE];
            }
            else
            {
                label.text = @"Controling";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueCN];
            }
        }
        else if(indexPath.section == 2)
        {
            if(indexPath.row == 0)
            {
                label.text = @"Sensor";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueSE];
            }
            else
            {
                label.text = @"Intuitor";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueIN2];
            }
        }
        else if(indexPath.section == 3)
        {
            if(indexPath.row == 0)
            {
                label.text = @"Thinker";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueTH];
            }
            else
            {
                label.text = @"Feeler";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueFE];
            }
        }
        else if(indexPath.section == 4)
        {
            if(indexPath.row == 0)
            {
                label.text = @"Perciever";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valuePE];
            }
            else
            {
                label.text = @"Judger";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueJU];
            }
        }
    }
    else
    {
        if(indexPath.section == 0)
        {
            if(indexPath.row == 0)
            {
                label.text = @"Male";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueMale];
            }
            else
            {
                label.text = @"Female";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueFemale];
            }
        }
        else if(indexPath.section == 1)
        {
            if(indexPath.row == 0)
            {
                label.text = @"9th Grade";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].value9th];
            }
            else if(indexPath.row == 1)
            {
                label.text = @"High School";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueSchool];
            }
            else if(indexPath.row == 2)
            {
                label.text = @"College";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueCollege];
            }
            else if(indexPath.row == 3)
            {
                label.text = @"Associate/Bachelor";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueAssociate];
            }
            else if(indexPath.row == 4)
            {
                label.text = @"Bachelor";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueBachelor];
            }
            else if(indexPath.row == 5)
            {
                label.text = @"Master";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueMaster];
            }
            else if(indexPath.row == 6)
            {
                label.text = @"Doctorate/Professional";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueDoctorate];
            }
        }
        else if(indexPath.section == 2)
        {
            if(indexPath.row == 0)
            {
                label.text = @"White";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueWhite];
            }
            else if(indexPath.row == 1)
            {
                label.text = @"Black";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueBlack];
            }
            else if(indexPath.row == 2)
            {
                label.text = @"Aslan/Pacific Islander";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueAslan];
            }
            else if(indexPath.row == 3)
            {
                label.text = @"American Indian/Alaska";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueAmerican];
            }
            else if(indexPath.row == 4)
            {
                label.text = @"Multiracial";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueMultiracial];
            }
            else if(indexPath.row == 5)
            {
                label.text = @"Hispanic";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueHispanic];
            }
        }
        else if(indexPath.section == 3)
        {
            if(indexPath.row == 0)
            {
                label.text = @"Republican";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueRepublican];
            }
            else if(indexPath.row == 1)
            {
                label.text = @"Democrat";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueDemocrat];
            }
            else if(indexPath.row == 2)
            {
                label.text = @"Independent";
                text.text = [NSString stringWithFormat:@"%d", [SettingManager shareSettingManager].valueIndependent];
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
