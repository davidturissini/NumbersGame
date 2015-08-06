//
//  QuizQuestion.h
//  Numbers Game
//
//  Created by David Turissini on 8/2/15.
//  Copyright © 2015 Turissini Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizQuestion : UIViewController <UITableViewDataSource, UITableViewDelegate>
    @property (nonatomic) IBOutlet UILabel *questionText;
    @property (nonatomic) IBOutlet UITableView *answersTable;
    @property (nonatomic) NSMutableArray *questions;
    @property (nonatomic) NSMutableArray *answers;
    @property (nonatomic) NSString *answer;
    @property (nonatomic) NSDictionary *questionsAnswers;
    @property (nonatomic) NSString *question;
@end
