//
//  ViewController.m
//  Opengles_ triangle
//
//  Created by bigfish on 2018/7/17.
//  Copyright © 2018年 bigfish. All rights reserved.
//

#import "ViewController.h"

//顶点结构体
typedef struct {
    GLKVector3 positionCoords;
}sceneVertex;

//三角形的三个顶点
static const sceneVertex vertices[] = {
    {{-0.5f,-0.5f,0.0}},
    {{0.5f,-0.5f,0.0}},
    {{-0.5f,0.5f,0.0}},
};

@interface ViewController (){
    //声明缓存ID属性
    GLuint vertextBufferID;
}
//GLKBaseEffect
@property (nonatomic,strong)GLKBaseEffect *baseEffect;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 1 创建OpenGL ES上下文
    GLKView *view = (GLKView *)self.view;
    
    //创建OpenGL ES2.0上下文
    view.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    //设置当前上下文
    [EAGLContext setCurrentContext:view.context];
    
    //2 GLKBaseEffect属性 实例化
    self.baseEffect = [[GLKBaseEffect alloc] init];
    //使用静态颜色绘制
    self.baseEffect.useConstantColor = GL_TRUE;
    //设置默认绘制颜色，参数分别是 RGBA
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    //设置背景色为黑色
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    
    //生成并绑定缓存数据
    
    //申请一个标识符
    glGenBuffers(1, &vertextBufferID);
    //绑定指定标识符的缓存为当前缓存 将标识符绑定到GL_ARRAY_BUFFER
    glBindBuffer(GL_ARRAY_BUFFER, vertextBufferID);
    //复制顶点数据从CPU到GPU
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    
    
    
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(sceneVertex), NULL);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
}

- (void)dealloc{
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    if (0!=vertextBufferID) {
        glDeleteBuffers(1, &vertextBufferID);
        vertextBufferID = 0;
    }
}


@end
