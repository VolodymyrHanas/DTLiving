//
//  video_composition_effect.cpp
//  DTLiving
//
//  Created by Dan Jiang on 2020/5/12.
//  Copyright © 2020 Dan Thought Studio. All rights reserved.
//

#include "video_composition_effect.h"

#include <sstream>

#include "constants.h"

namespace dtliving {
namespace effect {

std::string VideoCompositionEffect::VertexShader() {
    std::stringstream os;
    os << "attribute vec4 a_position;\n";
    os << "attribute vec4 a_texcoord;\n";
    os << "\n";
    os << "uniform mat4 u_modelMatrix;\n";
    os << "uniform mat4 u_orthographicMatrix;\n";
    os << "\n";
    os << "varying vec2 v_texcoord;\n";
    os << "\n";
    os << "void main() {\n";
    os << "v_texcoord = a_texcoord.xy;\n";
    os << "gl_Position = u_orthographicMatrix * u_modelMatrix * vec4(a_position.xyz, 1.0);\n";
    os << "}\n";
    return os.str();
}

VideoCompositionEffect::VideoCompositionEffect(std::string name)
: VideoEffect(name)
, positions2_({ -1, -1, 1, -1, -1, 1, 1, 1 }) {
}

void VideoCompositionEffect::LoadShaderSource() {
    VideoEffect::LoadShaderSource(VideoEffect::VertexShader(), VideoEffect::FragmentShader());
    
    program2_ = new ShaderProgram();
    program2_->CompileSource(VideoCompositionEffect::VertexShader().c_str(), VideoEffect::FragmentShader().c_str());
}

void VideoCompositionEffect::LoadUniform() {
    VideoEffect::LoadUniform();
        
    a_position2_ = program2_->AttributeLocation("a_position");
    a_texcoord2_ = program2_->AttributeLocation("a_texcoord");
    u_texture2_ = program2_->UniformLocation("u_texture");    
    u_orthographic_matrix2_ = program2_->UniformLocation("u_orthographicMatrix");
}

void VideoCompositionEffect::Render(VideoFrame input_frame, VideoFrame output_frame, std::vector<GLfloat> positions, std::vector<GLfloat> texture_coordinates) {
    
    // draw video frame
    
    VideoEffect::Render(input_frame, output_frame, positions, texture_coordinates);
    
    // draw image frame
    
    program2_->Use();
        
    BeforeSetPositions(output_frame.width, output_frame.height, 1);

    glEnableVertexAttribArray(a_position2_);
    glVertexAttribPointer(a_position2_,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          0,
                          positions2_.data());
    
    glEnableVertexAttribArray(a_texcoord2_);
    glVertexAttribPointer(a_texcoord2_,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          0,
                          texture_coordinates.data());
    
    BeforeDrawArrays(output_frame.width, output_frame.height, 1);

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glDisable(GL_BLEND);
}

void VideoCompositionEffect::BeforeDrawArrays(GLsizei width, GLsizei height, int program_index) {
    if (program_index == 1) {
        auto matrix = VideoEffect::CaculateOrthographicMatrix(width, height);
        glUniformMatrix4fv(u_orthographic_matrix2_, 1, false, matrix.data());
    }
}

}
}
