#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

const float ZOOM = 40.0;

float random (in vec2 _st) {
    return fract(sin(dot(_st.xy, vec2(1384.9898,78.555)))*12.5453123*u_time/100.0);
}

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 _st) {
    vec2 i = floor(_st);
    vec2 f = fract(_st);

    // Four corners in 2D of a tile
    float a = random(i)*u_time/200.0;
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f) + (u_time/50.0);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}



void main() {
    vec2 cd = (gl_FragCoord.xy) / ZOOM + u_mouse/100.0;
    float len = length(vec2(cd.x, cd.y));
    cd.x = cd.x + sin(cd.y + sin(len*0.1)) + cos(u_time);
    cd.y = cd.y - cos(cd.x - cos(len)) + sin(u_time);
    float blackout = -(length(gl_FragCoord.xy - u_resolution/2.0))/300.0/(u_time/30.0);
    gl_FragColor = vec4(
        sin(cd.x*0.1)*cos(noise(cd))+blackout,
        cos(cd.x*0.1)*sin(noise(cd))+blackout,
        sin(cd.x*0.1)+blackout, 
        1.0);


}