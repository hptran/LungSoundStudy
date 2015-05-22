// 
//  APHPhonationTaskViewController.m 
//  mPower 
// 
// Copyright (c) 2015, Sage Bionetworks. All rights reserved. 
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
// 
// 1.  Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
// 
// 2.  Redistributions in binary form must reproduce the above copyright notice, 
// this list of conditions and the following disclaimer in the documentation and/or 
// other materials provided with the distribution. 
// 
// 3.  Neither the name of the copyright holder(s) nor the names of any contributors 
// may be used to endorse or promote products derived from this software without 
// specific prior written permission. No license is granted to the trademarks of 
// the copyright holders even if such marks are included in this software. 
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE 
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
// 
 
#import "APHPhonationTaskViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <APCAppCore/APCAppCore.h>
#import "PDScores.h"
#import "APHIntervalTappingRecorderDataKeys.h"
#import "APHAppDelegate.h"

static NSString *const kTaskName                              = @"Lung Sound";

    //
    //        Step Identifiers
    //
static  NSString *const kInstructionStepIdentifier            = @"instruction";
static  NSString *const kInstruction1StepIdentifier           = @"instruction1";
static  NSString *const kCountdownStepIdentifier              = @"countdown";
static  NSString *const kAudioStepIdentifier                  = @"audio";
static  NSString *const kConclusionStepIdentifier             = @"conclusion";

static NSString *const kMomentInDayStepIdentifier             = @"momentInDay";

static NSString *const kMomentInDayFormat                     = @"momentInDayFormat";

static NSString *const kMomentInDayFormatTitle                = @"Specify the position that you record lung sound and then click Next at the bottom";

static NSString *const kInstructionRecordingLungSound         = @"";
static NSString *const kAnteriorChestWall1     = @"Anterior chest wall: 1";
static NSString *const kAnteriorChestWall2     = @"Anterior chest wall: 2";
static NSString *const kAnteriorChestWall3     = @"Anterior chest wall: 3";
static NSString *const kAnteriorChestWall4     = @"Anterior chest wall: 4";
static NSString *const kAnteriorChestWall5     = @"Anterior chest wall: 5";
static NSString *const kAnteriorChestWall6     = @"Anterior chest wall: 6";
static NSString *const kAnteriorChestWall7     = @"Anterior chest wall: 7";
static NSString *const kAnteriorChestWall8     = @"Anterior chest wall: 8";
static NSString *const kPosteriorChestWall1     = @"Poterior chest wall: 1";
static NSString *const kPosteriorChestWall2     = @"Poterior chest wall: 2";
static NSString *const kPosteriorChestWall3     = @"Poterior chest wall: 3";
static NSString *const kPosteriorChestWall4     = @"Poterior chest wall: 4";
static NSString *const kPosteriorChestWall5     = @"Poterior chest wall: 5";
static NSString *const kPosteriorChestWall6     = @"Poterior chest wall: 6";
static NSString *const kPosteriorChestWall7     = @"Poterior chest wall: 7";
static NSString *const kPosteriorChestWall8     = @"Poterior chest wall: 8";
static NSString *const kPosteriorChestWall9     = @"Poterior chest wall: 9";
static NSString *const kPosteriorChestWall10     = @"Poterior chest wall: 10";
static NSString *      kEnableMicrophoneMessage               = @"You need to enable access to microphone.";

static double kMinimumAmountOfTimeToShowSurvey                = 20.0 * 60.0;

static  NSString       *kTaskViewControllerTitle              = @"Auscultation Activity";

static  NSTimeInterval  kGetSoundingAaahhhInterval            = 10.0;

@interface APHPhonationTaskViewController ( )  <ORKTaskViewControllerDelegate>

@end

@implementation APHPhonationTaskViewController

#pragma  mark  -  Initialisation

