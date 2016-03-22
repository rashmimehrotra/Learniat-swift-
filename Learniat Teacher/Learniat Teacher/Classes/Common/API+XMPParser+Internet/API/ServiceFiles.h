//
//  ServiceFiles.h
//  Math
//
//  Created by mindshift_Deepak on 18/11/15.
//  Copyright © 2015 mindShiftApps. All rights reserved.
//


/* 
 
 room Name format =  room_(userName)_(questionId)_(date and Time)@conference.52.76.85.25
 
 */



#ifndef ServiceFiles_h
#define ServiceFiles_h
#import "NSData+Base64.h"

#define kBaseUrl                            @"http://54.251.104.13/Jupiter/sun.php"
#define kImageURL                            @"http://54.251.104.13/images/upload/"

#define kBaseXMPPURL                        @"52.76.85.25"
#define kWolframAppId                       @"8RTE4P-97XG3L8HPA"

#define kButtonColor                                            [UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0]
#define kBackGroundColor                                        [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0]
#define kTooBarColor                                            [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]
#define kSubCellSelectedColor                                   [UIColor colorWithRed:0/255.0 green:119/255.0 blue:162/255.0 alpha:1.0]
#define kWhiteColor                                             [UIColor whiteColor]
#define kTopImageViewColor                                      [UIColor colorWithRed:255.0/255.0 green:61.0/255.0 blue:0/255.0 alpha:1.0]
#define kTopImageViewBlueColor                                  [UIColor colorWithRed:17.0/255.0 green:171/255.0 blue:254/255.0 alpha:1.0]
#define kSeperatorColor                                         [UIColor colorWithRed:236.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0]
#define kSolutionColor                                          [UIColor colorWithRed:0/255.0 green:204.0/255.0 blue:0/255.0 alpha:1]
#define kAssumptionColor                                        [UIColor colorWithRed:77/255.0 green:153.0/255.0 blue:177/255.0 alpha:1]

#define kColumnName                                                 @"Column"
#define kRowName                                                    @"Row"
#define kMathEquationData                                           @"EquationData"
#define kMathImageData                                              @"ImageData"
#define kTagValue                                                   @"TagValue"
#define kRoomName                                                   @"RoomName"
#define kMathImageData                                              @"ImageData"
#define kStepState                                                  @"StepState"
#define kTagList                                                    @"listOfTags"
#define kQuestionName                                               @"QuestionName"
#define kStepWidth                                                  @"stepWidth"
#define kTextData                                                   @"TextData"

#define kStepCorrect                                                @"Correct"
#define kStepWrong                                                  @"Wrong"

#define kTeacherAnnotationData                                      @"TeacherAnnotation"
#define kAvailable                                                  @"available"
#define kUnavailable                                                @"unavailable"


#define kAssumption                                                 @"Assumption"
#define kSolution                                                   @"Solution"


#define	kSunstone                                                   @"SunStone"
#define	kSSAction                                                   @"Action"
#define kStatus                                                     @"Status"
#define kFullUserName                                               @"FullUsername"
#define kHalfUserName                                               @"halfUsername"
#define kPassword                                                    @"Password"

#define kSpaceBwBox                                                     10
#define kRowWidth                                                       664
#define kRowHeightWithSpace                                             100
#define kRowHeight                                                      90
#define kImageHeight                                                    80
#define kMiniumImageSize                                                30
#define km_MediumImageSize                                              60
#define kMediumImageSize                                                40
#define kMaxImageSize                                                   90

#define kdensityMinium                                                   2
#define kDensityMedium                                                   3
#define kDensitym_medium                                                 5

#define kStudentFree                                                @"Free"
#define kStudentSoloWorking                                         @"Solo Working"
#define kStudentNeedHelp                                            @"Need Help"
#define kStudentTeacherHelping                                      @"Teacher Helping"
#define kCommentsData                                               @"CommentsData"
#define kAudioPath                                                  @"AudioPath"


#define kServiceGetAllNodes                                         @"GetAllNodes"
#define kServiceRecordSuggestion                                    @"RecordSuggestion"
#define kServiceGetSuggestionState                                  @"GetSuggestionState"
#define kServiceRecordSuggestion                                    @"RecordSuggestion"
#define kServiceGetMathEquation                                     @"GetMathEquation"
#define kServiceCheckEquality                                       @"checkEquality"


#endif /* ServiceFiles_h */
