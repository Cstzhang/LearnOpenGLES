//
//  ViewController.m
//  LearnOpenGLES
//
//  Created by zhangzb on 2018/5/5.
//  Copyright © 2018年 Guangzhou Shirui Electronics Co., Ltd. All rights reserved.
//

#import "ViewController.h"

//顶点数据


@interface ViewController ()
@property (nonatomic,strong) EAGLContext *glContext;//上下文
@property (nonatomic,strong) GLKBaseEffect *glEffect;   //着色器
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGlConfig];
    [self setupVertexArray];
    [self uploadTexture];
}

//  创建GL上下文，配置
- (void)setupGlConfig{
    //
    self.glContext = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    //storyboard记得添加
    GLKView *glkview = (GLKView *)self.view;
    glkview.context = self.glContext;
    
    //  drawableColorFormat
    //  你的OpenGL上下文有一个缓冲区，它用以存储将在屏幕中显示的颜色。你可以使用其属性来设置缓冲区中每个像素的颜色格式。
    //  缺省值是GLKViewDrawableColorFormatRGBA8888，即缓冲区的每个像素的最小组成部分(-个像素有四个元素组成 RGBA)使用8个bit(如R使用8个bit)（所以每个像素4个字节 既 4*8 个bit）。这非常好，因为它给了你提供了最广泛的颜色范围，让你的app看起来更好。
    //  但是如果你的app允许更小范围的颜色，你可以设置为GLKViewDrawableColorFormatRGB565，从而使你的app消耗更少的资源（内存和处理时间）。
    glkview.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    
    //  drawableDepthFormat
    //  你的OpenGL上下文还可以（可选地）有另一个缓冲区，称为深度缓冲区。这帮助我们确保更接近观察者的对象显示在远一些的对象的前面（意思就是离观察者近一些的对象会挡住在它后面的对象）。
    //  其缺省的工作方式是：OpenGL把接近观察者的对象的所有像素存储到深度缓冲区，当开始绘制一个像素时，它（OpenGL）首先检查深度缓冲区，看是否已经绘制了更接近观察者的什么东西，如果是则忽略它（要绘制的像素，就是说，在绘制一个像素之前，看看前面有没有挡着它的东西，如果有那就不用绘制了）。否则，把它增加到深度缓冲区和颜色缓冲区。
    //  你可以设置这个属性，以选择深度缓冲区的格式。缺省值是GLKViewDrawableDepthFormatNone，意味着完全没有深度缓冲区。
    //  但是如果你要使用这个属性（一般用于3D游戏），你应该选择GLKViewDrawableDepthFormat16或GLKViewDrawableDepthFormat24。这里的差别是使用GLKViewDrawableDepthFormat16将消耗更少的资源，但是当对象非常接近彼此时，你可能存在渲染问题（）。
//    glkview.drawableDepthFormat = GLKViewDrawableDepthFormat24;

    //  将此“EAGLContext”实例设置为OpenGL的“当前激活”的“Context”。这样，以后所有“GL”的指令均作用在这个“Context”上。随后，发送第一个“GL”指令：激活“深度检测”。
    [EAGLContext setCurrentContext:self.glContext];

}

