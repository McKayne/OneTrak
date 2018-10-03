//
//  TableViewDataSource.m
//  OneTrak
//
//  Created by Nikolay Taran on 03.10.18.
//  Copyright © 2018 Nikolay Taran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewDataSource.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomProgressBar.h"

// Все объекты на экране будут находиться в UITableView.
// Создаем DataSource и делегат для него
@implementation TableViewDataSource

// Метод делегата UITextField, вызывается непосредственно после начала редактирования любого из полей
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    // Пользователь тапнул по первому полю
    if ([textField isEqual:self.valueText]) {
        
        // Сбрасываем предупреждение о некорректном вводе
        self.valueText.backgroundColor = [UIColor whiteColor];
        
        // Если в первом поле стоит текст по умолчанию
        if (!self.isValueTextEdited) {
            
            // то убираем его, и помечаем, что текст был изменен пользователем
            self.isValueTextEdited = true;
            textField.text = @"";
            textField.textColor = [UIColor blackColor];
        }
    } else { // иначе если пользователь тапнул по второму полю
        
        // Сбрасываем предупреждение о некорректном вводе
        self.maxValueText.backgroundColor = [UIColor whiteColor];
        
        // Если во втором поле стоит текст по умолчанию
        if (!self.isMaxValueTextEdited) {
            
            // то убираем его, и помечаем, что текст был изменен пользователем
            self.isMaxValueTextEdited = true;
            textField.text = @"";
            textField.textColor = [UIColor blackColor];
        }
    }
}

// Метод делегата UITextField, вызывается после редактирования любого текстового поля
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    // Если пользователь оставил первое поле пустым, показываем текст по умолчанию "value"
    if ([self.valueText.text length] == 0) {
        self.valueText.text = @"value";
        self.valueText.textColor = [UIColor grayColor];
        self.isValueTextEdited = false; // ставим флаг, что в поле стоит текст по умолчанию
    }
    
    // Если пользователь оставил второе поле пустым, показываем текст по умолчанию "max value"
    if ([self.maxValueText.text length] == 0) {
        self.maxValueText.text = @"max value";
        self.maxValueText.textColor = [UIColor grayColor];
        self.isMaxValueTextEdited = false; // ставим флаг, что в поле стоит текст по умолчанию
    }
}

// Метод проверки приводимости строки к числу с плавающей запятой
- (BOOL)isNumeric:(NSString *)string {
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [numberFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    NSNumber* number = [numberFormatter numberFromString:string];
    if (number != nil) {
        return true;
    }
    return false;
}

// Селектор для кнопки "GO"
- (void)setPercentageTo {
    
    // Проверка на допустимость введенных значений
    BOOL isValueValid = [self isNumeric:self.valueText.text], isMaxValueValid = [self isNumeric:self.maxValueText.text];
    
    // Если значения в обоих текстовых полях можно привести к числам
    if (isValueValid && isMaxValueValid) {
        float value, maxValue;
        
        // то преобразуем их в числа
        value = [self.valueText.text floatValue]; // значение
        maxValue = [self.maxValueText.text floatValue]; // макс. значение
        
        // По условию значение в первом поле не может превышать макс. значение во втором поле
        if (value <= maxValue) {
            
            // Новый процент
            unsigned int currentPercentage = value / (maxValue / 100.0);
            
            // Анимация будет в фоновом потоке
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            // В зависимости от инкремента или декремента будут разные анимации
            if (currentPercentage >= self.bar.percentage) {
                [queue addOperationWithBlock:^{
                    for (unsigned int i = self.bar.percentage; i < currentPercentage; i++) {
                        for (unsigned int j = 1; j <= 10; j++) {
                            
                            // Угол, на который отрисовывается прогрессбар
                            self.bar.animAngle = ((float) i + (float) j / 10.0f) * 3.6f;
                            
                            // Перерисовка UIView может производиться только в главном потоке
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.bar setNeedsDisplay];
                            });
                            
                            // Для плавности вставим задержку между вызовами отрисовки
                            usleep(5000);
                        }
                        
                        // В цикле при анимации увеличиваем процент
                        self.bar.percentage = i + 1;
                        
                        // В заключение необходимо сделать вызов отрисовки в главном потоке
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.bar setNeedsDisplay];
                        });
                    }
                }];
            } else {
                [queue addOperationWithBlock:^{
                    for (unsigned int i = self.bar.percentage; i > currentPercentage; i--) {
                        for (unsigned int j = 1; j <= 10; j++) {
                            
                            // Угол, на который отрисовывается прогрессбар
                            self.bar.animAngle = ((float) i - (float) j / 10.0f) * 3.6f;
                            
                            // Перерисовка UIView может производиться только в главном потоке
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.bar setNeedsDisplay];
                            });
                            
                            // Для плавности вставим задержку между вызовами отрисовки
                            usleep(5000);
                        }
                        
                        // В цикле при анимации уменьшаем процент
                        self.bar.percentage = i - 1;
                        
                        // В заключение необходимо сделать вызов отрисовки в главном потоке
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.bar setNeedsDisplay];
                        });
                    }
                }];
            }
        } else {
            // Недопустимые значения в обоих полях
            self.valueText.backgroundColor = [UIColor colorWithRed:1.0f green:0.9f blue:0.9f alpha:1.0f];
            self.maxValueText.backgroundColor = [UIColor colorWithRed:1.0f green:0.9f blue:0.9f alpha:1.0f];
        }
    } else {
        // Недопустимое значение в первом поле
        if (!isValueValid) {
            self.valueText.backgroundColor = [UIColor colorWithRed:1.0f green:0.9f blue:0.9f alpha:1.0f];
        }
        
        // Недопустимое значение во втором поле
        if (!isMaxValueValid) {
            self.maxValueText.backgroundColor = [UIColor colorWithRed:1.0f green:0.9f blue:0.9f alpha:1.0f];
        }
    }
}

