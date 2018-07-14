//
//  Camera.hpp
//  三角形
//
//  Created by bigfish on 2018/7/14.
//  Copyright © 2018年 bigfish. All rights reserved.
//

#ifndef Camera_hpp
#define Camera_hpp

#include <stdio.h>

#include <glad/glad.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>

#include <vector>

// Defines several possible options for camera movement. Used as abstraction to stay away from window-system specific input methods
enum Camera_Movement {
    FORWARD,
    BACKWARD,
    LEFT,
    RIGHT
};

// Default camera values
const float YAW         = -90.0f;
const float PITCH       =  0.0f;
const float SPEED       =  2.5f;
const float SENSITIVITY =  0.1f;
const float ZOOM        =  45.0f;

// An abstract camera class that processes input and calculates the corresponding Euler Angles, Vectors and Matrices for use in OpenGL
class Camera{
    
public:
    // Camera Attributes
    glm::vec3 Position;
    glm::vec3 Front;
    glm::vec3 Up;
    glm::vec3 Right;
    glm::vec3 WorldUp;
    // Euler Angles
    float Yaw;
    float Pitch;
    // Camera options
    float MovementSpeed;
    float MouseSensitivity;
    float Zoom;
    
    // Constructor with vectors
    Camera(glm::vec3 position = glm::vec3(0.0f, 0.0f, 0.0f), glm::vec3 up = glm::vec3(0.0f, 1.0f, 0.0f), float yaw = YAW, float pitch = PITCH);
    
    

    // Constructor with scalar values
    Camera(float posX, float posY, float posZ, float upX, float upY, float upZ, float yaw, float pitch);

    
    // Returns the view matrix calculated using Euler Angles and the LookAt Matrix
    // Returns the view matrix calculated using Euler Angles and the LookAt Matrix
    glm::mat4 GetViewMatrix()
    {
//        return glm::lookAt(Position, Position + Front, Up);
        return calculate_lookAt_matrix(Position, Position + Front, Up);
    }
    
    // Custom implementation of the LookAt function
    glm::mat4 calculate_lookAt_matrix(glm::vec3 position , glm::vec3 target ,glm::vec3 worldUp){
        // 1. Position = known
        // 2. Calculate cameraDirection
        glm::vec3 zaxis = glm::normalize(position - target);
        // 3. Get positive right axis vector
        glm::vec3 xaxis = glm::normalize(glm::cross(glm::normalize(worldUp), zaxis));
        // 4. Calculate camera up vector
        glm::vec3 yaxis = glm::cross(zaxis, xaxis);
        
        // Create translation and rotation matrix
        // In glm we access elements as mat[col][row] due to column-major layout
        
        glm::mat4 translation = glm::mat4(1.0f); // Identity matrix by default
        translation[3][0] = -position.x;// Third column, first row
        translation[3][1] = -position.y;
        translation[3][2] = -position.z;
        glm::mat4 rotation = glm::mat4(1.0f);
        rotation[0][0] = xaxis.x; // First column, first row
        rotation[1][0] = xaxis.y;
        rotation[2][0] = xaxis.z;
        rotation[0][1] = yaxis.x; // First column, second row
        rotation[1][1] = yaxis.y;
        rotation[2][1] = yaxis.z;
        rotation[0][2] = zaxis.x; // First column, third row
        rotation[1][2] = zaxis.y;
        rotation[2][2] = zaxis.z;
        
        // Return lookAt matrix as combination of translation and rotation matrix
        return rotation * translation; // Remember to read from right to left (first translation then rotation)
        
    }
    
    

    // Processes input received from any keyboard-like input system. Accepts input parameter in the form of camera defined ENUM (to abstract it from windowing systems)
    void ProcessKeyboard(Camera_Movement direction, float deltaTime);

    
    // Processes input received from a mouse input system. Expects the offset value in both the x and y direction.
    void ProcessMouseMovement(float xoffset, float yoffset, GLboolean constrainPitch = true);

    
    // Processes input received from a mouse scroll-wheel event. Only requires input on the vertical wheel-axis
    void ProcessMouseScroll(float yoffset);

    
private:
    // Calculates the front vector from the Camera's (updated) Euler Angles
    void updateCameraVectors();
    

};
#endif /* Camera_hpp */
