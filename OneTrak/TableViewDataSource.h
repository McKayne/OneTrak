//
//  TableViewDataSource.h
//  OneTrak
//
//  Created by Nikolay Taran on 03.10.18.
//  Copyright © 2018 Nikolay Taran. All rights reserved.
//

#ifndef TableViewDataSource_h
#define TableViewDataSource_h

#import <UIKit/UIKit.h>
#import "CustomProgressBar.h"

// Все объекты на экране будут находиться в UITableView.
// Создаем DataSource и делегат для него
@interface TableViewDataSource : NSObject<UITableViewDataSource, UITextFieldDelegate>

// Прогрессбар
@property (nonatomic, retain) CustomProgressBar *bar;
// Текстовые поля для значения/макс. значения
@property (nonatomic, retain) UITextField *valueText, *maxValueText;
// Флаги, был ли изменен текст в полях
@property (assign) BOOL isValueTextEdited, isMaxValueTextEdited;
// UITableViewCell для заполнения главного экрана
@property (nonatomic, retain) UITableViewCell *percentBarCell, *valueCell, *maxValueCell, *goButtonCell;

// Методы для создания каждой ячейки UITableView
- (void)createPercentBar:(UITableViewCell *)percentBarCell;
- (void)createValueText:(UITableViewCell *)valueCell;
- (void)createMaxValueText:(UITableViewCell *)maxValueCell;
- (void)createGoButton:(UITableViewCell *)goButtonCell;

// Селектор для кнопки "GO"
- (void)setPercentageTo;

@end

#endif /* TableViewDataSource_h */
