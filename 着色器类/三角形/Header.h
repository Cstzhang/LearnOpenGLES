//
//  Header.h
//  三角形
//
//  Created by bigfish on 2018/7/10.
//  Copyright © 2018年 bigfish. All rights reserved.
//

#ifndef Header_h
#define Header_h
#include <glad/glad.h>// 包含glad来获取所有的必须OpenGL头文件
#include <string>
#include <fstream>
#include <sstream>
#include <iostream>

class Shader {

    
public:
    //id
    unsigned int ID;
    //shader
    Shader(const char* vertexPath, const char* framentPath);
    //use 用来激活着色器程序
    void use();
    //uniform
    void setBool(const std::string &name ,bool value) const;
    void setInt(const std::string &name ,int value) const;
    void setFloat(const std::string &name , float value) const;
};


#endif /* Header_h */
