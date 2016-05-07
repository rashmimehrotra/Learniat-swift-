//
//  GWGeometryView.h
//  GeometryWidget
//
//  Copyright (c) 2014 Vision Objects. All rights reserved.
//


#import "GWDefines.h"
#import <UIKit/UIKit.h>

@class GWGeometryView;

/**
 * The GWGeometryViewDelegate protocol defines the methods you can implement to be notified of
 * the activity of a GWGeometryView object.
 * These methods allow to monitor events such as configuration, recognition or a change in the Undo
 * Redo stack.
 *
 * All of the methods in this protocol are optional.
 **/
@protocol GWGeometryViewDelegate <NSObject>

@optional

#pragma mark - Configuration

/** @name Monitoring Configuration */

/**
 * Tells the delegate that the Geometry Widget has started its configuration.
 * @param geometryView The geometry view that has started its configuration.
 */
- (void)geometryViewDidBeginConfiguration:(GWGeometryView *)geometryView;

/**
 * Tells the delegate that the Geometry Widget has end its configuration with success.
 * @param geometryView The geometry view that has ended its configuration.
 */
- (void)geometryViewDidEndConfiguration:(GWGeometryView *)geometryView;

/**
 * Tells the delegate that the Geometry Widget has failed its configuration.
 * @param geometryView The geometry view that has failed its configuration.
 * @param error              An NSError object that encapsulates information why configuration
 *                           failed.
 */
- (void)geometryView:(GWGeometryView *)geometryView didFailConfigurationWithError:(NSError *)error;

#pragma mark - Recognition

/** @name Monitoring Recognition Progress */

/**
 * Tells the delegate that the Geometry Widget has begun a recognition session.
 * @param geometryView The geometry view that has begun a recognition process.
 * @discussion A recognition session starts when the user starts writing on the screen.
 *             The session can also start after an undo or redo or a after any context restoration
 *             such as screen rotation.
 */
- (void)geometryViewDidBeginRecognition:(GWGeometryView *)geometryView;

/**
 * Tells the delegate that the Geometry Widget has ended a recognition process.
 * @param geometryView The geometry view that has ended a recognition process.
 */
- (void)geometryViewDidEndRecognition:(GWGeometryView *)geometryView;

#pragma mark - Undo Redo

/** @name Monitoring Changes in Undo Redo Stack */

/**
 * Tells the delegate that the Geometry Widget Undo/Redo stack has changed.
 * @param geometryView The geometry view whose Undo/Redo stack has changed.
 */
- (void)geometryViewDidChangeUndoRedoState:(GWGeometryView *)geometryView;

#pragma mark - Writing

/** @name Monitoring User Input */

/**
 * Tells the delegate that geometry user has started touching the screen.
 * @param geometryView The geometry view receiving touches.
 */
- (void)geometryViewDidBeginWriting:(GWGeometryView *)geometryView;

/**
 * Tells the delegate that the user has ending touching the screen.
 * @param geometryView The geometry view that has stopped receiving touches.
 */
- (void)geometryViewDidEndWriting:(GWGeometryView *)geometryView;

#pragma mark - Edition

/**
 * Tells the delegate the user starts editing length value constraint.
 * @param geometryView The geometry view that has received length value edition.
 * @param value Current value for the item
 * @param position Current position for the edited item
 * @param uniqueId Unique Id of the item
 */
- (void)geometryViewDidBeginEditingLengthValue:(GWGeometryView *)geometryView existingValue:(float)value position:(CGPoint)position uniqueId:(int64_t)uniqueId;

/**
 * Tells the delegate the user starts editing angle value constraint.
 * @param geometryView The geometry view that has received angle value edition.
 * @param value Current value for the item
 * @param position Current position for the edited item
 * @param uniqueId Unique Id of the item
 */
- (void)geometryViewDidBeginEditingAngleValue:(GWGeometryView *)geometryView existingValue:(float)value position:(CGPoint)position uniqueId:(int64_t)uniqueId;

/**
 * Tells the delegate the user starts editing label (dot primitive).
 * @param geometryView The geometry view that has received dot primitive edition.
 * @param label Current label for the item
 * @param position Current position for the edited item
 * @param uniqueId Unique Id of the item
 */
- (void)geometryViewDidBeginEditingLabel:(GWGeometryView *)geometryView existingLabel:(NSString*)label position:(CGPoint)position uniqueId:(int64_t)uniqueId;


@end

/**
 * The `GWGeometryView` is the entry point of the Geometry Widget.
 */