// Метод создания ячейки UITableView, содержащей прогрессбар
- (void)createPercentBar:(UITableViewCell *)percentBarCell {
    
    // Инициализация прогрессбара
    self.bar = [[CustomProgressBar alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    // По умолчанию ставим 0%
    self.bar.percentage = 0;
    self.bar.animAngle = 0 * 3.6;
    
    // Инициализируем UILabel, который будет показывать проценты
    self.bar.percentBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.bar.percentBar.textAlignment = UITextAlignmentCenter;
    self.bar.percentBar.font = [UIFont fontWithName:@"SFProDisplay-Ultralight" size:40];
    
    // и помещаем его на прогрессбар
    [self.bar addSubview:self.bar.percentBar];
    
    // Применим AutoLayout для этого UILabel, что бы привязать его границы к фрейму кастомного прогрессбара
    self.bar.percentBar.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint
     constraintWithItem:self.bar.percentBar
     attribute:NSLayoutAttributeLeft
     relatedBy:NSLayoutRelationEqual
     toItem:self.bar
     attribute:NSLayoutAttributeLeftMargin
     multiplier:1.0
     constant:0.0].active = YES;
    
    [NSLayoutConstraint
     constraintWithItem:self.bar.percentBar
     attribute:NSLayoutAttributeRight
     relatedBy:NSLayoutRelationEqual
     toItem:self.bar
     attribute:NSLayoutAttributeRightMargin
     multiplier:1.0
     constant:0.0].active = YES;
    
    [NSLayoutConstraint
     constraintWithItem:self.bar.percentBar
     attribute:NSLayoutAttributeTop
     relatedBy:NSLayoutRelationEqual
     toItem:self.bar
     attribute:NSLayoutAttributeTopMargin
     multiplier:1.0
     constant:0.0].active = YES;
    
    [NSLayoutConstraint
     constraintWithItem:self.bar.percentBar
     attribute:NSLayoutAttributeBottom
     relatedBy:NSLayoutRelationEqual
     toItem:self.bar
     attribute:NSLayoutAttributeBottomMargin
     multiplier:1.0
     constant:0.0].active = YES;
    
    // Наконец помещаем прогрессбар в UITableViewCell
    [self.percentBarCell.contentView addSubview:self.bar];
    
    // Применяем AutoLayout к кастомному прогрессбару
    self.bar.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint
     constraintWithItem:self.bar
     attribute:NSLayoutAttributeLeft
     relatedBy:NSLayoutRelationEqual
     toItem:percentBarCell.contentView
     attribute:NSLayoutAttributeLeftMargin
     multiplier:1.0
     constant:20.0].active = YES;
    
    [NSLayoutConstraint
     constraintWithItem:self.bar
     attribute:NSLayoutAttributeRight
     relatedBy:NSLayoutRelationEqual
     toItem:percentBarCell.contentView
     attribute:NSLayoutAttributeRightMargin
     multiplier:1.0
     constant:-20.0].active = YES;
    
    [NSLayoutConstraint
     constraintWithItem:self.bar
     attribute:NSLayoutAttributeTop
     relatedBy:NSLayoutRelationEqual
     toItem:percentBarCell.contentView
     attribute:NSLayoutAttributeTopMargin
     multiplier:1.0
     constant:20.0].active = YES;
    
    [NSLayoutConstraint
     constraintWithItem:self.bar
     attribute:NSLayoutAttributeBottom
     relatedBy:NSLayoutRelationEqual
     toItem:percentBarCell.contentView
     attribute:NSLayoutAttributeBottomMargin
     multiplier:1.0
     constant:-20.0].active = YES;
    
}

