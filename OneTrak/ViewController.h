//
//  ViewController.h
//  OneTrak
//
//  Created by Nikolay Taran on 03.10.18.
//  Copyright © 2018 Nikolay Taran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewDataSource.h"

@interface ViewController : UIViewController<UITableViewDelegate>

// Все объекты на экране будут находиться в UITableView.
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// DataSource для tableView
@property (nonatomic, strong) TableViewDataSource *tableViewDataSource;

// При вводе текста необходимо смещать view вверх для предотвращения случайного скрытия текстовых полей клавиатурой
// Значение, на которое поднимается view при вводе текста
@property (assign) float keyboardOffset;

// Флаг присутствия клавиатуры
@property (assign) BOOL isKeyboardVisible;

// Метод скрытия клавиатуры при тапе по view
- (void)dismiss;

@end