@interface GWGeometryView : UIView

#pragma mark - Certificate Configuration

/** @name Register the certificate */

/**
 * Register MyScript engine certificate.
 *
 *  @param certificate The data object containing the certificate.
 *
 *  @return `YES` if the certificate is registered,
 *  `NO` on failure or if a certificate is already registered.
 */
- (BOOL)registerCertificate:(NSData *)certificate;

#pragma mark - Engine Configuration

/** @name Configuring the Engine */

/** Add given directory to handwriting resources search path.
 * Directory name can point to a folder in the file system, or to a
 * directory in a zip file.
 *
 * @param directoryName Path to a folder containing handwriting resources.
 */
- (void)addSearchDir:(NSString *)directoryName;

/**
 *  Clear handwriting resources search path.
 */
- (void)clearSearchPath;

/** Configure handwriting recognition engine.
 * This method is non-blocking and returns immediately.
 *
 * Configuration is a lengthy process that may take up to several
 * seconds, depending on the handwriting resources to be configured.
 * It is recommended to setup a configuration listener to detect the end
 * of the configuration process.
 *
 *  @param bundleName Name of the configuration bundle (for example, "shape").
 *  @param configName Name of the configuration mode (for example, "standard").
 */
- (void)configureWithBundle:(NSString *)bundleName andConfig:(NSString *)configName;


#pragma mark - Delegate

/**
 * The receiver’s delegate or nil if it doesn’t have a delegate.
 * @discussion See GWGeometryViewDelegate for the methods this delegate can implement.
 */
@property (assign, nonatomic) id <GWGeometryViewDelegate> delegate;


#pragma mark - Constraints management

/** @name Managing detection and display for implicit and explicit constraints */

/**
 *  Returns the constraints for which the specified behavior is active.
 *  @param behavior The behavior
 *  @return An integer bit mask that determines the constraints for which the specified behavior is
 *          active.
 */
- (GWConstraint)enabledConstraintsForBehavior:(GWConstraintBehavior)behavior;

/**
 *  Enable or disable detection and display of implicit and explicit constraints.
 *  @param enabled     A boolean specifying if the constraints should be enabled or disabled
 *  @param constraints An integer bit mask that determines the affected constraints
 *  @param behavior    The affected behavior
 *  @discussion Use this method to enable or disable detection and display of implicit and explicit
 *  constraints.
 *  For example, to enable display of explicit angle equalities and perpendicularities,
 *  call:
 *  `[geometryView setConstraintsEnabled:YES constraints:GWConstraintAngleValue |
 *  GWConstraintPerpendicularity forBehavior:GWConstraintBehaviorExplicitDisplay]`.
 */
- (void)setConstraintsEnabled:(BOOL)enabled
                  constraints:(GWConstraint)constraints
                  forBehavior:(GWConstraintBehavior)behavior;

#pragma mark - Parameters

/**
 *  Returns state for the specified GWBoolParameter key.
 *  @param key see type GWBoolParameter.
 *  @return Boolean that determines state for the specified GWBoolParameter key.
 */
- (BOOL)boolValueForParameter:(GWBoolParameter)key;
/**
 *  Set the state for the specified GWBoolParameter key.
 *  @param boolValue A boolean specifying the state for the specified GWBoolParameter key.
 *  @param key see type GWBoolParameter.
 */
- (void)setBoolValue:(bool)boolValue forParameter:(GWBoolParameter)key;

/**
 *  Returns value for the specified GWFloatParameter key.
 *  @param key see type GWFloatParameter.
 *  @return Float that determines state for the specified GWFloatParameter key.
 */
- (CGFloat)floatValueForParameter:(GWFloatParameter)key;
/**
 *  Returns the minimun value allowed for the specified GWFloatParameter key.
 *  @param key see type GWFloatParameter.
 *  @return Float that determines the minimun value allowed for the specified GWFloatParameter key.
 */
- (CGFloat)floatMinValueForParameter:(GWFloatParameter)key;
/**
 *  Returns the maximun value allowed for the specified GWFloatParameter key.
 *  @param key see type GWFloatParameter.
 *  @return Float that determines the minimun value allowed for the specified GWFloatParameter key.
 */
- (CGFloat)floatMaxValueForParameter:(GWFloatParameter)key;
/**
 *  Set the value for the specified GWFloatParameter key.
 *  @param floatValue A float specifying the value for the specified GWFloatParameter key.
 *  @param key see type GWFloatParameter.
 */
- (void)setFloatValue:(CGFloat)floatValue forParameter:(GWFloatParameter)key;