// Метод создания текстового поля value и помещения его в ячейку UITableView
- (void)createValueText:(UITableViewCell *)valueCell {
    
    // Инициализация поля value
    self.valueText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.valueText.delegate = self;
    self.isValueTextEdited = false;
    self.valueText.font = [UIFont fontWithName:@"SFProDisplay-Ultralight" size:12];
    
    // Добавление в ячейку UITableView
    [valueCell.contentView addSubview:self.valueText];
    
    self.valueText.borderStyle = UITextBorderStyleRoundedRect;
    
    self.valueText.textColor = [UIColor grayColor];
    self.valueText.text = @"value";
    
    // Применяем AutoLayout к текстовому полю value
    self.valueText.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint
     constraintWithItem:self.valueText
     attribute:NSLayoutAttributeLeft
     relatedBy:NSLayoutRelationEqual
     toItem:valueCell.contentView
     attribute:NSLayoutAttributeLeftMargin
     multiplier:1.0
     constant:20.0].active = YES;
    
    [NSLayoutConstraint
     constraintWithItem:self.valueText
     attribute:NSLayoutAttributeRight
     relatedBy:NSLayoutRelationEqual
     toItem:valueCell.contentView
     attribute:NSLayoutAttributeRightMargin
     multiplier:1.0
     constant:-20.0].active = YES;
    
    [NSLayoutConstraint
     constraintWithItem:self.valueText
     attribute:NSLayoutAttributeTop
     relatedBy:NSLayoutRelationEqual
     toItem:valueCell.contentView
     attribute:NSLayoutAttributeTopMargin
     multiplier:1.0
     constant:20.0].active = YES;
    
    [NSLayoutConstraint
     constraintWithItem:self.valueText
     attribute:NSLayoutAttributeBottom
     relatedBy:NSLayoutRelationEqual
     toItem:valueCell.contentView
     attribute:NSLayoutAttributeBottomMargin
     multiplier:1.0
     constant:-20.0].active = YES;
    
}

// Метод создания текстового поля max value и помещения его в ячейку UITableView
- (void)createMaxValueText:(UITableViewCell *)maxValueCell {
    
    // Инициализация поля max value
    self.maxValueText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.maxValueText.delegate = self;
    self.isMaxValueTextEdited = false;
    self.maxValueText.font = [UIFont fontWithName:@"SFProDisplay-Ultralight" size:12];
    
    // Добавление в ячейку UITableView
    [maxValueCell.contentView addSubview:self.maxValueText];
    
    self.maxValueText.borderStyle = UITextBorderStyleRoundedRect;
    
    self.maxValueText.textColor = [UIColor grayColor];
    self.maxValueText.text = @"max value";
    
    // Применяем AutoLayout к текстовому полю max value
    self.maxValueText.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint
     constraintWithItem:self.maxValueText
     attribute:NSLayoutAttributeLeft
     relatedBy:NSLayoutRelationEqual
     toItem:maxValueCell.contentView
     attribute:NSLayoutAttributeLeftMargin
     multiplier:1.0
     constant:20.0].active = YES;
    
    [NSLayoutConstraint
     constraintWithItem:self.maxValueText
     attribute:NSLayoutAttributeRight
     relatedBy:NSLayoutRelationEqual
     toItem:maxValueCell.contentView
     attribute:NSLayoutAttributeRightMargin
     multiplier:1.0
     constant:-20.0].active = YES;
    
    [NSLayoutConstraint
     constraintWithItem:self.maxValueText
     attribute:NSLayoutAttributeTop
     relatedBy:NSLayoutRelationEqual
     toItem:maxValueCell.contentView
     attribute:NSLayoutAttributeTopMargin
     multiplier:1.0
     constant:20.0].active = YES;
    
    [NSLayoutConstraint
     constraintWithItem:self.maxValueText
     attribute:NSLayoutAttributeBottom
     relatedBy:NSLayoutRelationEqual
     toItem:maxValueCell.contentView
     attribute:NSLayoutAttributeBottomMargin
     multiplier:1.0
     constant:-20.0].active = YES;
    
}

