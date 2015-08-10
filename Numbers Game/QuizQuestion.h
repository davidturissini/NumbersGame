//
//  QuizQuestion.h
//  Numbers Game
//
//  Created by David Turissini on 8/2/15.
//  Copyright © 2015 Turissini Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizResultsViewController.h"

@interface QuizQuestion : UIViewController <UITableViewDataSource, UITableViewDelegate>
    @property (nonatomic) IBOutlet UILabel *questionText;
    @property (nonatomic) IBOutlet UITableView *answersTable;
    @property (nonatomic) IBOutlet UILabel *questionResultLabel;
    @property (nonatomic) IBOutlet UIView *questionResultView;
    @property (nonatomic) NSMutableArray *questions;
    @property (nonatomic) NSArray *answers;
    @property (nonatomic) NSDictionary *questionsAnswers;
    @property (nonatomic) NSString *question;
    @property (nonatomic) NSArray *currentQuestions;
    @property (nonatomic) NSString *currentAnswer;
    @property (nonatomic) int numCorrect;
    @property (nonatomic) int numQuestions;
    @property (nonatomic) UIColor *correctColor;
    @property (nonatomic) UIColor *incorrectColor;
@end
