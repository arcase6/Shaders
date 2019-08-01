Shader "Hidden/AddSmoke"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Radius ("Smoke Radius", Range(.001,.3)) = .05
        _Center("Smoke Center", Vector) = (.5,.5,0,0)
        _SmokeColor("Smoke Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            fixed _Radius;
            fixed2 _Center;
            half4 _SmokeColor;

            fixed4 frag (v2f_img i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

                fixed drawFog = saturate(length(i.uv - _Center) - _Radius);
                drawFog = step(drawFog,.01);
                col = lerp(col,_SmokeColor,drawFog);


                return col;
            }
            ENDCG
        }
    }
}
