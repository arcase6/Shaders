Shader "Hidden/OverlayCamera"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OverlayImage("Overlay Image",2D) = "white"{}
        _OverlayAlpha("Overlay Alpha", Range(0,1)) = 1
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
            sampler2D _OverlayImage;
            fixed _OverlayAlpha;

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 overlay = tex2D(_OverlayImage,i.uv);

                col  = lerp(col,overlay,_OverlayAlpha * overlay.a);

                return col;
            }
            ENDCG
        }
    }
}