#pragma mark - Undo Redo

/**
 * Returns a Boolean value that indicates whether the Geometry Widget has any actions to undo.
 * @return `YES` if the Geometry Widget has any actions to undo, otherwise `NO`.
 */
- (BOOL)canUndo;

/**
 * Returns a Boolean value that indicates whether the Geometry Widget has any actions to redo.
 * @return `YES` if the Geometry Widget has any actions to redo, otherwise `NO`.
 */
- (BOOL)canRedo;

/**
 * Performs one undo step.
 */
- (void)undo;

/**
 * Performs one redo step.
 */
- (void)redo;

#pragma mark - Items management

/**
 * Clears all primitives & constraints.
 * @param allowUndo YES to allow the undo, NO otherwise.
 */
- (void)clear:(BOOL)allowUndo;


#pragma mark - Items management

/** @name Managing items */


/**
 * Returns a Boolean value that indicates whether the Geometry Widget contains items (primitives or constraints).
 * @return `YES` if the Geometry Widget does not contain any items, otherwise `NO`.
 */
@property (assign, nonatomic, readonly) BOOL isEmpty;


/**
 * Set the value of a given item.
 *
 * @param value New value for the item.
 * @param uniqueId Unique Id of the item.
 */
- (void)setValue:(float)value uniqueId:(int64_t)uniqueId;

/**
 * Set the label of a given item.
 *
 * @param label New label for the the item.
 * @param uniqueId Unique Id of the item.
 *
 */
- (void)setEditLabel:(NSString*)label uniqueId:(int64_t)uniqueId;

#pragma mark - Appearance

/** @name Customizing Appearance */

/**
 * Background view of the writing area.
 * @discussion The view is automatically resized to match the size of the Geometry Widget View.
 *
 * The default background view is a `UIImageView` displaying a graph paper pattern. You can set this
 * property to `nil` to remove the background.
 */
@property (strong, nonatomic) UIView *backgroundView;


#pragma mark - Ink
/**
 * Color style of the ink:
 *
 * 1) in styles.css add your color sub style :
 * .primitiveMyColor
 * {
 *   color: #123456ff;
 * }
 *
 * 2) use/select your color sub style like this:
 * widget.inkColor = @"primitiveMyColor"
 *
 * @discussion If new color sub style is invalid, current color sub style will be unchanged.
 */
@property (strong, nonatomic) NSString *inkColor;

/**
 * Thickness style of the ink.
 *
 * 1) in styles.css add your thickness sub style :
 * .primitiveMyThickness
 * {
 *   -myscript-pen-width:1.6;
 * }
 *
 * 2) use/select your thickness sub style like this:
 * widget.inkThickness = @"primitiveMyThickness"
 *
 * @discussion If new thickness sub style is invalid, current thickness sub style will be unchanged.
 */
@property (assign, nonatomic) NSString * inkThickness;


/**
 * Dash aspect for the ink.
 * False : The ink is not dashed (default).
 * True  : The ink is dashed.
 *
 * @discussion The default value of this property is `NO`.
 */
@property (assign, nonatomic) BOOL inkDashed;


#pragma mark - Output

/** @name Exporting Geometry drawing */

/**
 * Get the geometry drawing as an image.
 * @return A UIImage similar to what is is displayed by the Geometrys Widget.
 */
- (UIImage *)resultAsImage;

#pragma mark - Palm rejection

/** @name Ignoring Unwanted Touches */

/**
 * A Boolean value that determines whether the Geometry Widget should ignore unwanted touches caused by
 * the user palm.
 *
 * @discussion The default value of this property is `YES`.
 */
@property (assign, nonatomic) BOOL palmRejectionEnabled;

/**
 * A Boolean value that determines whether the Geometry Rejection should be configured for left handed
 * users.
 *
 * @discussion The default value of this property is `NO`.
 */
@property (assign, nonatomic) BOOL palmRejectionLeftHanded;


#pragma mark - Serialization

/** @name Saving and Restoring recognitions results */

/**
 * Serialize the current input.
 * @discussion This method can be used to save an equation as binary data.
 * @return A data object containing the serialized equation.
 */
- (NSData *)serialize;

/**
 * Restore an input saved using the `serialize` method.
 * @param      data The data to unserialize, provided by `serialize`.
 * @return     `YES` if the data was properly unserialized, `NO` otherwise.
 * @discussion This method can be used to restore an equation from binary data.
 */
- (BOOL)unserialize:(NSData *)data;

@end
