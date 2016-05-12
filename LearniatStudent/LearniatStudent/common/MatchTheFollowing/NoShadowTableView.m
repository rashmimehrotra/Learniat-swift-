//
//  NoShadowTableView.m
//  NoShadowTable
//
//  Created by Mindshift applications and solutions Private Ltd on 6/11/2013.
//
//

#import "NoShadowTableView.h"

@interface NoShadowTableView ()
{
	//	iOS7
	__weak UIView* wrapperView;
}

@end

@implementation NoShadowTableView

- (void) didAddSubview:(UIView *)subview
{
	[super didAddSubview:subview];
	
	//	iOS7
	if(wrapperView == nil && [[[subview class] description] isEqualToString:@"UITableViewWrapperView"])
		wrapperView = subview;
	
	//	iOS6
	if([[[subview class] description] isEqualToString:@"UIShadowView"])
		[subview setHidden:YES];
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	//	iOS7
	for(UIView* subview in wrapperView.subviews)
	{
		if([[[subview class] description] isEqualToString:@"UIShadowView"])
			[subview setHidden:YES];
	}
}

@end
