Shader "Hidden/ComparisonMerge"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _CompTex("Comparison Texture", 2D) = "white"{}
        _BlendAmmount("Blend Ammount",Range(0,1)) = .5 
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
            sampler2D _CompTex;
            fixed _BlendAmmount;

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 col2 = tex2D(_CompTex,i.uv);


                
                return lerp(col,col2,step(_BlendAmmount,i.uv.x));
            }
            ENDCG
        }
    }
}