+ (ORKOrderedTask *)createTask:(APCScheduledTask *) __unused scheduledTask
{
    NSDictionary  *audioSettings = @{ AVFormatIDKey         : @(kAudioFormatAppleLossless),
                                      AVNumberOfChannelsKey : @(1),
                                      AVSampleRateKey       : @(44100.0)
                                      };
    
    ORKOrderedTask  *task = [ORKOrderedTask audioTaskWithIdentifier:kTaskViewControllerTitle
                                             intendedUseDescription:nil
                                                  speechInstruction:nil
                                             shortSpeechInstruction:nil
                                                           duration:kGetSoundingAaahhhInterval
                                                  recordingSettings:audioSettings
                                                            options:0];
    
    //  Adjust apperance and text for the task
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
        //
        //    set up initial steps, which may have an extra step injected
        //    after the first if the user needs to say where they are in
        //    their medication schedule
        //
    [task.steps[0] setTitle:NSLocalizedString(kTaskName, nil)];
    [task.steps[0] setText:NSLocalizedString(@"This activity is for recording lung sound.", nil)];
    [task.steps[0] setDetailText:NSLocalizedString(@"Make sure an eletronic stethoscope is attached to your phone", nil)];

    [task.steps[1] setTitle:NSLocalizedString(kTaskName, nil)];
    [task.steps[1] setText:NSLocalizedString(@"Place the stethoscope at the lung position you specified", nil)];
    [task.steps[1] setDetailText:NSLocalizedString(@"Tap Next to start recording", nil)];
    [task.steps[3] setTitle:NSLocalizedString(@"Recording", nil)];
    [task.steps[4] setTitle:NSLocalizedString(@"Thank You!", nil)];
    [task.steps[4] setText:NSLocalizedString(@"The results will be saved and sent to our secure database", nil)];

    NSMutableArray *stepQuestions = [NSMutableArray array];
    ORKFormStep *step = [[ORKFormStep alloc] initWithIdentifier:kMomentInDayStepIdentifier title:nil text:NSLocalizedString(kMomentInDayFormatTitle, nil)];
    step.optional = NO;
    {
        NSArray *choices = @[
                             NSLocalizedString(kAnteriorChestWall1,
                                               kAnteriorChestWall1),
                             NSLocalizedString(kAnteriorChestWall2,
                                               kAnteriorChestWall2),
                             NSLocalizedString(kAnteriorChestWall3,
                                               kAnteriorChestWall3),
                             NSLocalizedString(kAnteriorChestWall4,
                                               kAnteriorChestWall4),
                             NSLocalizedString(kAnteriorChestWall5,
                                               kAnteriorChestWall5),
                             NSLocalizedString(kAnteriorChestWall6,
                                               kAnteriorChestWall6),
                             NSLocalizedString(kAnteriorChestWall7,
                                               kAnteriorChestWall7),
                             NSLocalizedString(kAnteriorChestWall8,
                                               kAnteriorChestWall8),
                             NSLocalizedString(kPosteriorChestWall1,
                                               kPosteriorChestWall1),
                             NSLocalizedString(kPosteriorChestWall2,
                                               kPosteriorChestWall2),
                             NSLocalizedString(kPosteriorChestWall3,
                                               kPosteriorChestWall3),
                             NSLocalizedString(kPosteriorChestWall4,
                                               kPosteriorChestWall4),
                             NSLocalizedString(kPosteriorChestWall5,
                                               kPosteriorChestWall5),
                             NSLocalizedString(kPosteriorChestWall6,
                                               kPosteriorChestWall6),
                             NSLocalizedString(kPosteriorChestWall7,
                                               kPosteriorChestWall7),
                             NSLocalizedString(kPosteriorChestWall8,
                                               kPosteriorChestWall8),
                             NSLocalizedString(kPosteriorChestWall9,
                                               kPosteriorChestWall9),
                             NSLocalizedString(kPosteriorChestWall10,
                                               kPosteriorChestWall10)
                             ];
        
        ORKAnswerFormat *format = [ORKTextChoiceAnswerFormat choiceAnswerFormatWithStyle:ORKChoiceAnswerStyleSingleChoice
                                                                             textChoices:choices];
        
        ORKFormItem *item = [[ORKFormItem alloc] initWithIdentifier:kMomentInDayFormat
                                                               text:NSLocalizedString(kInstructionRecordingLungSound, kInstructionRecordingLungSound)
                                                       answerFormat:format];
        [stepQuestions addObject:item];
        [step setFormItems:stepQuestions];
        
        NSMutableArray  *phonationSteps = [task.steps mutableCopy];
        if ([phonationSteps count] >= 1) {
            [phonationSteps insertObject:step atIndex:1];
        }
        
        task = [[ORKOrderedTask alloc] initWithIdentifier:kTaskViewControllerTitle steps:phonationSteps];
    }
    return  task;
}

