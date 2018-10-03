//
//  ViewController.m
//  OneTrak
//
//  Created by Nikolay Taran on 03.10.18.
//  Copyright © 2018 Nikolay Taran. All rights reserved.
//

#import "ViewController.h"
#import "TableViewDataSource.h"

@implementation ViewController

// Проверяем, если пользователь вводит текст в поле, то поднимаем view для предотвращения сокрытия полей клавиатурой
- (void)keyboardWillShow {
    if (!self.isKeyboardVisible) {
        [self setViewMovedUp:true offset:self.keyboardOffset];
        self.isKeyboardVisible = true;
    }
}

// Пользователь закончил ввод, возвращаем view
- (void)keyboardWillHide {
    if (self.isKeyboardVisible) {
        [self setViewMovedUp:false offset:self.keyboardOffset];
        self.isKeyboardVisible = false;
    }
}

// При вводе текста необходимо смещать view вверх для предотвращения случайного скрытия текстовых полей клавиатурой
- (void)setViewMovedUp:(BOOL)movedUp offset:(float)offset {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = self.view.frame;
    if (movedUp) {
        rect.origin.y -= offset;
        rect.size.height += offset;
    } else {
        rect.origin.y += offset;
        rect.size.height -= offset;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

// Метод скрытия клавиатуры при тапе по view
- (void)dismiss {
    [self.view endEditing:true];
}

// Метод делегата UITableView, определяет высоту каждой ячейки
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return (568.0 - 65.0) / 2;
    } else {
        return (568.0 - 65.0) / 2 / 3;
    }
}

// Добавляем/убираем селекторы событий начала и конца ввода текста в поля
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Значение, на которое поднимается view при вводе текста, зависит от ориентации устройства
// Отслеживание ориентации устройства, необходимо для изменения значения подъема view при вводе текста
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    UIInterfaceOrientation or = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(or)) {
        self.keyboardOffset = 330.0;
    } else if (UIInterfaceOrientationIsLandscape(or)) {
        self.keyboardOffset = 150.0;
    }
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isKeyboardVisible = false;
    self.keyboardOffset = 150.0;
    
    // Добавляем распознавание жестов для скрытия клавиатуры при тапе
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.view addGestureRecognizer:recognizer];
    
    // AutoLayout для главного UITableView
    self.tableView.translatesAutoresizingMaskIntoConstraints = false;
    
    [NSLayoutConstraint
     constraintWithItem:self.tableView
     attribute:NSLayoutAttributeLeft
     relatedBy:NSLayoutRelationEqual
     toItem:self.view
     attribute:NSLayoutAttributeLeftMargin
     multiplier:1.0
     constant:0.0].active = YES;
    
    [NSLayoutConstraint
     constraintWithItem:self.tableView
     attribute:NSLayoutAttributeRight
     relatedBy:NSLayoutRelationEqual
     toItem:self.view
     attribute:NSLayoutAttributeRightMargin
     multiplier:1.0
     constant:0.0].active = YES;
    
    [NSLayoutConstraint
     constraintWithItem:self.tableView
     attribute:NSLayoutAttributeTop
     relatedBy:NSLayoutRelationEqual
     toItem:self.view
     attribute:NSLayoutAttributeTopMargin
     multiplier:1.0
     constant:65.0].active = YES;
    
    [NSLayoutConstraint
     constraintWithItem:self.tableView
     attribute:NSLayoutAttributeBottom
     relatedBy:NSLayoutRelationEqual
     toItem:self.view
     attribute:NSLayoutAttributeBottomMargin
     multiplier:1.0
     constant:0.0].active = YES;
    
    // DataSource и делегат для UITableView
    self.tableViewDataSource = [[TableViewDataSource alloc] init];
    self.tableView.dataSource = self.tableViewDataSource;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 0, 0)]; // убираем бесконечный скролл UITableView
    
    self.tableView.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
