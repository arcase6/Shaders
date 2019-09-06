#ifndef MY_CUSTOM_LIGHTING
#define MY_CUSTOM_LIGHTING

//https://blogs.unity3d.com/2019/07/31/custom-lighting-in-shader-graph-expanding-your-graphs-in-2019/

//https://docs.unity3d.com/Packages/com.unity.shadergraph@6.7/manual/Custom-Function-Node.html

//the code for this is found in a file called Lighting.hlsl
//to view this you need to go to your unity install, then look for the LWRP package in the resources under package manager
//the file is zipped up so you will need to copy it then unzip it to actually use it

//The methods are copied here for convenience

/*
Light GetMainLight()
{
    Light light;
    light.direction = _MainLightPosition.xyz;
#if defined(_MIXED_LIGHTING_SUBTRACTIVE) && defined(LIGHTMAP_ON)
    light.distanceAttenuation = _MainLightPosition.w;
#else
    light.distanceAttenuation = 1.0;
#endif
    light.shadowAttenuation = 1.0;
    light.color = _MainLightColor.rgb;

    return light;
}

Light GetMainLight(float4 shadowCoord)
{
    Light light = GetMainLight();
    light.shadowAttenuation = MainLightRealtimeShadow(shadowCoord);
    return light;
}
*/


void MainLight_half(float3 WorldPos, out half3 Direction, out half3 Color, out half DistanceAtten, out half ShadowAtten){
#if SHADERGRAPH_PREVIEW
    Direction = half3(0.5,0.5,0);
    Color = 1;
    DistanceAtten = 1;
    ShadowAtten = 1;
#else
    #if SHADOWS_SCREEN
        half4 clipPos = TransformWorldToHClip(WorldPos); //transform world to homogeneous clip space
        half4 shadowCoord = ComputeScreenPos(clipPos); //get the shadow coord from screen
    #else
        half4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
    #endif
    Light mainLight = GetMainLight(shadowCoord); //function included in ShaderLibrary/Lighting.hlsl
    Direction = mainLight.direction;
    Color = mainLight.color;
    DistanceAtten = mainLight.distanceAttenuation;
    ShadowAtten = mainLight.shadowAttenuation;
#endif

#endif
}


void AdditionalLights_half(half3 SpecularColor, half Smoothness, half3 WorldPosition, half3 WorldNormal, half3 WorldView, out half3 Diffuse, out half3 Specular){
    half3 diffuseColor = 0;
    half3 specularColor = 0;

    #ifndef SHADERGRAPH_PREVIEW
        Smoothness = exp2(10 * Smoothness + 1);
        WorldView = SafeNormalize(WorldView);

        //Additional Lights cannot be directional lights
        //Additional lights are the set of non-culled spot and point lights (culling done by distance)
        //if you want to see culling in action set the diffuse color based on additional light count
        int lightCount = GetAdditionalLightsCount();
        for(int i = 0; i < lightCount; i++){
            Light light = GetAdditionalLight(i,WorldPosition);
            half3 attenuatedLightColor = light.color * (light.distanceAttenuation * light.shadowAttenuation);
            diffuseColor += LightingLambert(attenuatedLightColor, light.direction, WorldNormal);
            specularColor += LightingSpecular(attenuatedLightColor, light.direction, WorldNormal, WorldView, half4(SpecularColor,1), Smoothness);
        }


    #endif 
    Diffuse = diffuseColor;
    Specular = specularColor;
}

half3 LightingDiffuseToon(half3 LightColor, half3 LightDirection, half3 WorldNormal, half ShadowSoftness){
    half dotProduct = dot(LightDirection, WorldNormal);
    dotProduct = smoothstep(0,ShadowSoftness,dotProduct);
    return dotProduct * LightColor; 
}

void SafeNormalize_half(half3 Direction, out half3 NormalizedDirection){
    NormalizedDirection =  SafeNormalize(Direction);
}

half3 LightingSpecToon(half3 lightColor, half3 lightDir, half3 normal, half3 viewDir, half4 specularGloss, half shininess, half SpecularSoftness)
{
    half3 halfVec = SafeNormalize(lightDir + viewDir);
    half NdotH = saturate(dot(normal, halfVec)); //specular intensity


	//specular gloss rgb is how specular each channel is all multiplied by a specular component stores in the alpha channel
    half modifier = pow(NdotH, shininess) * specularGloss.a; //a modifier that sharpens specular highlights and accounts for gloss (gloss seems to basically just be "specularness" of the material)

    half3 specularReflection = specularGloss.rgb * modifier; 

    specularReflection = smoothstep(0.005,SpecularSoftness,specularReflection);

    return lightColor * specularReflection; 
}

void AdditionalLightsToon_half(half3 SpecularColor, half Smoothness, half3 WorldPosition, half3 WorldNormal, half3 WorldView, half ShadowSoftness, half SpecularSoftness, out half3 Diffuse, out half3 Specular){
    half3 diffuseColor = 0; 
    half3 specularColor = 0;
 
    #ifndef SHADERGRAPH_PREVIEW
        Smoothness = exp2(10 * Smoothness + 1);
        WorldView = SafeNormalize(WorldView);

        //Additional Lights cannot be directional lights
        //Additional lights are the set of non-culled spot and point lights (culling done by distance)
        //if you want to see culling in action set the diffuse color based on additional light count 
        int lightCount = GetAdditionalLightsCount();
        for(int i = 0; i < lightCount; i++){
            Light light = GetAdditionalLight(i,WorldPosition);
            half3 attenuatedLightColor = light.color * (light.distanceAttenuation * light.shadowAttenuation);
            diffuseColor += LightingDiffuseToon(attenuatedLightColor, light.direction, WorldNormal, ShadowSoftness);
            specularColor += LightingSpecToon(attenuatedLightColor, light.direction, WorldNormal, WorldView, half4(SpecularColor,1), Smoothness, SpecularSoftness);
        }


    #endif 
    Diffuse = diffuseColor;
    Specular = specularColor;
}

void DirectSpecular_half(half3 Specular, half Smoothness, half3 LightDirection, half3 LightColor, half3 WorldNormal, half3 WorldView, out half3 SpecularColor){
    #if SHADERGRAPH_PREVIEW
        SpecularColor = 0;  
    #else 
        Smoothness = exp2(10 * Smoothness + 1); //exp2(x) is equivilant to 2^x so... 2^(10 * Smoothness + 1)
        WorldNormal = normalize(WorldNormal); 
        WorldView = SafeNormalize(WorldView); //SafeNormalize is a normalize function that takes into account 0 length vectors
        SpecularColor = LightingSpecular(LightColor,LightDirection, WorldNormal,WorldView, half4(Specular,1), Smoothness);
    #endif
}



void ToonSpecular_half(half3 Specular, half Smoothness, half3 LightDirection, half3 LightColor, half3 WorldNormal, half3 WorldView, half SpecularSoftness , out half3 SpecularColor){
    #if SHADERGRAPH_PREVIEW
        SpecularColor = 0;  
    #else 
        Smoothness = exp2(10 * Smoothness + 1); //exp2(x) is equivilant to 2^x so... 2^(10 * Smoothness + 1)
        WorldNormal = normalize(WorldNormal); 
        WorldView = SafeNormalize(WorldView); //SafeNormalize is a normalize function that takes into account 0 length vectors
        SpecularColor = LightingSpecToon(LightColor,LightDirection, WorldNormal,WorldView, half4(Specular,1), Smoothness,SpecularSoftness);
    #endif
}





/******************************************* Physically Based Lighting and Gloabl Illumination *************************************/



void DirectPBR_half(){

}