# Shaders
Unity shaders made in a mix of HLSL and Shader Graph


This project is used to try out new shaders from various tutorials

<b>Shader Graph Shaders:</b>

<hr/>

Breath of the Wild Style Toon Shaders made following this post : https://connect.unity.com/p/zelda-inspired-toon-shading-in-shadergraph
(Basically a toon shader with rim lighting and textured specular highlights)

Simple Toon Shader - Uses a simplified lighting model to determine shadow vs. Midtone vs. Highlight.
Also has a parameter that can lighting edge sharpness.

Toon Water Shader - Simple water. Bright like the wind waker

Ocean Shader (2 variants) - Water shaders that look like the ocean. Uses sliding noise textures

Lambertian Lighting Shader - A simple shader that

Blinn-Phong Lighting Shader - A slightly more complicated shader that uses the Blinn-Phong model


<b>Shaders made using Shaderlab:</b>
<hr/>

All the shaders below were made by following guides by Alan Zucconi - 
https://www.alanzucconi.com/

Smoke Shader (Simulation Shader)

Stencil Shader (Uses Stencil buffer to create overlapping geometry -- really like this one)

Image Overlay shader (overlays an image over the screen. Really simple shader, but useful)

Color Mixing Shader - This shader takes alters the screen so that it displays in black and white, chromatic
and other variants to simulate what different types of colorblind people will see
