//
//  ViewController.m
//  PrimaryGCD
//
//  Created by 冯一男 on 2017/11/16.
//  Copyright © 2017年 冯一男. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

#define KCurrWidth [UIScreen mainScreen].bounds.size.width
#define KCurrHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"同步并行" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(syncConcurrent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"异步并行" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(asyncConcurrent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 setTitle:@"同步串行" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(syncSerial) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn4 setTitle:@"异步串行" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(asyncSerial) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn5 setTitle:@"同步主队列" forState:UIControlStateNormal];
    [btn5 setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(syncMain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];
    
    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn6 setTitle:@"异步主队列" forState:UIControlStateNormal];
    [btn6 setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [btn6 addTarget:self action:@selector(asyncMain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn6];
    
    CGFloat width = 100;
    CGFloat padding = (KCurrWidth - width) / 2;
    CGFloat height = 50;
    CGFloat margin = (KCurrHeight - 300) / 7;
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(margin);
        make.left.equalTo(self.view.left).offset(padding);
        make.right.equalTo(self.view.right).offset(-padding);
        make.bottom.equalTo(btn2.top).offset(-margin);
        
        make.height.equalTo(height);
        
    }];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn1.bottom).offset(margin);
        make.left.equalTo(self.view.left).offset(padding);
        make.right.equalTo(self.view.right).offset(-padding);
        make.bottom.equalTo(btn3.top).offset(-margin);
        
        make.height.equalTo(height);
        
    }];
    
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn2.bottom).offset(margin);
        make.left.equalTo(self.view.left).offset(padding);
        make.right.equalTo(self.view.right).offset(-padding);
        make.bottom.equalTo(btn4.top).offset(-margin);
        
        make.height.equalTo(height);
        
    }];
    
    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn3.bottom).offset(margin);
        make.left.equalTo(self.view.left).offset(padding);
        make.right.equalTo(self.view.right).offset(-padding);
        make.bottom.equalTo(btn5.top).offset(-margin);
        
        make.height.equalTo(height);
        
    }];
    
    [btn5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn4.bottom).offset(margin);
        make.left.equalTo(self.view.left).offset(padding);
        make.right.equalTo(self.view.right).offset(-padding);
        make.bottom.equalTo(btn6.top).offset(-margin);
        
        make.height.equalTo(height);
        
    }];
    
    [btn6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn5.bottom).offset(margin);
        make.left.equalTo(self.view.left).offset(padding);
        make.right.equalTo(self.view.right).offset(-padding);
        make.bottom.equalTo(self.view.bottom).offset(-margin);
        
        make.height.equalTo(btn5);
        
    }];
}

//同步 + 并行 不会开启新线程，执行完一个任务，再执行下一个任务
- (void)syncConcurrent
{
    NSLog(@"syncConcurrent---begin");
    
    dispatch_queue_t queue= dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncConcurrent---end");
}

//异步 + 并行 可同时开启多线程，任务交替执行
- (void)asyncConcurrent
{
    NSLog(@"asyncConcurrent---begin");
    
    dispatch_queue_t queue= dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncConcurrent---end");
}

//同步 + 串行 不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务
- (void)syncSerial
{
    NSLog(@"syncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncSerial---end");
}

//异步 + 串行 会开启1条新线程，在新线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务
- (void)asyncSerial
{
    NSLog(@"asyncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncSerial---end");
}

//同步 + 主队列 互等卡住不可行(在主线程中调用)
- (void)syncMain
{
    NSLog(@"syncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncMain---end");
}

//异步 + 主队列 不会开启新线程，在主线程执行任务。执行完一个任务，再执行下一个任务
- (void)asyncMain
{
    NSLog(@"asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncMain---end");
}


@end