//  将顶点数据写入通用的顶点属性存储区
- (void)setupVertexArray{
    GLfloat vertexData[] =
    {
        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        0.5, 0.5, -0.0f,    1.0f, 1.0f, //右上
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        -0.5, -0.5, 0.0f,   0.0f, 0.0f, //左下
    };
    //
    //  1.写入过程
    //  首先将数据保存进GUP的一个缓冲区中，然后再按一定规则，将数据取出，复制到各个通用顶点属性中。
    //  注：如果顶点数据只有一种类型（如单纯的位置坐标），换言之，在读数据时，不需要确定第一个数据的内存位置（总是从0开始），则不必事先保存进缓冲区。
    //
    
    //  2.顶点数组保存进缓冲区
    //  Vertex Data
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
    //  这几行代码表示的含义是：声明一个缓冲区的标识（GLuint类型à
    //  让OpenGL自动分配一个缓冲区并且返回这个标识的值à绑定这个缓冲区到当前“Context”à
    //  最后，将我们前面预先定义的顶点数据“vertexData”复制进这个缓冲区中。

    //  3、将缓冲区的数据复制进通用顶点属性中
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 0);
    //    首先，激活顶点属性（默认它是关闭的）。“GLKVertexAttribPosition”是顶点属性集中“位置Position”属性的索引。
    //
    //    顶点属性集中包含五种属性：位置、法线、颜色、纹理0，纹理1。
    //
    //    它们的索引值是0到4。
    //
    //    激活后，接下来使用“glVertexAttribPointer”方法填充数据。
    //
    //    参数含义分别为：
    //
    //    顶点属性索引（这里是位置）、3个分量的矢量、类型是浮点（GL_FLOAT）、填充时不需要单位化（GL_FALSE）、
    #pragma mark 待修改
    //    在数据数组中每行的跨度是32个字节（4*8=32。从预定义的数组中可看出，每行有8个GL_FLOAT浮点值，而GL_FLOAT占4个字节，因此每一行的跨度是4*8）。
    //
    #pragma mark 待修改
    //    最后一个参数是一个偏移量的指针，用来确定“第一个数据”将从内存数据块的什么地方开始。
    
    
    //    在前面预定义的顶点数据数组中，还包含了法线和纹理坐标，所以参照上面的方法，将剩余的数据分别复制进通用顶点属性中。
    
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);//纹理
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 3);
     //glVertexAttribPointer 指定了渲染时索引值为 GLKVertexAttribTexCoord0 的顶点属性数组的数据格式和位置
    
    

}

//这两个方法每帧都执行一次（循环执行），一般执行频率与屏幕刷新率相同（但也可以更改）。
//
//第一次循环时，先调用“glkView”再调用“update”。
//
//一般，将场景数据变化放在“update”中，而渲染代码则放在“glkView”中。

//一般，将场景数据变化放在“update”中，而渲染代码则放在“glkView”中。
- (void)uploadTexture{
    //纹理贴图
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"test_image" ofType:@"jpeg"];
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];//GLKTextureLoaderOriginBottomLeft 纹理坐标系是相反的
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    //着色器
    self.glEffect = [[GLKBaseEffect alloc] init];
    self.glEffect.texture2d0.enabled = GL_TRUE;
    self.glEffect.texture2d0.name = textureInfo.name;
    
    
}

/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //    iOS的OpenGL中里有2个着色器，
    //    一个是GLKBaseEffect，为了方便OpenGL ES 1.0转移到2.0的通用着色器。
    //    一个是OpenGL ES 2.0新添加的可编程着色器，使用跨平台的着色语言
    //    实例化基础效果实例，如果没有GLKit与GLKBaseEffect类，就需要为这个简单的例子编写一个小的GPU程序，使用2.0的Shading Language，而GLKBaseEffect会在需要的时候自动的构建GPU程序。
    //启动着色器
    
    //    这里使用GLKBaseEffect来做着色器
    
    [self.glEffect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    //    前两行为渲染前的“清除”操作，清除颜色缓冲区和深度缓冲区中的内容，并且填充淡蓝色背景（默认背景是黑色）。
    //
    //    “prepareToDraw”方法，是让“效果Effect”针对当前“Context”的状态进行一些配置，它始终把“GL_TEXTURE_PROGRAM”状态定位到“Effect”对象的着色器上。此外，如果Effect使用了纹理，它也会修改“GL_TEXTURE_BINDING_2D”。
    //
    //
    //
    //    接下来，用“glDrawArrays”指令，让OpenGL“画出”两个三角形（拼合为一个正方形）。OpenGL会自动从通用顶点属性中取出这些数据、组装、再用“Effect”内置的着色器渲染。
}


@end
