//
//  QuizResultsViewController.h
//  Numbers Game
//
//  Created by David Turissini on 8/8/15.
//  Copyright © 2015 Turissini Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizQuestion.h"

@interface QuizResultsViewController : UIViewController
    @property (nonatomic) IBOutlet UILabel *resultsLabel;
    @property (nonatomic) int numCorrect;
    @property (nonatomic) int numQuestions;
@end
