//
//  ViewController.m
//  MaskImage-demo
//
//  Created by 黄海燕 on 16/7/5.
//  Copyright © 2016年 huanghy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupSubViews];
}

//创建子视图
- (void)setupSubViews
{

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 100, self.view.frame.size.width -40, self.view.frame.size.width -40)];
    label.text = @"很遗憾未中奖!";
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 100, self.view.frame.size.width -40, self.view.frame.size.width -40)];
    self.imageView.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:self.imageView];
    //图片添加文字水印
    self.imageView.image = [self image:_imageView.image addMaskText:@"哈哈哈哈哈" maskRect:CGRectMake(0, 0, 130, 80)];
    //图片添加图片水印
   // self.imageView.image = [self image:_imageView.image addMaskImage:[UIImage imageNamed:@"1.jpg"] maskRect:CGRectMake(0, 0, 130, 80)];
    
}

//实现刮刮乐效果
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //触摸任意位置
    UITouch *touch = touches.anyObject;
    //触摸位置在图片上的坐标
    CGPoint cententPoint = [touch locationInView:self.imageView];
    //设置清除点的大小
    CGRect rect = CGRectMake(cententPoint.x, cententPoint.y, 20, 20);
    //默认创建一个透明的视图
    UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO, 0);
    //获取上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    //把imageView的layer映射到上下文中
    [self.imageView.layer renderInContext:ref];
    //清除划过的区域
    CGContextClearRect(ref, rect);
    //获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //结束图片的画板,图片在上下文中消失
    UIGraphicsEndImageContext();
    self.imageView.image = image;
}

#pragma mark - 图片添加图片水印
- (UIImage *)image:(UIImage *)image
      addMaskImage:(UIImage *)masekImage
          maskRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //四个参数为水印图片的位置
    [masekImage drawInRect:rect];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

#pragma mark - 图片添加文字水印
- (UIImage *)image:(UIImage *)image addMaskText:(NSString *)maskText maskRect:(CGRect)rect
{
    int w = image.size.width;
    int h = image.size.height;
    UIGraphicsBeginImageContext(image.size);
    [[UIColor redColor] set];
    [image drawInRect:CGRectMake(0, 0, w,h)];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    dict[NSForegroundColorAttributeName] = [UIColor grayColor];
    dict[NSStrokeWidthAttributeName] = @5;
    [maskText drawInRect:rect withAttributes:dict];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
