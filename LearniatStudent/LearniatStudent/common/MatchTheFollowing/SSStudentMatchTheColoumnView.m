//
//  SSStudentMatchTheColoumnView.m
//  Learniat Teacher
//
//  Copyright (c) 2015 Mindshift Applications and Solutions Private Ltd. All rights reserved.
//

#import "SSStudentMatchTheColoumnView.h"
#import "UIView+SubviewHunting.h"
@implementation SSStudentMatchTheColoumnView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        mAnswerFreezed = NO;
        firstColoumnArray=[[NSMutableArray alloc] init];
        secondColoumnArray=[[NSMutableArray alloc] init];
        
        [self setUserInteractionEnabled:YES];
        
        
        
        
    }
    return self;
}

- (void) setDelegate:(id)delegate
{
    _delegate=delegate;
}
- (id)delegate
{
    return _delegate;
}


- (void)updateMatchColoumnQuestionDict:(id)dict
{
    QuestionType=[dict objectForKey:@"QuestionType"];
    mLeftSequenceArray =[[NSMutableArray alloc]init];
    mRightSequenceArray =[[NSMutableArray alloc]init];
    
    
   NSMutableArray* questionArray=[[dict objectForKey:@"OptionContainer"] objectForKey:@"Option"];
    
    for (int i=0; i< [questionArray count]; i++)
    {
        id details= [questionArray objectAtIndex:i];
        int sequence = [[details objectForKey:@"Sequence"] intValue];
        if ([[details objectForKey:@"Column"] isEqualToString:@"1"])
        {
             [mLeftSequenceArray addObject:[NSString stringWithFormat:@"%d",sequence]];
            [firstColoumnArray addObject:details];
        }
        else
        {
            [mRightSequenceArray addObject:[NSString stringWithFormat:@"%d",sequence]];
            [secondColoumnArray addObject:details];
        }
    }
    
    
    if (!fullOptionsArray)
    {
        fullOptionsArray = [[NSMutableArray alloc] init];
    }
    
    for (int i =0 ; i< firstColoumnArray.count; i++)
    {
        
        id leftOption = [firstColoumnArray objectAtIndex:i];
        id rightOPtion = [secondColoumnArray objectAtIndex:i];
        
        
        NSMutableDictionary* dictonary = [[NSMutableDictionary alloc] init];
        [dictonary setObject:[NSString stringWithFormat:@"%@->%@",[leftOption objectForKey:@"OptionText"],[rightOPtion objectForKey:@"OptionText"]] forKey:@"OptionText"];
        [dictonary setObject:[leftOption objectForKey:@"OptionId"] forKey:@"OptionId"];
        [dictonary setObject:[NSString stringWithFormat:@"2"] forKey:@"IsAnswer"];
        
        
        [fullOptionsArray addObject:dictonary];
        
    }
    
    
    
    
    NSUInteger count = [secondColoumnArray count];
    for (uint i = 0; i < count; ++i)
    {
        // Select a random element between i and end of array to swap with.
        int nElements = (int)(count - i);
        int n = arc4random_uniform(nElements) + i;
        [secondColoumnArray exchangeObjectAtIndex:i withObjectAtIndex:n];
        [mRightSequenceArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    firstColoumnTableView = [[NoShadowTableView alloc] initWithFrame:CGRectMake(0, 0,(self.frame.size.width/2)-30 , self.frame.size.height)];
    [firstColoumnTableView setDelegate:self];
    [firstColoumnTableView setDataSource:self];
    [firstColoumnTableView setTag:2];
    [self addSubview:firstColoumnTableView];
    firstColoumnTableView.separatorColor=[UIColor whiteColor];
    firstColoumnTableView.showsVerticalScrollIndicator=NO;
    firstColoumnTableView.showsHorizontalScrollIndicator=NO;
    
    
    StatusView=[[NoShadowTableView alloc] initWithFrame:CGRectMake(firstColoumnTableView.frame.origin.x + firstColoumnTableView.frame.size.width, 0, 60, self.frame.size.height)];
    [StatusView setBackgroundColor:[UIColor clearColor]];
    [StatusView setDelegate:self];
    [StatusView setDataSource:self];
    [self addSubview:StatusView];
    [StatusView setUserInteractionEnabled:NO];
    StatusView.separatorColor=[UIColor whiteColor];
    
    
    secondColoumntableView = [[NoShadowTableView alloc] initWithFrame:CGRectMake(StatusView.frame.origin.x + StatusView.frame.size.width, 0, firstColoumnTableView.frame.size.width, firstColoumnTableView.frame.size.height)];
    [secondColoumntableView setDelegate:self];
    [secondColoumntableView setDataSource:self];
    [secondColoumntableView setTag:3];
    [secondColoumntableView setEditing:TRUE animated:TRUE];
    [self addSubview:secondColoumntableView];
    [secondColoumntableView setScrollEnabled:NO];
    
    secondColoumntableView.separatorColor=[UIColor whiteColor];
//    secondColoumntableView.backgroundColor = [UIColor greenColor];
//    firstColoumnTableView.backgroundColor = [UIColor yellowColor];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    UITableView *slaveTable = nil;
    UITableView	*slaveTable1= nil; 
    
    if (secondColoumntableView.editing)
    {
        if (secondColoumntableView == scrollView)
        {
            slaveTable = firstColoumnTableView;
        }
        [slaveTable setContentOffset:scrollView.contentOffset];
    }

    if (firstColoumnTableView == scrollView)
    {
        

        slaveTable = secondColoumntableView;
    }
    [slaveTable setContentOffset:scrollView.contentOffset];
    if(secondColoumntableView==scrollView)
    {
    	slaveTable1= StatusView;
    }
    [slaveTable1 setContentOffset:scrollView.contentOffset];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [firstColoumnArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 140;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    matchColoumnTableViewCell *cell = (matchColoumnTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"matchColoumnTableViewCell"];
    if (cell == nil)
    {
        cell = [[matchColoumnTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"matchColoumnTableViewCell"];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
    }
    
    if(tableView.tag==2)
    {
        
        id dict=[firstColoumnArray objectAtIndex:indexPath.row];
        
        cell.optionLabel.text = [dict objectForKey:@"OptionText"];
        cell.optionButton.titleLabel.text = [dict objectForKey:@"OptionText"];
    }
    
    else if(tableView.tag==3)
    {
        id dict=[secondColoumnArray objectAtIndex:indexPath.row];
        cell.optionLabel.text = [dict objectForKey:@"OptionText"];
        cell.optionButton.titleLabel.text = [dict objectForKey:@"OptionText"];
    }
    else
    {
        cell.optionLabel.hidden=YES;
        cell.optionButton.hidden=YES;
    }
    
   
    
    if (mAnswerFreezed == true) {
        [self setAnswerStatusWithIndex:(int)indexPath.row];
    }
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSString *stringToMove = [secondColoumnArray objectAtIndex:sourceIndexPath.row];
    
    [secondColoumnArray removeObjectAtIndex:sourceIndexPath.row];
    
    [secondColoumnArray insertObject:stringToMove atIndex:destinationIndexPath.row];
    
    NSString *stringToMove2 = [mRightSequenceArray objectAtIndex:sourceIndexPath.row];
    
    [mRightSequenceArray removeObjectAtIndex:sourceIndexPath.row];
    
    [mRightSequenceArray insertObject:stringToMove2 atIndex:destinationIndexPath.row];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView willBeginReorderingRowAtIndexPath:(NSIndexPath *)indexPath
{
    matchColoumnTableViewCell* cell = (matchColoumnTableViewCell*)[tableView cellForRowAtIndexPath:indexPath ];
    [cell.optionButton setBackgroundColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0]];
   cell.optionButton.layer.borderColor=[ [UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] CGColor];
//    [cell.optionLabel setTextColor:[UIColor whiteColor]];
    
    for (int i = 0; i < [tableView numberOfSections]; i++)
    {
        for (int j = 0; j < [tableView numberOfRowsInSection:i]; j++)
        {
            
            NSUInteger ints[2] = {i,j};
            NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:ints length:2];
            matchColoumnTableViewCell *leftSideCell = (matchColoumnTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            if (leftSideCell!=cell)
            {
                [leftSideCell.optionButton setBackgroundColor:[UIColor whiteColor]];
                leftSideCell.optionButton.layer.borderColor=[[UIColor colorWithRed:46/255.0 green:88.0/255.0 blue:128.0/255.0 alpha:1.0] CGColor];
                [leftSideCell.optionLabel setTextColor:[UIColor colorWithRed:46/255.0 green:88.0/255.0 blue:128.0/255.0 alpha:1.0]];
            }
            
        }
    }
    
    
    [firstColoumnTableView setContentOffset:tableView.contentOffset animated:YES];

}

- (void)tableView:(UITableView *)tableView didEndReorderingRowAtIndexPath:(NSIndexPath *)indexPath
{
    matchColoumnTableViewCell* cell = (matchColoumnTableViewCell*)[tableView cellForRowAtIndexPath:indexPath ];
    [cell.optionLabel setTextColor:[UIColor whiteColor]];
    for (int i = 0; i < [tableView numberOfSections]; i++)
    {
        for (int j = 0; j < [tableView numberOfRowsInSection:i]; j++)
        {
            
            NSUInteger ints[2] = {i,j};
            NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:ints length:2];
            matchColoumnTableViewCell *leftSideCell = (matchColoumnTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//            if (leftSideCell!=cell)
            {
                [leftSideCell.optionButton setBackgroundColor:[UIColor whiteColor]];
                leftSideCell.optionButton.layer.borderColor=[[UIColor colorWithRed:46/255.0 green:88.0/255.0 blue:128.0/255.0 alpha:1.0] CGColor];
                [leftSideCell.optionLabel setTextColor:[UIColor colorWithRed:46/255.0 green:88.0/255.0 blue:128.0/255.0 alpha:1.0]];
            }
            
        }
    }


}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if(isAnswerSent)
    //	Grip customization code goes in here...
	UIView* reorderControl = [cell huntedSubviewWithClassName:@"UITableViewCellReorderControl"];
	
	UIView* resizedGripView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(reorderControl.frame), CGRectGetMaxY(reorderControl.frame))];
	[resizedGripView addSubview:reorderControl];
	[cell addSubview:resizedGripView];
	
	CGSize sizeDifference = CGSizeMake(resizedGripView.frame.size.width - reorderControl.frame.size.width, resizedGripView.frame.size.height - reorderControl.frame.size.height);
	CGSize transformRatio = CGSizeMake(resizedGripView.frame.size.width / reorderControl.frame.size.width, resizedGripView.frame.size.height / reorderControl.frame.size.height);
	
	//	Original transform
	CGAffineTransform transform = CGAffineTransformIdentity;
	
	//	Scale custom view so grip will fill entire cell
	transform = CGAffineTransformScale(transform, transformRatio.width, transformRatio.height);
	
	//	Move custom view so the grip's top left aligns with the cell's top left
	transform = CGAffineTransformTranslate(transform, -sizeDifference.width / 2.0, -sizeDifference.height / 2.0);
	
	[resizedGripView setTransform:transform];
	
	for(UIImageView* cellGrip in reorderControl.subviews)
	{
		if([cellGrip isKindOfClass:[UIImageView class]])
			[cellGrip setImage:nil];
	}
    
}
- (void) layoutSubviews
{
	[super layoutSubviews];
    
	//	iOS7
	for(UIView* subview in secondColoumntableView.subviews)
	{
		if([[[subview class] description] isEqualToString:@"UIShadowView"])
			[subview setHidden:YES];
	}
}

- (NSString*)onSendButton
{
    
    
    sendButtonPressed=YES;
    
     NSString *selectedoptionsList = [mRightSequenceArray componentsJoinedByString:@";;;"];
    [secondColoumntableView setEditing:NO];
    [secondColoumntableView reloadData];
    
    if([QuestionType isEqualToString:@"Match Columns"])
    {
        
       
        
//        [[SSStudentDataSource sharedDataSource] sendAnswer:[NSDictionary dictionaryWithObjectsAndKeys:selectedoptionsList,@"sequence",@"Match Columns",@"QuestionType", nil] withDelegate:self];
        
      
        
        
    }
    
    return selectedoptionsList;
    
}

- (void) didGetAnswerSentWithDetails:(id) details orError:(NSError *) error
{
    
}
- (void)onDontKnowButton
{
    
    
    sendButtonPressed=YES;
    
    if([QuestionType isEqualToString:@"Match Columns"])
    {
        [secondColoumntableView setEditing:NO];
        [secondColoumntableView reloadData];
    }
    
}


- (void) FreezMessageFromTeacher
{
    mAnswerFreezed = YES;
    
    for (int i=0; i< [mLeftSequenceArray count]; i++)
    {
        [self setAnswerStatusWithIndex:i];
    }
}


- (void) setAnswerStatusWithIndex:(int)index {
    NSString* rightSequence= [mRightSequenceArray objectAtIndex:index];
    NSString* leftSequenceSequence= [mLeftSequenceArray objectAtIndex:index];
    NSIndexPath* indexpath = [NSIndexPath indexPathForRow:index inSection:0];
    
    matchColoumnTableViewCell* rightSideCell = (matchColoumnTableViewCell*)[secondColoumntableView cellForRowAtIndexPath:indexpath ];
   
    matchColoumnTableViewCell* leftSideCell = (matchColoumnTableViewCell*)[firstColoumnTableView cellForRowAtIndexPath:indexpath ];
    
    matchColoumnTableViewCell* statusImageView = (matchColoumnTableViewCell*)[StatusView cellForRowAtIndexPath:indexpath ];
    [leftSideCell.optionLabel setTextColor:[UIColor colorWithRed:46/255.0 green:88.0/255.0 blue:128.0/255.0 alpha:1.0]];
    [rightSideCell.optionLabel setTextColor:[UIColor colorWithRed:46/255.0 green:88.0/255.0 blue:128.0/255.0 alpha:1.0]];
    
    NSLog(@"%@",rightSideCell.optionLabel.text);
    
    
    if ([rightSequence isEqualToString:leftSequenceSequence])
    {
        [rightSideCell.optionButton setBackgroundColor:[UIColor whiteColor]];
        rightSideCell.optionButton.layer.borderColor=[ [UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:1.0] CGColor];
        
        [leftSideCell.optionButton setBackgroundColor:[UIColor whiteColor]];
        leftSideCell.optionButton.layer.borderColor=[ [UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:1.0] CGColor];
        [statusImageView.statusImageView setHidden:NO];
        [statusImageView.statusImageView setImage:[UIImage imageNamed:@"correctMatch.png"]];
    }
    else
    {
        [rightSideCell.optionButton setBackgroundColor:[UIColor whiteColor]];
        rightSideCell.optionButton.layer.borderColor=[ [UIColor colorWithRed:255.0/255.0 green:59.0/255.0 blue:48.0/255.0 alpha:1.0] CGColor];
        
        [leftSideCell.optionButton setBackgroundColor:[UIColor whiteColor]];
        leftSideCell.optionButton.layer.borderColor=[ [UIColor colorWithRed:255.0/255.0 green:59.0/255.0 blue:48.0/255.0 alpha:1.0] CGColor];
        [statusImageView.statusImageView setHidden:NO];
        [statusImageView.statusImageView setImage:[UIImage imageNamed:@"wrongMatch.png"]];
    }
}




- (void)questionClearedByTeacher
{
   mAnswerFreezed = NO;
}
- (NSMutableArray*)getOptionsArray
{
    return fullOptionsArray;
}

@end
