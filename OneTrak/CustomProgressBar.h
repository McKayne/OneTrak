//
//  CustomProgressBar.h
//  OneTrak
//
//  Created by Nikolay Taran on 03.10.18.
//  Copyright © 2018 Nikolay Taran. All rights reserved.
//

#ifndef CustomProgressBar_h
#define CustomProgressBar_h

#import <UIKit/UIKit.h>

// Кастомный прогрессбар
@interface CustomProgressBar : UIView

// Значение в процентах
@property (assign) unsigned int percentage;

// Угол на который будет отрисовываться прогрессбар при анимации
@property (assign) float animAngle;

// Показывает проценты
@property (nonatomic, retain) UILabel *percentBar;

// Очистка UIView прогрессбара
- (void)clearAll;

// Метод отрисовки отдельного кружка, используется при анимации прогрессбара
- (void)drawArc:(CGPoint) from to:(CGPoint) to red:(float)red green:(float)green blue:(float)blue;

// Метод отрисовки отдельной линии
- (void)drawLine:(CGPoint) from to:(CGPoint) to red:(float)red green:(float)green blue:(float)blue;

// Отрисовка прогрессбара
- (void)updateProgressBarAnim;

@end

#endif /* CustomProgressBar_h */
