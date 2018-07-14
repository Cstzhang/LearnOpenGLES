//
//  Shader.hpp
//  三角形
//
//  Created by bigfish on 2018/7/10.
//  Copyright © 2018年 bigfish. All rights reserved.
//

#ifndef Shader_hpp
#define Shader_hpp
#include <glad/glad.h>
#include <string>
#include <fstream>
#include <sstream>
#include <iostream>
#include <stdio.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

class Shader {
    
public:
    //id
    unsigned int ID;
    // 构造器读取并构建着色器
    Shader(const char* vertexPath,const char* fragmentPath);
    //use
    void use();
    void setBool (const std::string &name,bool  value)   const;
    void setInt  (const std::string &name,int   value)   const;
    void setFloat(const std::string &name,float value)   const;
    void setMat4 (const std::string &name,glm::mat4  &value)   const;
private:
    void checkCompileErrors(unsigned int shader,std::string type);


    
    
    
};





#endif /* Shader_hpp */
