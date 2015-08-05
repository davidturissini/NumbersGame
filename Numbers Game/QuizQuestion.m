//
//  QuizQuestion.m
//  Numbers Game
//
//  Created by David Turissini on 8/2/15.
//  Copyright © 2015 Turissini Technologies. All rights reserved.
//

#import "QuizQuestion.h"

@interface QuizQuestion ()

@end

@implementation QuizQuestion

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"numbers"
                                                     ofType:@"json"];
    
    
    NSData *data =  [NSData dataWithContentsOfFile:path];
    
    
    
    NSError *jsonParsingError;
    self.questionsAnswers = (NSDictionary *)[NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:0
                                          error:&jsonParsingError];
    
    self.questions = [[NSMutableArray alloc] initWithArray:[self.questionsAnswers allKeys]];
    
    
    self.answersTable.delegate = self;
    self.answersTable.dataSource = self;
    [self nextQuestion];
    
}


- (void) nextQuestion {
    self.questions = [self shuffleArray:self.questions];
    
    NSString *question = [self.questions objectAtIndex:0];
    
    self.answer = (NSString *)[self.questionsAnswers objectForKey:question];
    self.questionText.text = question;
    
    
    self.answers = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < 4; i += 1) {
        NSString *k = [self.questions objectAtIndex:i];
        [self.answers addObject:[self.questionsAnswers objectForKey:k]];
    }
    
    [self.questions removeObjectAtIndex:0];
    
    [self.answersTable reloadData];
}


- (NSMutableArray *)shuffleArray:(NSMutableArray *)array {
    NSUInteger count = [array count];
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [array exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    
    return array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.answers.count;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *answer = [self.answers objectAtIndex:indexPath.item];
    
    if (answer == self.answer) {
        [self nextQuestion];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"AnswerCell";
    NSLog(@"tablecell");
    
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    NSString *answer = [self.answers objectAtIndex:indexPath.item];
    cell.textLabel.text = answer;
    
    return cell;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
