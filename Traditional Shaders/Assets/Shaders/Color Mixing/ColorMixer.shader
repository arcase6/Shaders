Shader "Hidden/ColorMixer"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _R("Red Mixing", Color) = (1,0,0,1)
        _G("Green Mixing", Color) = (0,1,0,1)
        _B("Blue Mixing", Color) = (0,0,1,1)
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            fixed4 _R;
            fixed4 _G;
            fixed4 _B;

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                // just invert the colors
                col = fixed4(
                    col.r * _R.x + col.g * _R.y + col.b * _R.z,
                    col.r * _G.x + col.g * _G.y + col.b * _G.z,
                    col.r * _B.x + col.g * _B.y + col.b * _B.z,
                    col.a
                );
                return col;
            }
            ENDCG
        }
    }
}
