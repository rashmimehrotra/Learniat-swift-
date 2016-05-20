//
//  ImageEditorSubView.h
//  EditorView
//
//  Created by mindshift_Deepak on 07/11/15.
//  Copyright © 2015 mindShiftApps. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    TextType,
    EquationType,
    ShapesType,
} TypeOfImage;


@interface ImageEditorSubView : UIView
{
    BOOL                isResizingLR;
    
    BOOL                isResizingUL;
    
    BOOL                isResizingUR;
    
    BOOL                isResizingLL;
    
    CGPoint             touchStart;
    
    UIImageView         *imageview;
    
    BOOL                preventsPositionOutsideSuperview;
    
    UIView              *mCountainerView;
    
    UIButton            *mEditButton;
    
    UIButton            *mResizeButton;
    
    UIButton            *mDeleteButton;
    
    TypeOfImage         currentImageType;
    
    NSData*             m_binaryValue;

    id                  _delgate;
    
    BOOL                isEditing;
    
    BOOL                isResizing;
    
}
@property (nonatomic) NSString* typeString;

- (void) setdelegate:(id)delegate;

- (id)   delegate;

- (void)setContentImageView:(UIImageView*)_contentView withImage:(UIImage*)image;

- (void)setTypeOfImage:(TypeOfImage)type;

- (TypeOfImage)getCurrentTypeOfImage;

- (void) setBinaryValue:(NSData*)binaryValue;

- (NSData*)getBinarayData;

- (void) onEditButton:(id)sedner;

- (void) onDeleteButton:(id)sender;

- (void) showHandles;

- (void) hideHandles;

- (void) onResizeButton:(id)sender;

@end

@protocol ImageEditorSubViewDelegate <NSObject>

- (void) delegateSelectPressedWithView:(ImageEditorSubView*)editorView withSelectedState:(BOOL)selectedState;

@optional - (void) delegateEditButtonPressedWithView:(ImageEditorSubView*)editorView;

@optional - (void) delegateDeleteDeleteButtonPressedWithView:(ImageEditorSubView*)editorView;


@end






