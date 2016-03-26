
/*
     File: RFImageToDataTransformer.m
 Abstract: A value transformer, which transforms a UIImage or NSImage object into an NSData object.
 
 Based on Apple's UIImageToDataTransformer
 
 //  Copyright (c) 2014 Mindshift applications and solutions Private Ltd. All rights reserved.
 */

#import "RFImageToDataTransformer.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else

#endif


@implementation RFImageToDataTransformer

+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}

- (id)transformedValue:(id)value {
#if TARGET_OS_IPHONE
  return UIImagePNGRepresentation(value);
#else
  return [(NSImage *)value TIFFRepresentation];
#endif
}

- (id)reverseTransformedValue:(id)value {
#if TARGET_OS_IPHONE
	return [[UIImage alloc] initWithData:value];
#else
	return [[NSImage alloc] initWithData:value];
#endif
}

@end

