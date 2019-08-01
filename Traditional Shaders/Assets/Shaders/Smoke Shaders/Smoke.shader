Shader "Unlit/Smoke"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SmokeColor("Smoke Color", Color) = (1,1,1,1)
        _DiffusionWeights("Weights", Vector) = (.25,.25,.25,.25)
        _DiffusionRate("Diffusion Rate", Range(0,2)) = .5
        _Minimum("Minimum Flow", Range(0,.01)) = .003
        _PixelsX("Pixels", Float) = 1920
        _PixelsY("Pixels", Float) = 1080
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            half4 _SmokeColor;
            float4 _MainTex_ST;
            fixed4 _DiffusionWeights;
            float _PixelsX;
            float _PixelsY;
            fixed _DiffusionRate;
            fixed _Minimum;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 _Pixels = float2(_PixelsX,_PixelsY); 
                //Cell center
                fixed2 uv = round(i.uv * _Pixels) / _Pixels;

                //Neighbor cells
                half2 step = 1/_Pixels;
                float currentAlpha = saturate(tex2D(_MainTex,uv).a);
                
                float changeInAlpha = (tex2D(_MainTex, uv + fixed2(-step.x,0)).a * _DiffusionWeights.x);
                changeInAlpha += (tex2D(_MainTex,uv + fixed2(0,-step.y)).a * _DiffusionWeights.y);
                changeInAlpha += (tex2D(_MainTex,uv + fixed2(step.x,0)).a * _DiffusionWeights.z);
                changeInAlpha += (tex2D(_MainTex,uv + fixed2(0,step.y)).a * _DiffusionWeights.w);

                changeInAlpha -= currentAlpha;
                changeInAlpha *= _DiffusionRate;

                //Minimum flow
                if(changeInAlpha >= -_Minimum && changeInAlpha <= 0){
                    changeInAlpha = -_Minimum;
                }
                
                


                currentAlpha = saturate(currentAlpha +  changeInAlpha);


                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return float4(_SmokeColor.xyz,currentAlpha);
            }
            ENDCG
        }
    }
}