#pragma  mark  -  Task View Controller Delegate Methods

- (void)taskViewController:(ORKTaskViewController *) __unused taskViewController stepViewControllerWillAppear:(ORKStepViewController *)stepViewController
{
    ORKStep  *step = stepViewController.step;
    
    if ([step.identifier isEqualToString: kAudioStepIdentifier])
    {
        [[UIView appearance] setTintColor:[UIColor appTertiaryBlueColor]];
    }
    else if ([step.identifier isEqualToString: kConclusionStepIdentifier]) {
        [[UIView appearance] setTintColor:[UIColor appTertiaryColor1]];
    } else {
        [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
    }
}

- (void) taskViewController: (ORKTaskViewController *) taskViewController
        didFinishWithReason: (ORKTaskViewControllerFinishReason)reason
                      error: (NSError *) error
{
    [[UIView appearance] setTintColor: [UIColor appPrimaryColor]];
    
    if (reason  == ORKTaskViewControllerFinishReasonFailed && error != nil)
    {
        APCLogError2 (error);
    } else if (reason  == ORKTaskViewControllerFinishReasonDiscarded) {
    } else if (reason  == ORKTaskViewControllerFinishReasonCompleted) {
        APHAppDelegate *appDelegate = (APHAppDelegate *) [UIApplication sharedApplication].delegate;
        appDelegate.dataSubstrate.currentUser.taskCompletion = [NSDate date];
        [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
    }
    
    [super taskViewController: taskViewController
          didFinishWithReason: reason
                        error: error];
}

#pragma  mark  -  Results For Dashboard

- (NSString *)createResultSummary
{
    ORKTaskResult  *taskResults = self.result;
    self.createResultSummaryBlock = ^(NSManagedObjectContext * context) {
        
        ORKFileResult  *fileResult = nil;
        BOOL  found = NO;
        for (ORKStepResult  *stepResult  in  taskResults.results) {
            if (stepResult.results.count > 0) {
                for (id  object  in  stepResult.results) {
                    if ([object isKindOfClass:[ORKFileResult class]] == YES) {
                        found = YES;
                        fileResult = object;
                        break;
                    }
                }
                if (found == YES) {
                    break;
                }
            }
        }
        
        double scoreSummary = [PDScores scoreFromPhonationTest: fileResult.fileURL];
        scoreSummary = isnan(scoreSummary) ? 0 : scoreSummary;
        
        NSDictionary  *summary = @{kScoreSummaryOfRecordsKey : @(scoreSummary)};
        
        NSError  *error = nil;
        NSData  *data = [NSJSONSerialization dataWithJSONObject:summary options:0 error:&error];
        NSString  *contentString = nil;
        if (data == nil) {
            APCLogError2 (error);
        } else {
            contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        
        if (contentString.length > 0)
        {
            [APCResult updateResultSummary:contentString forTaskResult:taskResults inContext:context];
        }
    };
    return nil;
}

#pragma  mark  - View Controller methods

- (void)willResignActiveNotificationWasReceived:(NSNotification *) __unused notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([self.delegate respondsToSelector:@selector(taskViewController:didFinishWithReason:error:)] == YES) {
        [self.delegate taskViewController:self didFinishWithReason:ORKTaskViewControllerFinishReasonDiscarded error:NULL];
    }
}

#pragma  mark  - View Controller methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = NSLocalizedString(kTaskViewControllerTitle, nil);
   
   // Once you give Audio permission to the application. Your app will not show permission prompt again.
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            // Microphone enabled
        }
        else {
            // Microphone disabled
            //Inform the user that they will to enable the Microphone
            UIAlertController * alert = [UIAlertController simpleAlertWithTitle:NSLocalizedString(kEnableMicrophoneMessage, nil) message:nil];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNotificationCenter  *centre = [NSNotificationCenter defaultCenter];
    [centre addObserver:self selector:@selector(willResignActiveNotificationWasReceived:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
