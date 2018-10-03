//
//  CustomProgressBar.m
//  OneTrak
//
//  Created by Nikolay Taran on 03.10.18.
//  Copyright © 2018 Nikolay Taran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomProgressBar.h"

// Кастомный прогрессбар
@implementation CustomProgressBar

// Отрисовка прогрессбара
- (void)updateProgressBarAnim {
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    float radius = self.frame.size.width / 3;
    
    float step = 0.1f;
    for (float angle = 0.0f; angle < 360.0f; angle += step) {
        CGPoint from = CGPointMake(cos(angle * M_PI / 180) * radius + center.x, sin(angle * M_PI / 180) * radius + center.y);
        CGPoint to = CGPointMake(cos((angle + step) * M_PI / 180) * radius + center.x, sin((angle + step) * M_PI / 180) * radius + center.y);
        [self drawLine:from to:to red:52.0f / 255.0f green:172.0f / 255.0f blue:217.0f / 255.0f];
    }
    
    for (float angle = 0.0f - 90.0f; angle < self.animAngle - 90.0f; angle += step) {
        CGPoint from = CGPointMake(cos(angle * M_PI / 180) * radius + center.x, sin(angle * M_PI / 180) * radius + center.y);
        CGPoint to = CGPointMake(cos((angle + step) * M_PI / 180) * radius + center.x, sin((angle + step) * M_PI / 180) * radius + center.y);
        [self drawArc:from to:to red:52.0f / 255.0f green:172.0f / 255.0f blue:217.0f / 255.0f];
    }
}

// Метод отрисовки отдельного кружка, используется при анимации прогрессбара
- (void)drawArc:(CGPoint) from to:(CGPoint) to red:(float)red green:(float)green blue:(float)blue {
    
    [[UIColor colorWithRed:red green:green blue:blue alpha:1.0f] set];
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:from radius:2.5f startAngle:0 endAngle:(2 * M_PI) clockwise:true];
    shape.path = path.CGPath;
    
    [path stroke];
}

// Метод отрисовки отдельной линии
- (void)drawLine:(CGPoint) from to:(CGPoint) to red:(float)red green:(float)green blue:(float)blue {
    UIBezierPath *aPath = [[UIBezierPath alloc] init];
    
    [aPath moveToPoint:from];
    
    aPath.lineWidth = 0.1f;
    
    [aPath addLineToPoint:to];
    
    [aPath closePath];
    
    [[UIColor colorWithRed:red green:green blue:blue alpha:1.0f] set];
    
    [aPath stroke];
}

// Очистка UIView прогрессбара
- (void)clearAll {
    [[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f] set];

    UIBezierPath *bpath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 568, 568)];
    
    
    
    [bpath stroke];
    
    [bpath fill];
}

- (void)drawRect:(CGRect)rect {
    
    [self clearAll];
    
    [self updateProgressBarAnim];
    
    self.percentBar.text = [NSString stringWithFormat:@"%u%%", self.percentage];
}

@end