// Создание кнопки "GO"
- (void)createGoButton:(UITableViewCell *)goButtonCell {
    
    // Инициализируем кнопку "GO"
    UIButton *goButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [goButtonCell.contentView addSubview:goButton];
    
    // Меням шрифт, надпись и цвет
    goButton.font = [UIFont fontWithName:@"SFProDisplay-Ultralight" size:20];
    [goButton setTitle:@"GO" forState:UIControlStateNormal];
    [goButton setBackgroundColor:[UIColor colorWithRed:52.0f / 255.0f green:172.0f / 255.0f blue:217.0f / 255.0f alpha:1.0f]];
    
    // Скругление углов
    goButton.layer.cornerRadius = 5;
    goButton.clipsToBounds = true;
    
    // Добавляем селектор
    [goButton addTarget:self action:@selector(setPercentageTo) forControlEvents:UIControlEventTouchUpInside];
    
    // Применяем AutoLayout
    goButton.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint
     constraintWithItem:goButton
     attribute:NSLayoutAttributeLeft
     relatedBy:NSLayoutRelationEqual
     toItem:goButtonCell.contentView
     attribute:NSLayoutAttributeLeftMargin
     multiplier:1.0
     constant:20.0].active = YES;
    
    [NSLayoutConstraint
     constraintWithItem:goButton
     attribute:NSLayoutAttributeRight
     relatedBy:NSLayoutRelationEqual
     toItem:goButtonCell.contentView
     attribute:NSLayoutAttributeRightMargin
     multiplier:1.0
     constant:-20.0].active = YES;
    
    [NSLayoutConstraint
     constraintWithItem:goButton
     attribute:NSLayoutAttributeTop
     relatedBy:NSLayoutRelationEqual
     toItem:goButtonCell.contentView
     attribute:NSLayoutAttributeTopMargin
     multiplier:1.0
     constant:20.0].active = YES;
    
    [NSLayoutConstraint
     constraintWithItem:goButton
     attribute:NSLayoutAttributeBottom
     relatedBy:NSLayoutRelationEqual
     toItem:goButtonCell.contentView
     attribute:NSLayoutAttributeBottomMargin
     multiplier:1.0
     constant:-20.0].active = YES;
}

- (id)init {
    self = [super init];
    
    // Cell для прогрессбара
    self.percentBarCell = [[UITableViewCell alloc] init];
    [self createPercentBar:self.percentBarCell];
    
    // Cell для "Value"
    self.valueCell = [[UITableViewCell alloc] init];
    [self createValueText:self.valueCell];
    
    // Cell для "Max value"
    self.maxValueCell = [[UITableViewCell alloc] init];
    [self createMaxValueText:self.maxValueCell];
    
    // Cell для кнопки "GO"
    self.goButtonCell = [[UITableViewCell alloc] init];
    [self createGoButton:self.goButtonCell];
    
    return self;
}

// Методы протокола dataSource (число секций, рядов и метод, возвращающий UITableViewCell
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return self.percentBarCell;
        case 1:
            return self.valueCell;
        case 2:
            return self.maxValueCell;
        default:
            return self.goButtonCell;
    }
}

@end
